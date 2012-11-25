//
//  PROCDaysChooserViewController.h
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PROCThirdViewController.h"
@class PROCDaysChooserViewController;

@protocol DaysChooserViewDelegate <NSObject>

- (void)chooseDays:(NSArray *)days forView:(PROCDaysChooserViewController *)sender;

@end

@interface PROCDaysChooserViewController : UITableViewController

@property (nonatomic,strong) id delegate;
@property (nonatomic, strong) NSArray *days;
- (IBAction)clickDone:(id)sender;

@end


