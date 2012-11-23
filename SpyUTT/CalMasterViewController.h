//
//  CalMasterViewController.h
//  CalSpy
//
//  Created by Zhang on 09/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalModel.h"
#import "CalChooseCalendarViewController.h"

@interface CalMasterViewController : UITableViewController <CalChooseCalendarViewControllerDelegate>

@property (nonatomic) CalModel *model;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerValueChange:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *calendars;
@property NSArray *selectedCalendarsIndexPaths;
@property NSArray *selectedCalendars;

@end
