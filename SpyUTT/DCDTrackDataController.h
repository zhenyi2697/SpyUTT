//
//  DCDTrackDataController.h
//  DemoCoreData
//
//  Created by Zhenyi ZHANG on 2012-11-06.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBTrack+CreateTrack.h"
#import "SBTrack.h"
#import "DCDTrackDataController.h"

@interface DCDTrackDataController : NSObject
@property (nonatomic,strong) UIManagedDocument *trackDatabase;

- (void)saveTrack:(NSDictionary *)track;
- (NSArray *)fetchAllTracks;
- (NSArray *)fetchAllTracksWithDays:(NSArray *)days WithBeginTime:(NSDate *)beginTime WithEndTime:(NSDate *)endTime;
@end
