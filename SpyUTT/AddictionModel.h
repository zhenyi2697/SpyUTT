//
//  AddictionModel.h
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddictionModel : NSObject

- (void)saveTrack;

- (NSMutableDictionary *)retrieveAppDictionaryWithDays:(NSArray *)days BeginTime:(NSDate *)beginTime ToTime:(NSDate *)endTime;

- (NSDictionary *)retrieveAppsUtilisationTime;

@end
