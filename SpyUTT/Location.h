//
//  Location.h
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Track;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSDate * currentTime;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) Track *whoTracked;

@end
