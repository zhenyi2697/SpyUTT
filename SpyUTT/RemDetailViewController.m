//
//  RemDetailViewController.m
//  RemSpy
//
//  Created by Zhang on 15/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "RemDetailViewController.h"

@interface RemDetailViewController (){
    NSIndexPath *reminderSelected;
    NSDateFormatter *formatter;
}
@end

@implementation RemDetailViewController
@synthesize model = _model;
@synthesize reminders = _reminders;

-(void) setReminders:(NSArray *)newReminders
{
    _reminders = newReminders;
    //[self.tableView reloadData];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-YY HH:mm"];
    }
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
    return [self.reminders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RemEventDetailCell *cell;
    EKReminder *reminder = self.reminders[indexPath.row];
    
    if([reminderSelected isEqual:indexPath]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderDetailCell"];
        if (reminder.notes == NULL) {
            cell.notes.text = @"";
        }else{
            cell.notes.text = reminder.notes;
        }
        
        if(reminder.priority = 5){
            cell.priority.text = @"medium";
        }else if (reminder.priority <=9 && reminder.priority >=6){
            cell.priority.text = @"hight";
        }else if (reminder.priority <=4 && reminder.priority >=0){
            cell.priority.text = @"low";
        }else{
            cell.priority.text = @"none";
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell"];
    }
    cell.name.text = reminder.title;
    if (reminder.isCompleted) {
        cell.finished.hidden = NO;
        cell.time.text = [NSString stringWithFormat:@"finished : %@", [formatter stringFromDate:reminder.completionDate]];
    }else{
        cell.finished.hidden = YES;
        if (reminder.dueDateComponents.year != 0) {
            cell.time.text = [NSString stringWithFormat:@"due time : %@", [formatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents: reminder.dueDateComponents]]];
        }else{
            cell.time.text = @"";
        }
        
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![reminderSelected isEqual:indexPath]){
        return 50;
    }else{
        return 138;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *oldSelected = reminderSelected;
    if(reminderSelected == NULL){
        reminderSelected = indexPath;
    }else{
        if ([reminderSelected isEqual:indexPath]) {
            reminderSelected = NULL;
        }else{
            reminderSelected = indexPath;
        }
    }
    
    [tableView beginUpdates];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:oldSelected,nil] withRowAnimation:UITableViewRowAnimationNone];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:reminderSelected,nil] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}


- (IBAction)sendReminders:(id)sender {
    UIActionSheet *bottomBar = [[UIActionSheet alloc]initWithTitle:@"Sending data to server..." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [bottomBar showInView:self.tableView];
    [self.model sendReminders:self.reminders WithCallback:^{
        [self performSelector:@selector(hideBottomBar:) withObject:bottomBar afterDelay:1.2];
    }];
}

-(void)hideBottomBar:(UIActionSheet *)theBottomBar {
    theBottomBar.title = @"data sent!";
    [theBottomBar dismissWithClickedButtonIndex:0 animated:YES];
}
@end
