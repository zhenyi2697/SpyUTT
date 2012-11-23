//
//  SDDeviceInfoTableViewController.m
//  SpyDevice
//
//  Created by Zhenyi ZHANG on 2012-11-22.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SDDeviceInfoTableViewController.h"

@interface SDDeviceInfoTableViewController ()
@property (strong,nonatomic) UIDevice *currentDevice;
@property (strong,nonatomic) NSArray *deviceInfoKeys;
@property (strong,nonatomic) NSMutableDictionary *deviceInfoDic;
@end

@implementation SDDeviceInfoTableViewController
@synthesize currentDevice = _currentDevice,deviceInfoKeys = _deviceInfoKeys, deviceInfoDic = _deviceInfoDic;

- (NSMutableDictionary *)deviceInfoDic {
    if (!_deviceInfoDic) {
        _deviceInfoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _deviceInfoDic;
}

- (NSArray *)deviceInfoKeys
{
    if (!_deviceInfoKeys) {
        _deviceInfoKeys = [[NSArray alloc] initWithObjects:@"name", @"systemName", @"systemVersion", @"model",@"localizedModel", @"orientation", @"userInterfaceIdiom", @"identifierForVendor", @"batteryLevel", @"proximityState", @"isProximityMonitoringEnabled", @"isBatteryMonitoringEnabled", @"isMultitaskingSupported",nil];
    }
    return _deviceInfoKeys;
}

- (UIDevice *)currentDevice
{
    if (!_currentDevice) {
        _currentDevice = [UIDevice currentDevice];
    }
    return _currentDevice;
}

- (void)getDeviceInfo
{
    [self.deviceInfoDic setObject:[self.currentDevice name] forKey:@"name"];
    [self.deviceInfoDic setObject:[self.currentDevice systemName] forKey:@"systemName"];
    [self.deviceInfoDic setObject:[self.currentDevice systemVersion] forKey:@"systemVersion"];
    [self.deviceInfoDic setObject:[self.currentDevice model] forKey:@"model"];
    [self.deviceInfoDic setObject:[self.currentDevice localizedModel] forKey:@"localizedModel"];
    [self.deviceInfoDic setObject:[[self.currentDevice identifierForVendor] UUIDString] forKey:@"identifierForVendor"];
    ;
    [self.deviceInfoDic setObject:[NSString stringWithFormat:@"%d",[self.currentDevice userInterfaceIdiom]] forKey:@"userInterfaceIdiom"];
    [self.deviceInfoDic setObject:[NSString stringWithFormat:@"%.2f",[self.currentDevice batteryLevel]] forKey:@"batteryLevel"];
    [self.deviceInfoDic setObject:[[NSNumber numberWithBool:[self.currentDevice isBatteryMonitoringEnabled]] description] forKey:@"isBatteryMonitoringEnabled"];
    [self.deviceInfoDic setObject:[[NSNumber numberWithBool:[self.currentDevice isMultitaskingSupported]] description] forKey:@"isMultitaskingSupported"];
    [self.deviceInfoDic setObject:[NSString stringWithFormat:@"%d",[self.currentDevice orientation]] forKey:@"orientation"];
    [self.deviceInfoDic setObject:[[NSNumber numberWithBool:[self.currentDevice isProximityMonitoringEnabled]] description] forKey:@"isProximityMonitoringEnabled"];
    [self.deviceInfoDic setObject:[[NSNumber numberWithBool:[self.currentDevice proximityState]] description] forKey:@"proximityState"];
    
//    NSLog(@"%@",[self.currentDevice name]);
//    NSLog(@"%@",[self.currentDevice systemName]);
//    NSLog(@"%@",[self.currentDevice systemVersion]);
//    NSLog(@"%@",[self.currentDevice model]);
//    NSLog(@"%@",[self.currentDevice localizedModel]);
//    NSLog(@"%d",[self.currentDevice userInterfaceIdiom]);
//    NSLog(@"%@",[self.currentDevice identifierForVendor]);
//    NSLog(@"%f",[self.currentDevice batteryLevel]);
//    NSLog(@"%c",[self.currentDevice isBatteryMonitoringEnabled]);
//    NSLog(@"%c",[self.currentDevice isMultitaskingSupported]);
//    NSLog(@"%d",[self.currentDevice orientation]);
//    NSLog(@"%c",[self.currentDevice isProximityMonitoringEnabled]);
//    NSLog(@"%c",[self.currentDevice proximityState]);
}

-(void) orientationChanged {
//    if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) ||
//        ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) {
//        //do landscape things
//        NSLog(@"landscape now...");
//    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
//        //do protrait things
//        NSLog(@"protrait now...");
//    }
    
    [self.deviceInfoDic setObject:[NSString stringWithFormat:@"%d",[self.currentDevice orientation]] forKey:@"orientation"];
    //[self.tableView reloadData];
    [self.tableView beginUpdates];
    NSIndexPath *pathForOrientation = [NSIndexPath indexPathForRow:5 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:pathForOrientation, nil]  withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)proximityChanged
{
    [self.deviceInfoDic setObject:[[NSNumber numberWithBool:[self.currentDevice proximityState]] description] forKey:@"proximityState"];
    [self.tableView beginUpdates];
    NSIndexPath *pathForOrientation = [NSIndexPath indexPathForRow:9 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:pathForOrientation, nil]  withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(void)batteryLevelChanged
{
    [self.deviceInfoDic setObject:[NSString stringWithFormat:@"%.2f",[self.currentDevice batteryLevel]]forKey:@"batteryLevel"];
    [self.tableView beginUpdates];
    NSIndexPath *pathForOrientation = [NSIndexPath indexPathForRow:8 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:pathForOrientation, nil]  withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDeviceInfo];
    [self.currentDevice beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged) name:UIDeviceProximityStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChanged)  name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.deviceInfoKeys count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Current Device Info";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeviceInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *stringValue = @"";
    NSString *keyForCell = (NSString *)[self.deviceInfoKeys objectAtIndex:indexPath.row];
    
    id objectValue = [self.deviceInfoDic objectForKey:keyForCell];
    if ([objectValue isKindOfClass:[NSString class]]) {
        stringValue = (NSString *)objectValue;
    }
    
    cell.textLabel.text = [self.deviceInfoKeys objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = stringValue;
    
    return cell;
}

- (IBAction)toggleSensor:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Start Sensors"]) {
        self.currentDevice.batteryMonitoringEnabled = YES;
        self.currentDevice.proximityMonitoringEnabled = YES;
        [self.deviceInfoDic setObject:@"1" forKey:@"isBatteryMonitoringEnabled"];
        [self.deviceInfoDic setObject:@"1" forKey:@"isProximityMonitoringEnabled"];
        sender.title = @"Stop Sensors";
    } else {
        self.currentDevice.batteryMonitoringEnabled = NO;
        self.currentDevice.proximityMonitoringEnabled = NO;
        [self.deviceInfoDic setObject:@"0" forKey:@"isBatteryMonitoringEnabled"];
        [self.deviceInfoDic setObject:@"0" forKey:@"isProximityMonitoringEnabled"];
        sender.title = @"Start Sensors";
    }
    [self.tableView reloadData];
}
@end
