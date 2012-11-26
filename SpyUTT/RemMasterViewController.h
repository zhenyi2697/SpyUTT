//
//  RemMasterViewController.h
//  RemSpy
//
//  Created by Zhang on 15/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemModel.h"

@interface RemMasterViewController : UITableViewController <RemModelDelegate>

@property (nonatomic) RemModel *model;
@property (nonatomic) UINavigationController *navControl;

@end
