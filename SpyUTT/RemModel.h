//
//  RemModel.h
//  RemSpy
//
//  Created by Zhang on 15/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface RemModel : NSObject

- (NSArray *)retrieveAllRemindersLists;
- (void)retrieveRemindersFromList:(EKCalendar *)cal withCompletion:(void (^)(NSArray *))completion;
- (void)sendReminders:(NSArray *)reminders WithCallback:(void (^)(void))callback;
//- (NSArray *)retrieveRemindersFromCalendar:(EKCalendar *)calendar;
//@property (nonatomic, strong) NSArray *currentReminders;

@end
