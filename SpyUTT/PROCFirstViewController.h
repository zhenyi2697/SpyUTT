//
//  PROCFirstViewController.h
//  ProcSpy
//
//  Created by Zhang on 25/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTDevice.h"
#import "PROCCell.h"

@interface PROCFirstViewController : UITableViewController
{
    NSTimer *theTimer;
}

@property (strong, nonatomic) NSDictionary *processes;

@end
