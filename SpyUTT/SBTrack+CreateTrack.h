//
//  SBTrack+CreateTrack.h
//  ProcSpy
//
//  Created by Zhang on 25/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "SBTrack.h"

@interface SBTrack (CreateTrack)

+(SBTrack *)trackWithTime:(NSDate *)time WithBundleId:(NSString *)bundleid inManagedContext:(NSManagedObjectContext *)context;

@end
