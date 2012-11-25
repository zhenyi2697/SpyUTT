//
//  SBTrack+CreateTrack.m
//  ProcSpy
//
//  Created by Zhang on 25/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "SBTrack+CreateTrack.h"

@implementation SBTrack (CreateTrack)

+(SBTrack *)trackWithTime:(NSDate *)time WithBundleId:(NSString *)bundleid inManagedContext:(NSManagedObjectContext *)context
{
    
    //__block Track *track = nil;
    SBTrack *track = nil;
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
    track = [NSEntityDescription insertNewObjectForEntityForName:@"SBTrack"
                                          inManagedObjectContext:context];
    track.time = time;
    track.bundleid = bundleid;
    
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSCalendar* dCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int timeFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    unsigned int dayFlag = NSWeekdayCalendarUnit;
    NSDateComponents* tComponents = [calendar components:timeFlags fromDate:time];
    NSDateComponents* dComponnents = [dCal components:dayFlag fromDate:time];
    track.timeOnly = [calendar dateFromComponents:tComponents];
    if(dComponnents.weekday == 1){
        track.day = [NSNumber numberWithInteger: 6];
    }else{
        track.day = [NSNumber numberWithInteger: dComponnents.weekday - 2];
    }
    
    
    /*dispatch_sync(dispatch_get_main_queue(), ^{
     
     });
     });*/
    
    return track;
}

@end
