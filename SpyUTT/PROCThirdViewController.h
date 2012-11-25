//
//  PROCThirdViewController.h
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PROCDaysChooserViewController.h"
#import "AddictionModel.h"
#import "PROCAddictionResultViewController.h"

@interface PROCThirdViewController : UITableViewController <DaysChooserViewDelegate>

@property (strong,nonatomic) NSDate *beginTime;
@property (strong,nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSMutableArray *days;

@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

- (IBAction)timePickerValueChanged:(id)sender;
- (IBAction)backToTotal:(UIBarButtonItem *)sender;

@end
