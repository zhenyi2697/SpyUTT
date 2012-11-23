//
//  CalChooseCalendarViewController.m
//  CalSpy
//
//  Created by Zhang on 11/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "CalChooseCalendarViewController.h"

@interface CalChooseCalendarViewController ()

@end

@implementation CalChooseCalendarViewController

@synthesize calsList = _calsList;
@synthesize calsSelected = _calsSelected;

- (void)setCalsSelected:(NSArray *)calsSelected
{
    
    NSLog(@"ok %@", calsSelected);
    UITableViewCell *cell;
    for(NSIndexPath *index in calsSelected){
        [self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
        cell = [self.tableView cellForRowAtIndexPath:index];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (NSString *)calsSelectedToString
{
    NSArray *selectedId = [self.tableView indexPathsForSelectedRows];
    if([selectedId count] == [self.tableView numberOfRowsInSection:0] || [selectedId count] == 0){
        return @"All";
    }else{
        NSMutableString *toReturn = [[NSMutableString alloc]init];
        EKCalendar *cal;
        for(NSIndexPath *selected in selectedId){
            cal = [self.calsList objectAtIndex:selected.row];
            [toReturn appendFormat:@"%@,",cal.title];
        }
        return toReturn;
    }
    
}

- (NSArray *)calsSelectedData
{
    NSArray *selectedId = [self.tableView indexPathsForSelectedRows];
    if ([selectedId count] == 0) {
        return nil;
    }else{
        NSMutableArray *toReturn = [[NSMutableArray alloc]initWithCapacity:[selectedId count]];
        EKCalendar *cal;
        for(NSIndexPath *selected in selectedId){
            cal = [self.calsList objectAtIndex:selected.row];
            [toReturn addObject:cal];
        }
        return toReturn;
    }
    
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return [self.calsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarCell";
    CalCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    EKCalendar *cal = [self.calsList objectAtIndex:indexPath.row];
    cell.calLabel.text = cal.title;
    cell.calColor.backgroundColor = [UIColor colorWithCGColor: cal.CGColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [cell setSelected:YES animated:YES];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelected:NO animated:YES];
}


- (IBAction)done:(id)sender {
    [[self delegate] addChoosingCalendarViewControllerDidFinished:self];
}
@end
