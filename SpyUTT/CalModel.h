//
//  CalModel.h
//  CalSpy
//
//  Created by Zhang on 09/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLWriter.h"

@interface CalModel : NSObject

- (NSArray*)retrieveEventsFrom:(NSDate*)dateBegin To:(NSDate*)dateEnd inCalendars:(NSArray *)calendars;
- (NSArray*)generateSectionsByIteratingEventsArray: (NSArray*)events;
- (NSArray*)retrieveAllCalendars;
- (void)sendEvents:(NSArray *)events WithCallback:(void (^)(void))callback inContext:(id)context;
- (NSString *)prepareText;
@end
