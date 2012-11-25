//
//  PROCFirstViewController.m
//  ProcSpy
//
//  Created by Zhang on 25/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "PROCFirstViewController.h"

@interface PROCFirstViewController (){
    NSIndexPath *procSelected;
    NSDateFormatter *formatter;
}


@end

@implementation PROCFirstViewController
@synthesize processes = _processes;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //dataController = [[DCDTrackDataController alloc]init];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)setProcesses:(NSDictionary *)processes
{
    _processes = processes;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [NSString stringWithFormat:@"%d app processes",[[self.processes objectForKey:@"app"] count]];
    }else if(section == 1){
        return [NSString stringWithFormat:@"%d built in processes",[[self.processes objectForKey:@"builtin"] count]];
    }else{
        return [NSString stringWithFormat:@"%d sys processes",[[self.processes objectForKey:@"sys"] count]];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nbRow;
    switch (section) {
        case 0:
            nbRow = [[self.processes objectForKey:@"app"] count];
            break;
        case 1:
            nbRow = [[self.processes objectForKey:@"builtin"] count];
            break;
        default:
            nbRow = [[self.processes objectForKey:@"sys"] count];
            break;
    }
    return nbRow;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-YYYY HH:mm"];
    }
    PROCCell *cell;
    
    NSArray *array;
    switch (indexPath.section) {
        case 0:
            array = [self.processes objectForKey:@"app"];
            break;
        case 1:
            array = [self.processes objectForKey:@"builtin"];
            break;
        default:
            array = [self.processes objectForKey:@"sys"];
            break;
    }
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    if([procSelected isEqual:indexPath]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProcDetailCell"];
        cell.pid.text = [dict objectForKey:@"ProcessID"];
        cell.status.text = [dict objectForKey:@"ProcessStat"];
        switch ([[dict objectForKey:@"ProcessStat"] integerValue]) {
            case 1:
                cell.status.text = @"Process being created by fork.";
                break;
            case 2:
                cell.status.text = @"Currently runnable.";
                break;
            case 3:
                cell.status.text = @"Sleeping on an address.";
                break;
            case 4:
                cell.status.text = @"Process debugging or suspension.";
                break;
            case 5:
                cell.status.text = @"Awaiting collection by parent.";
                break;
            default:
                break;
        }
        
        //cell.note.text = [dict objectForKey:@"ProcessNote"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProcCell"];
    }
    
    NSString *procName = [dict objectForKey:@"ProcessName"];
    cell.name.text = procName;
    //NSString *type = [dict objectForKey:@"ProcessType"];
    cell.time.text = [formatter stringFromDate:[dict objectForKey:@"StartTime"]];
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![procSelected isEqual:indexPath]){
        return 58;
    }else{
        return 160;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *oldSelected = procSelected;
    if(procSelected == NULL){
        procSelected = indexPath;
    }else{
        if ([procSelected isEqual:indexPath]) {
            procSelected = NULL;
        }else{
            procSelected = indexPath;
        }
    }
    
    [tableView beginUpdates];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:oldSelected,nil] withRowAnimation:UITableViewRowAnimationNone];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:procSelected,nil] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
