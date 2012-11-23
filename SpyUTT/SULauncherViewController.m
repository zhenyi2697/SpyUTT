//
//  SULauncherViewController.m
//  SpyUTT
//
//  Created by Zhenyi ZHANG on 2012-11-23.
//  Copyright (c) 2012 Zhenyi Zhang. All rights reserved.
//

#import "SULauncherViewController.h"
#import "ABDMasterViewController.h"
#import "ABDContactController.h"

@interface SULauncherViewController ()

@end

@implementation SULauncherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SUShowContacts"]) {
        ABDMasterViewController *contactMasterViewController =  (ABDMasterViewController *)segue.destinationViewController;
        ABDContactController *aDataController = [[ABDContactController alloc] init];
        contactMasterViewController.contactController = aDataController;
    }
}



@end
