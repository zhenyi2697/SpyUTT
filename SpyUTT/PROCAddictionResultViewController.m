//
//  PROCAddictionResultViewController.m
//  ProcSpy
//
//  Created by Zhang on 24/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "PROCAddictionResultViewController.h"
#import "PROCAppDetection.h"

@interface PROCAddictionResultViewController (){
    NSArray *apps;
    float total;
    PROCAppDetection *appDetection;
}

@end

@implementation PROCAddictionResultViewController

@synthesize result = _result;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

-(void)setResult:(NSMutableDictionary *)result
{
    
    _result = result;
    total = [[result objectForKey:@"records"] floatValue];
    [_result removeObjectForKey:@"records"];
    
    apps = [result keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return [obj2 compare:obj1];
    }];
    
    //result
    [self.tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%.0f records", total];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.result count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddictionCell";
    PROCAddictionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *app= [apps objectAtIndex:indexPath.row];
    cell.bundleId.text = app;
    cell.appName.text = app;
    float percentage = [[self.result objectForKey:app] floatValue]/ total * 100;
    //NSLog(@"app %@ %@",  app, [self.result objectForKey:app]);
    cell.percentageBar.progress = percentage / 100;
    cell.percentageLabel.text = [NSString stringWithFormat:@"%.2f %%", percentage];
    
    cell.appImage.image = [UIImage imageNamed:@"question-icon.jpg"];
    
    if(!appDetection){
        appDetection = [[PROCAppDetection alloc]init];
    }
    
    NSDictionary *appDict;
    appDict = [appDetection retrieveBuiltInAppDictionariesForBundleId:app];
    
    if(appDict != nil){
        cell.appName.text = [appDict objectForKey:@"appName"];
        cell.appImage.image = [appDict objectForKey:@"appIcon"];
    }else{
        [appDetection retrieveAppDictionariesForAppBundleIds:[NSArray arrayWithObjects:app, nil] withSuccess:^(NSArray *appDictionaries) {
            if ([appDictionaries count] > 0) {
                NSString *artworkUrl60 = [[appDictionaries objectAtIndex:0] objectForKey:@"artworkUrl60"];
                [cell.appImage setImageWithURL:[NSURL URLWithString:artworkUrl60]];
                cell.appName.text = [[appDictionaries objectAtIndex:0] objectForKey:@"trackName"];
            }else{
                cell.appImage.image = [UIImage imageNamed:@"question-icon.jpg"];
            }
        } withFailure:^(NSError *error) {
            
        }];
    }
    //todo : a completer other apps
    
    
    
    return cell;
}


@end
