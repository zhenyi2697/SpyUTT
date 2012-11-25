//
//  PROCSecondViewController.m
//  ProcSpy
//
//  Created by Zhang on 25/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "PROCSecondViewController.h"

@interface PROCSecondViewController ()

@end

@implementation PROCSecondViewController

@synthesize detectedApps,detectionObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detectionObject = [[iHasApp alloc] init];
    
    [self.detectionObject detectAppDictionariesWithIncremental:^(NSArray *appDictionaries) {
        
        //NSLog(@"Incremental appDictionaries.count: %i", appDictionaries.count);
        NSMutableArray *newAppDictionaries = [NSMutableArray arrayWithArray:self.detectedApps];
        [newAppDictionaries addObjectsFromArray:appDictionaries];
        self.detectedApps = newAppDictionaries;
        /*[self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:appDictionaries.count-1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];*/
        //NSLog(@"success : %@", self.detectedApps);
        
    } withSuccess:^(NSArray *appDictionaries) {
        self.detectedApps = appDictionaries;
        [self.tableView reloadData];
    } withFailure:^(NSError *error) {
        
    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell"];
    NSDictionary *appDictionary = self.detectedApps[indexPath.row];
    cell.name.text = [appDictionary objectForKey:@"trackName"];
    NSString *artworkUrl60 = [appDictionary objectForKey:@"artworkUrl60"];
    [cell.iconImg setImageWithURL:[NSURL URLWithString:artworkUrl60] placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.detectedApps count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.detectedApps)
    {
		return [NSString stringWithFormat:@"%i Apps Detected", self.detectedApps.count];
	}
    else
    {
        return @"Detection in progress...";
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
