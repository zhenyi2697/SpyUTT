//
//  SDDeviceInfoTableViewController.h
//  SpyDevice
//
//  Created by Zhenyi ZHANG on 2012-11-22.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLWriter.h"

@interface SDDeviceInfoTableViewController : UITableViewController
- (IBAction)toggleSensor:(UIBarButtonItem *)sender;
- (NSString *)prepareText;
@end
