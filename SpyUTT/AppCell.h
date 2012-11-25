//
//  AppCell.h
//  ProcSpy
//
//  Created by Zhang on 05/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;

@end
