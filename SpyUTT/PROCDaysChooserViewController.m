//
//  PROCDaysChooserViewController.m
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "PROCDaysChooserViewController.h"
#import "PROCDaysChooserCell.h"

@interface PROCDaysChooserViewController ()

@end

@implementation PROCDaysChooserViewController

@synthesize days = _days;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

-(void)setDays:(NSArray *)days
{
    for(NSNumber *n in days){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:n.integerValue inSection:0] animated:NO scrollPosition:UITableViewRowAnimationTop];
    }
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dayCell";
    PROCDaysChooserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *dayString;
    switch (indexPath.row) {
        case 0:
            dayString = @"Monday";
            break;
        case 1:
            dayString = @"Tuesday";
            break;
        case 2:
            dayString = @"Wednesday";
            break;
        case 3:
            dayString = @"Thursday";
            break;
        case 4:
            dayString = @"Friday";
            break;
        case 5:
            dayString = @"Saturday";
            break;
        case 6:
            dayString = @"Sunday";
        default:
            break;
    }
    cell.textLabel.text = dayString;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)clickDone:(id)sender {
    [self.delegate chooseDays:self.tableView.indexPathsForSelectedRows forView:self];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
