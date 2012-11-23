//
//  CalDetailViewController.h
//  CalSpy
//
//  Created by Zhang on 09/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalDetailCell.h"
#import "CalModel.h"
#import <EventKit/EventKit.h>

@interface CalDetailViewController : UITableViewController

//@property (strong, nonatomic) NSArray *detailItem;
@property (strong, nonatomic) NSArray *sections;
@property (nonatomic) CalModel *model;
@property (strong, nonatomic) NSArray *events;
- (IBAction)sendData:(id)sender;


@end
