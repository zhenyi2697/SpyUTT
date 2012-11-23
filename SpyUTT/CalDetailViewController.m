//
//  CalDetailViewController.m
//  CalSpy
//
//  Created by Zhang on 09/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "CalDetailViewController.h"

@interface CalDetailViewController (){
    NSIndexPath *eventSelected;
    NSDateFormatter *formatter;
}
//- (void)configureView;
@end

@implementation CalDetailViewController
@synthesize sections = _sections;
@synthesize events = _events;
@synthesize model = _model;

#pragma mark - Managing the detail item

/*- (void)setDetailItem:(NSArray*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}*/

- (CalModel *)model{
    if(!_model){
        _model = [[CalModel alloc]init];
    }
    return _model;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 1;
    //NSLog(@"sections %u",[self.sections count]);
    return [self.sections count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [(NSDictionary *)[self.sections objectAtIndex:section] objectForKey:@"sectionLabel"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.detailItem count];
    
    //NSLog(@"rows %u",[(NSNumber *)[(NSDictionary *)[self.sections objectAtIndex:section] objectForKey:@"rowsCount"] integerValue]);
    return [(NSNumber *)[(NSDictionary *)[self.sections objectAtIndex:section] objectForKey:@"rowsCount"] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.sections objectAtIndex:indexPath.section];
    //NSLog(@"%@",dict);
    NSArray *rows = [dict objectForKey:@"rows"];
    EKEvent *event = [rows objectAtIndex:indexPath.row];
    //NSLog(@"%@",event);
    //EKEvent *event = [self.detailItem objectAtIndex:indexPath.row];
    
    CalDetailCell *cell;
    
    if([eventSelected isEqual:indexPath]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailCell"];
        cell.location.text = event.location;
        cell.calendar.text = event.calendar.title;
        cell.note.text = event.notes;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    }
    
    cell.title.text = event.title;
    cell.time.text = [NSString stringWithFormat:@"%@ - %@",[formatter stringFromDate:event.startDate],[formatter stringFromDate:event.startDate]];
    cell.calendarColor.backgroundColor = [UIColor colorWithCGColor: event.calendar.CGColor];
    
    return cell;

}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![eventSelected isEqual:indexPath]){
        return 58;
    }else{
        return 160;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *oldSelected = eventSelected;
    if(eventSelected == NULL){
        eventSelected = indexPath;
    }else{
        if ([eventSelected isEqual:indexPath]) {
            eventSelected = NULL;
        }else{
            eventSelected = indexPath;
        }
    }
    
    [tableView beginUpdates];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:oldSelected,nil] withRowAnimation:UITableViewRowAnimationNone];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:eventSelected,nil] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendData:(id)sender {
    UIActionSheet *bottomBar = [[UIActionSheet alloc]initWithTitle:@"Sending data to server..." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [bottomBar showInView:self.tableView];
    [self.model sendEvents: self.events WithCallback:^{
        [self performSelector:@selector(hideBottomBar:) withObject:bottomBar afterDelay:1.2];
    } inContext:self];
}


-(void)hideBottomBar:(UIActionSheet *)theBottomBar {
    theBottomBar.title = @"data sent!";
    [theBottomBar dismissWithClickedButtonIndex:0 animated:YES];
}
@end
