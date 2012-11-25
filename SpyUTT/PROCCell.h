//
//  PROCCell.h
//  ProcSpy
//
//  Created by Zhang on 05/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PROCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIView *typeColor;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *pid;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *procIcon;

@end
