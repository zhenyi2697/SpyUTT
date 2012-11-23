//
//  Track+Create.m
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-01.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "Track+Create.h"

@implementation Track (Create)

+(Track *)trackWithType:(NSString *)type andInterval:(NSNumber *)intervalInMinute inManagedContext:(NSManagedObjectContext *)context
{
    
    Track *track = nil;
    track = [NSEntityDescription insertNewObjectForEntityForName:@"Track"
                                                 inManagedObjectContext:context];
    track.type = type;
    track.interval = intervalInMinute;
    
    return track;
}

- (NSDate *)localDate
{
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return destinationDate;
}

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    self.startTime = [self localDate];
}

@end
