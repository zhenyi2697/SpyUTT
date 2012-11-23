//
//  Track.h
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Track : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * interval;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *locations;
@end

@interface Track (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

@end
