//
//  PROCSecondViewController.h
//  ProcSpy
//
//  Created by Zhang on 25/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iHasApp.h"
#import "AppCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PROCSecondViewController : UITableViewController


@property iHasApp *detectionObject;
@property (nonatomic, strong) NSArray *detectedApps;

@end
