//
//  SGTrackListViewController.m
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-01.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SGTrackListViewController.h"
#import "SGMapViewController.h"
#import "SGLocationAnnotation.h"
#import "Track+Create.h"
#import "Location+Create.h"

@interface SGTrackListViewController ()
@property (nonatomic,strong) Track *currentTrack;
@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (weak, nonatomic) NSTimer *trackTimer;
@end

@implementation SGTrackListViewController

@synthesize trackDatabase = _trackDatabase;
@synthesize addTrackButton = _addTrackButton;
@synthesize locationManager = _locationManager;
@synthesize currentTrack = _currentTrack;
@synthesize trackTimer = _trackTimer;
@synthesize lastCoordinate = _lastCoordinate, currentCoordinate = _currentCoordinate;

-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.distanceFilter = 50;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        _locationManager = locationManager;
    }
    return _locationManager;
}

#define LOCATION_CHANGED_THRESHELD 0.0005  //0.0005

- (BOOL)locationHasChanged
{
    double latitudeDifference = fabs(self.currentCoordinate.latitude - self.lastCoordinate.latitude);
    double longitudeDifference = fabs(self.currentCoordinate.longitude - self.lastCoordinate.longitude);
    //NSLog(@"latitudeDifference: %f and longitudeDifference: %f",latitudeDifference,longitudeDifference);
    if (latitudeDifference < LOCATION_CHANGED_THRESHELD &&
        longitudeDifference < LOCATION_CHANGED_THRESHELD) {
        return NO;
    } else {
        return YES;
    }
}

- (void)setLocationManager:(CLLocationManager *)locationManager
{
    if (_locationManager != locationManager) {
        _locationManager = locationManager;
    }
}

-(void)setupFetchedResultsController
{
    //需要在头文件里设定这个类的父类为CoreDataTableViewController
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    //如果想要所有的entity，那么不用specify request的predicate
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startTime"
                                                                                     ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.trackDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
}

-(void)deleteAllTracks
{
    NSFetchRequest * allTracks = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *myContext = self.trackDatabase.managedObjectContext;
    [allTracks setEntity:[NSEntityDescription entityForName:@"Track" inManagedObjectContext:myContext]];
    [allTracks setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * tracks = [myContext executeFetchRequest:allTracks error:&error];
    
    //error handling goes here
    for (NSManagedObject *track in tracks) {
        [myContext deleteObject:track];
    }
    NSError *saveError = nil;
    [myContext save:&saveError];
}

-(void)addSampleTrack
{
    [Track trackWithType:TRACK_TYPE_TIMER andInterval:[NSNumber numberWithInt:5] inManagedContext:self.trackDatabase.managedObjectContext];
}

////用于在磁盘新建文档，打开文档等操作
//-(void)useDocument
//{
//    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.trackDatabase.fileURL path]]) {//如果这个database在磁盘里不存在，那么就创建数据库
//        [self.trackDatabase saveToURL:self.trackDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
//            [self setupFetchedResultsController]; // 这里不用等待下一行的fetch结束，因为一旦hook上了controller，如果数据库更新，controller会自动更新数据
//            
//            //可以再此预添加数据
//            //[self deleteAllTracks];//先删除所有之前的track
//        }];
//    }else if (self.trackDatabase.documentState == UIDocumentStateClosed) { //如果数据库被关闭里，那么就打开它
//        [self.trackDatabase openWithCompletionHandler:^(BOOL success){
//            [self setupFetchedResultsController];
//            //删除之前所有数据
//            //[self deleteAllTracks];
//        }];
//    } else if (self.trackDatabase.documentState == UIDocumentStateNormal) { //如果状态正常（已经被打开了）
//        //我们需要初始化fetchController，以便获取数据
//        [self setupFetchedResultsController];
//        //删除之前所有数据
//        //[self deleteAllTracks];
//    }
//}

-(void)setTrackDatabase:(UIManagedDocument *)trackDatabase
{
    if (_trackDatabase != trackDatabase) {
        _trackDatabase = trackDatabase;
        [self setupFetchedResultsController];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (!self.trackDatabase) {
//        //创建一个database需要一个url，所以先创建url（url其实就是文件目录）
//        //get document directory as a url
//        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//        //在url后面append一个子目录
//        url = [url URLByAppendingPathComponent:@"Default Track Database"];
//        //之后创建database就好了
//        self.trackDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Track Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Track *track = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [track.startTime description];
    NSString *detailText = track.type;
    int locationNumbers = [track.locations count];
    if([track.type isEqualToString:TRACK_TYPE_TIMER]) detailText = [detailText stringByAppendingFormat:@" mode %.0f minutes, %d track available", [track.interval doubleValue], locationNumbers];
    else detailText = [detailText stringByAppendingFormat:@" mode, %d track available", locationNumbers];
    
    cell.detailTextLabel.text = detailText;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        // Delete code goes here. This is from Core data sample code to delete record. You can implement your own code here.
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
        if (![context save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
    }   
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Track"]) {
        SGAddTrackViewController *addViewController = (SGAddTrackViewController *)[[segue.destinationViewController viewControllers] objectAtIndex:0];
        addViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Show Map"]) {
        SGMapViewController *mapViewController = segue.destinationViewController;
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Track *selectedTrack = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
        //fetch locations here...
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"currentTime"
                                                                                         ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTracked.startTime = %@",selectedTrack.startTime];
        NSError *error = nil;
        NSArray *locations = [self.trackDatabase.managedObjectContext executeFetchRequest:request error:&error];
        //create annotations from locations and set to mapView
        NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[locations count]];
        for (Location *location in locations) {
            [annotations addObject:[SGLocationAnnotation annotationForLocation:location]];
        }
        mapViewController.annotations = annotations;
    }
}

-(void)resetFlagCoordinates
{
    self.currentCoordinate = CLLocationCoordinate2DMake(0, 0);
    self.lastCoordinate = CLLocationCoordinate2DMake(0, 0);
}

-(void)stopTracking
{
    self.navigationItem.rightBarButtonItem = self.addTrackButton;
    [self.locationManager stopUpdatingLocation];
    //[self.locationManager stopMonitoringSignificantLocationChanges];
    [self.trackTimer invalidate];
    [self resetFlagCoordinates];
    //NSLog(@"tracking stopped....");
}

-(void)saveLocationToDatabaseWithCoordinate:(CLLocationCoordinate2D) coordinate
{
    [Location locationWithLatitude:[NSNumber numberWithDouble:coordinate.latitude] andLongitude:[NSNumber numberWithDouble:coordinate.longitude] trackedBy:self.currentTrack inManagedContext:self.trackDatabase.managedObjectContext];
    
    //then, update self.lastCoordinate and self.currentCoordinate
    self.lastCoordinate = coordinate;
    
    //NSLog(@"save to database %f %f",coordinate.latitude, coordinate.longitude);
}

-(void)track
{
    NSLog(@"Time remaining... %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
    double timeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    int locationUpdateInterval = [self.currentTrack.interval doubleValue] * 60;
    
    if (locationUpdateInterval > timeRemaining) {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startUpdatingLocation];
    }
    
    if ([self locationHasChanged]) {
        //NSLog(@"location has changed, store in database");
        CLLocationCoordinate2D coordinate = self.currentCoordinate;
        [self saveLocationToDatabaseWithCoordinate:coordinate];
    } else {
        //NSLog(@"location has not changed, do nothing...");
    }
}

-(void)track:(NSTimer *)timer{
    [self track];
}

-(void)startTracking
{
    if ([self.currentTrack.type isEqualToString:TRACK_TYPE_TIMER]) {
        double interval = [self.currentTrack.interval doubleValue];
        interval = interval * 60;
        UIBackgroundTaskIdentifier bgTask;
        bgTask= [[UIApplication sharedApplication]
                  beginBackgroundTaskWithExpirationHandler:
                  ^{
                      
                  }];
        self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(track:) userInfo:nil repeats:YES];
    }
}

-(void)addTrackViewController:(SGAddTrackViewController *)sender didAddedTrackWithType:(NSString *)type andInterval:(NSNumber *)intervalInMinute
{
    //NSLog(@"type : %@ and interval: %d",type, [intervalInMinute intValue]);
    if ([type isEqualToString:TRACK_TYPE_AUTO]) intervalInMinute = 0;
    Track *track = [Track trackWithType:type andInterval:intervalInMinute inManagedContext:self.trackDatabase.managedObjectContext];
    self.currentTrack = track;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stopTracking)];
    self.navigationItem.leftBarButtonItem = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.locationManager startUpdatingLocation];
    //[self.locationManager startMonitoringSignificantLocationChanges];
    [self startTracking];
    
}

#pragma mark -- cllocation manager delegate
/* deprecated, use locationManager:didUpdateLocations instead
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Old Location: %@",[oldLocation description]);
    //NSLog(@"New Location: %@", [newLocation description]);
    self.currentCoordinate = newLocation.coordinate;
    
    //CLLocationCoordinate2D coordinate = newLocation.coordinate;
    //[Location locationWithLatitude:[NSNumber numberWithDouble:coordinate.latitude] andLongitude:[NSNumber numberWithDouble:coordinate.longitude] trackedBy:self.currentTrack inManagedContext:self.trackDatabase.managedObjectContext];
}
*/

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations objectAtIndex:0];
    self.currentCoordinate = newLocation.coordinate;
    //NSLog(@"in didUpdateLocation: %@",[newLocation description]);
    if ([self.currentTrack.type isEqualToString:TRACK_TYPE_AUTO] && [self locationHasChanged]) {
        [self saveLocationToDatabaseWithCoordinate:newLocation.coordinate];
    } else if([self.currentTrack.type isEqualToString:TRACK_TYPE_TIMER] && self.lastCoordinate.latitude == 0 && self.lastCoordinate.longitude == 0) { // store the very first data into database
        [self saveLocationToDatabaseWithCoordinate:newLocation.coordinate];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}
@end
