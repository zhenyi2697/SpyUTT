//
//  CalChooseCalendarViewController.h
//  CalSpy
//
//  Created by Zhang on 11/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalCalendarCell.h"
#import <EventKit/EventKit.h>
@protocol CalChooseCalendarViewControllerDelegate;

@interface CalChooseCalendarViewController : UITableViewController

@property (strong,nonatomic) NSArray *calsList;
@property (strong,nonatomic) NSArray *calsSelected;
@property (weak, nonatomic) id <CalChooseCalendarViewControllerDelegate> delegate;
- (NSString *)calsSelectedToString;
- (NSArray *)calsSelectedData;
- (IBAction)done:(id)sender;

@end


@protocol CalChooseCalendarViewControllerDelegate <NSObject>
- (void)addChoosingCalendarViewControllerDidFinished:(CalChooseCalendarViewController *)controller;
@end