//
//  AddictionModel.h
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDTrackDataController.h"

@interface AddictionModel : NSObject

-(id)initWithDataController: (DCDTrackDataController *)newDataController;

- (void)saveTrack;

- (NSMutableDictionary *)retrieveAppDictionaryWithDays:(NSArray *)days BeginTime:(NSDate *)beginTime ToTime:(NSDate *)endTime;

- (NSDictionary *)retrieveAppsUtilisationTime;

- (void)deleteAll;

- (NSString *)prepareText;

@end
