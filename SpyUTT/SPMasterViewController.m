//
//  SPMasterViewController.m
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-10-20.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SPMasterViewController.h"

#import "SPPhotoCell.h"
#import "SPPhotoMapViewController.h"
#import "SPPhotoAnnotation.h"
#import "SPAllDetailsViewController.h"

@interface SPMasterViewController ()
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation SPMasterViewController

@synthesize photoLibraryController = _photoLibraryController;

-(void)setPhotoLibraryController:(SPPhotoLibraryController *)photoLibraryController
{
    if (_photoLibraryController != photoLibraryController) {
        _photoLibraryController = photoLibraryController;
        [self.tableView reloadData];
    }
}

-(void)updateProgress:(float)progress
{
    self.progressView.progress = progress;
}

-(void)showProgressAlertView
{
    //show alert view
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"SpyPhoto"
                                                        message:@"Loading photos..."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.frame = CGRectMake(30, 80, 225, 30);
    [alertView addSubview:self.progressView];
    [alertView show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.photoLibraryController.allPhotosAreLoaded) {
        [self showProgressAlertView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photoLibraryController numberOfPhotoInLibrary];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[SPPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"photoCell"];
    }
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //[formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    //configure view here...
    ALAsset *asset = [self.photoLibraryController photoAtIndex:indexPath.row];
    [cell.thumbnail setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
    ALAssetRepresentation *presentation = [asset defaultRepresentation];
    NSString *imageName = [presentation filename];
    cell.imageName.text = imageName;
    NSDate *imageDate = [asset valueForProperty:ALAssetPropertyDate];
    
    cell.imageDate.text = [formatter stringFromDate:imageDate];
    
    //image size
    long long size = [[asset defaultRepresentation] size];
    float sizeInFloat = (long double)size/(1024 * 1024);
    cell.sizeLabel.text = [NSString stringWithFormat:@"%.2f MB",sizeInFloat];
    
    //image coordinate
    NSString *coordinatStringValue = @"None";
    NSString *indexInString = [NSString stringWithFormat:@"%d",indexPath.row];
    NSDictionary *coordinateDic = [self.photoLibraryController.photoGPSInfoDic objectForKey:indexInString];
    if (coordinateDic) {
        coordinatStringValue = [self getCoordinateStringFromGPSInfo:coordinateDic];
    }
    
    cell.coordinateLabel.text = coordinatStringValue;
    
    return cell;
}

-(NSString *)getCoordinateStringFromGPSInfo:(NSDictionary *)gpsInfo
{
    NSString *value = [NSString stringWithFormat:@"%.6f, %.6f",[(NSNumber *)[gpsInfo objectForKey:@"Latitude"] doubleValue],[(NSNumber *)[gpsInfo objectForKey:@"Longitude"] doubleValue]];
    return value;
}

-(NSArray *)photoAnnotationsWithGPSInfo:(NSDictionary *)GPSInfoDic
{    
    NSArray *allKeys = [GPSInfoDic allKeys];
    NSDictionary *dic;
    ALAsset *photo;
    
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *string1, NSString *string2) {
        return [string1 intValue] - [string2 intValue];
    }];
    
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:0];
    int index = 0;
    for (NSString *key in allKeys) {
        dic = [GPSInfoDic objectForKey:key];
        index = [key intValue];
        photo = [self.photoLibraryController photoAtIndex:index];
        [annotations addObject:[SPPhotoAnnotation annotationForPhoto:photo andMetaData:dic]];
    }
    return annotations;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPhotoDetail"]) {
        SPAllDetailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.photo = [self.photoLibraryController photoAtIndex:[self.tableView indexPathForSelectedRow].row];
        
    } else if([[segue identifier] isEqualToString:@"showMapForAllPhotos"]) {
        SPPhotoMapViewController *mapViewController = (SPPhotoMapViewController *)[[segue.destinationViewController viewControllers] objectAtIndex:0];
        
        mapViewController.annotations = [self photoAnnotationsWithGPSInfo:self.photoLibraryController.photoGPSInfoDic];
        mapViewController.currentMap = MAP_SHOWS_ALL_PHOTOS;
    }
}

-(void)photoLibraryControllerhasFinishedEnumeratingPhotos:(SPPhotoLibraryController *)sender
{
    [self.tableView reloadData];
    if ([self.progressView.superview isKindOfClass:[UIAlertView class]]) {
        UIAlertView* alertView = (UIAlertView*)self.progressView.superview;
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
}

-(void)photoLibraryController:(SPPhotoLibraryController *)sender hasUpdatedProgress:(float)progress
{
    [self updateProgress:progress];
}

@end
