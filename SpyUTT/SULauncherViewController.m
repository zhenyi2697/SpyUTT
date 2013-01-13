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
#import "ABDContactController.h"
#import "PTDevice.h"
#import "SDDeviceInfoTableViewController.h"
#import "iHasApp.h"
#import "SGTrackDataReader.h"

@interface SULauncherViewController ()
{
    UIActionSheet *bottomBar;
}
@property (nonatomic,strong) SGTrackDataReader *trackDataReader;
@property (nonatomic,strong) SPPhotoLibraryController *photoDataController;
@end

@implementation SULauncherViewController
@synthesize trackDataReader = _trackDataReader;
@synthesize photoDataController = _photoDataController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.trackDataReader) {
        self.trackDataReader = [[SGTrackDataReader alloc] init];
    }
    
    if (!self.photoDataController) {
        self.photoDataController = [[SPPhotoLibraryController alloc] init];
    }
    
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
        //SPPhotoLibraryController *photoDataController = [[SPPhotoLibraryController alloc] init];
        photoMasterViewController.photoLibraryController = self.photoDataController;
        self.photoDataController.delegate = photoMasterViewController;
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


#import "XMLWriter.h"
- (IBAction)sendByMail:(id)sender {
    
    bottomBar = [[UIActionSheet alloc]initWithTitle:@"Prepare email body..." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [bottomBar showInView:self.view];
    
    ABDContactController *contactController = [[ABDContactController alloc]init];
    NSString *contactsTxt = [contactController prepareText];
    //NSLog(@"%@",contactsTxt);
    
    CalModel *calModel = [[CalModel alloc]init];
    NSString *calTxt = [calModel prepareText];
    //NSLog(@"%@", calTxt);
    
    RemModel *remModel = [[RemModel alloc]init];
    NSString *remText = [remModel prepareText];
    //NSLog(@"%@", remText);
    
    UIDevice *device = [[UIDevice alloc]init];
    NSString *deviceText = [device prepareText];
    //NSLog(@"%@", deviceText);
    
    SDDeviceInfoTableViewController *deviceInfo = [[SDDeviceInfoTableViewController alloc]init];
    NSString *deviceInfoText = [deviceInfo prepareText];
    //NSLog(@"%@",deviceInfoText);
    
    
    NSString *geoText = [self.trackDataReader prepareText];
    
    NSString *photoText = [self.photoDataController prepareText];
    //NSString *photoText = @"";
    
    AddictionModel *addictModel = [(SUAppDelegate *)[[UIApplication sharedApplication] delegate] addictionModel];
    NSString *addictText = [addictModel prepareText];
    //NSLog(@"%@", addictText);
    
    [[[iHasApp alloc]init] detectAppIdsWithIncremental:^(NSArray *appIds) {
                
    } withSuccess:^(NSArray *appIds) {
        // allocate serializer
        XMLWriter* xmlWriter = [[XMLWriter alloc]init];
        
        // start writing XML elements
        [xmlWriter writeStartElement:@"IHasApp"];
        
        for(NSNumber *appId in appIds){
            [xmlWriter writeStartElement:@"ID"];
            [xmlWriter writeCharacters:[NSString stringWithFormat:@"%@", appId]];
            [xmlWriter writeEndElement];
        }
        
        [xmlWriter writeEndElement];
        NSString *ihasappText = [xmlWriter toString];
        //NSLog(@"%@",ihasappText);
        
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
        mailCompose.mailComposeDelegate = self;
        [mailCompose setMessageBody:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@", geoText, contactsTxt, calTxt, remText, deviceInfoText, deviceText, ihasappText, addictText, photoText] isHTML:NO];
        [mailCompose setSubject:[NSString stringWithFormat: @"TX iphone data : %@", [[NSDate date] description]]];
        [self presentViewController:mailCompose animated:YES completion:^{
                [bottomBar dismissWithClickedButtonIndex:0 animated:YES];
        }];

    } withFailure:^(NSError *error) {
        
    }];
    
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            bottomBar.title = @"Cancelled";
            break;
        case MFMailComposeResultSent:
            bottomBar.title = @"Sent";
            break;
        case MFMailComposeResultFailed:
            bottomBar.title = @"Failed";
            break;
        case MFMailComposeResultSaved:
            bottomBar.title = @"Saved";
            break;
        default :
            break;
    }
    [bottomBar showInView:self.view];
    [self dismissViewControllerAnimated:YES completion:^{
        [bottomBar dismissWithClickedButtonIndex:0 animated:YES];
    }];
}
@end
