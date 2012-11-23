//
//  Location+Create.m
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "Location+Create.h"

@implementation Location (Create)

+(void)locationWithLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude trackedBy:(Track *)track inManagedContext:(NSManagedObjectContext*) context
{
    Location *location = nil;
    location = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                             inManagedObjectContext:context];
    location.longitude = longitude;
    location.latitude = latitude;
    location.whoTracked = track;
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
    self.currentTime = [self localDate];
}

@end
