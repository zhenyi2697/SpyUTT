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
#import "RemMasterViewController.h"
#import "RemModel.h"
#import "SPMasterViewController.h"
#import "SPPhotoLibraryController.h"
#import "PROCFirstViewController.h"
#import "SGTrackListViewController.h"
#import "SUAppDelegate.h"
#import "CalModel.h"
#import "CalMasterViewController.h"

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
//        ABDContactController *aDataController = [[ABDContactController alloc] init];
        ABDContactController *aDataController = [[ABDContactController alloc] initWithDelegate:contactMasterViewController];
        contactMasterViewController.contactController = aDataController;
    } else if ([segue.identifier isEqualToString:@"SUShowReminder"]) {
        RemMasterViewController *remMasterViewController = (RemMasterViewController *)segue.destinationViewController;
        //RemModel *remModel = [[RemModel alloc] init];
        RemModel *remModel = [[RemModel alloc] initWithDelegate:remMasterViewController];
        remMasterViewController.model = remModel;
    } else if([segue.identifier isEqualToString:@"SUShowPhotos"]) {
        SPMasterViewController *photoMasterViewController = (SPMasterViewController *)segue.destinationViewController;
        SPPhotoLibraryController *photoDataController = [[SPPhotoLibraryController alloc] init];
        photoMasterViewController.photoLibraryController = photoDataController;
        photoDataController.delegate = photoMasterViewController;
    } else if ([segue.identifier isEqualToString:@"SUShowProcs"]) {
        PROCFirstViewController *procFirstViewController = (PROCFirstViewController *)segue.destinationViewController;
        NSDictionary *processes = [[UIDevice currentDevice] runningProcesses];
        procFirstViewController.processes = processes;
    } else if([segue.identifier isEqualToString:@"SUShowGeo"]) {
        SGTrackListViewController *trackListController = (SGTrackListViewController *)segue.destinationViewController;
        trackListController.trackDatabase = [(SUAppDelegate *)[[UIApplication sharedApplication] delegate] databaseController].trackDatabase;
    } else if([segue.identifier isEqualToString:@"SUShowCal"]){
        //do something here...
    }
}



- (IBAction)showInfo:(UIButton *)sender {
}
@end
