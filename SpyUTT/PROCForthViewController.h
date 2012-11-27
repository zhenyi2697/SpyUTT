//
//  PROCForthViewController.h
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CoreLocation.h>

@interface PROCForthViewController : UITableViewController <CLLocationManagerDelegate>

@property(strong,nonatomic) NSDictionary *result;

@end
