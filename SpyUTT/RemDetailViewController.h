//
//  RemDetailViewController.h
//  RemSpy
//
//  Created by Zhang on 15/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemEventDetailCell.h"
#import <EventKit/EventKit.h>
#import "RemModel.h"

@interface RemDetailViewController : UITableViewController

@property (strong, nonatomic) RemModel *model;
@property (strong, nonatomic) NSArray *reminders;
@property (weak, nonatomic) IBOutlet UINavigationItem *remindersTitle;
- (IBAction)sendReminders:(id)sender;

@end
