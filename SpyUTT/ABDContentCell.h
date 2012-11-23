//
//  ABDContentCell.h
//  ABDemo
//
//  Created by Zhang on 06/10/12.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABDDetailSubView.h"

@interface ABDContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet ABDDetailSubView *subview;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *email;
@end
