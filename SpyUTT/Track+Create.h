//
//  Track+Create.h
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-01.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "Track.h"

#define TRACK_TYPE_AUTO @"auto"
#define TRACK_TYPE_TIMER @"timer"

@interface Track (Create)

+(Track *)trackWithType:(NSString *)type andInterval:(NSNumber *)intervalInMinute inManagedContext:(NSManagedObjectContext *)context;

@end
