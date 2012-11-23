//
//  RemMasterViewController.m
//  RemSpy
//
//  Created by Zhang on 15/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "RemMasterViewController.h"

#import "RemDetailViewController.h"

@interface RemMasterViewController () {
    NSArray *objects;
}
@end

@implementation RemMasterViewController
@synthesize model = _model;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    objects = [self.model retrieveAllRemindersLists];
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
    return [objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderListCell" forIndexPath:indexPath];

    cell.textLabel.text = [(EKCalendar *)objects[indexPath.row] title];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowReminderEvents"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EKCalendar *currentCal = objects[indexPath.row];
        RemDetailViewController *controller =  [segue destinationViewController];
        controller.remindersTitle.title = currentCal.title;
        //controller.cal = currentCal;
        controller.model = self.model;
        [self.model retrieveRemindersFromList:currentCal withCompletion:^(NSArray *reminders) {
            controller.reminders = reminders;
        }];
        /*EKEventStore *store = [[EKEventStore alloc] init];
        if([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusAuthorized){
            [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                NSPredicate *predicate = [store predicateForRemindersInCalendars:[NSArray arrayWithObjects:currentCal, nil]];
                
                [store fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
                    NSLog(@"%@",reminders);
                    controller.reminders = reminders;
                }];
            }];
        }*/
    }
}

@end
