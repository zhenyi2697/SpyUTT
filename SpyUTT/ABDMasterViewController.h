//
//  ABDMasterViewController.h
//  ABDemo
//
//  Created by Zhenyi ZHANG on 2012-10-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import "ABDContactController.h"
#import "ABDContentCell.h"

@interface ABDMasterViewController : UITableViewController <ABDContactControllerDelegate>

@property (strong, nonatomic) ABDContactController *contactController;
- (IBAction)sendContacts:(UIBarButtonItem *)sender;

@end
