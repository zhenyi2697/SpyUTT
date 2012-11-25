//
//  PROCForthViewController.m
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "PROCForthViewController.h"
#import "AddictionModel.h"
#import "SUAppDelegate.h"
#import "PROCAppDetection.h"
#import "PROCAddictionCell.h"

@interface PROCForthViewController ()
{
    AddictionModel *model;
    NSArray *keys;
    PROCAppDetection *appDetection;
}
@end

@implementation PROCForthViewController

@synthesize result = _result;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //model = [[AddictionModel alloc]init];
    model = [(SUAppDelegate *)[[UIApplication sharedApplication] delegate] addictionModel];
    self.result = [model retrieveAppsUtilisationTime];
    
	// Do any additional setup after loading the view.
}

-(void)setResult:(NSDictionary *)result
{
    _result =result;
    keys = [_result keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return [obj2 compare:obj1];
    }];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    static NSString *CellIdentifier = @"UtilisationCell";
    PROCAddictionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *app= [keys objectAtIndex:indexPath.row];
    
    cell.bundleId.text = app;
    cell.appName.text = app;
    int percentage = [[self.result objectForKey:app] intValue] * 2;
    //NSLog(@"app %@ %@",  app, [self.result objectForKey:app]);
    
    NSString *hour;
    
    if(percentage < 60){
        hour = [NSString stringWithFormat:@"%d s", percentage];
    }else if (percentage >= 60 && percentage < 3600){
        hour = [NSString stringWithFormat:@"%d m", percentage/60];
    }else{
        hour = [NSString stringWithFormat:@"%d h", percentage/3600];
    }
    
    cell.percentageLabel.text = hour;
    
    //cell.percentageLabel.text = [NSString stringWithFormat:@"%.2f s", percentage];
    
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
    
    return cell;
}

@end