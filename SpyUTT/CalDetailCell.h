//
//  CalDetailCell.h
//  CalSpy
//
//  Created by Zhang on 09/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UILabel *calendar;
@property (weak, nonatomic) IBOutlet UIView *calendarColor;

@end
