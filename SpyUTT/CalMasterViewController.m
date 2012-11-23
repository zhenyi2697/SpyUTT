//
//  CalMasterViewController.m
//  CalSpy
//
//  Created by Zhang on 09/10/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "CalMasterViewController.h"

#import "CalDetailViewController.h"

@interface CalMasterViewController () {
    NSDate *dateBegin;
    NSDate *dateEnd;
    NSDateFormatter *formatter;
}
@end

@implementation CalMasterViewController

@synthesize model = _model;
@synthesize selectedCalendarsIndexPaths = _selectedCalendarsIndexPaths;

- (CalModel *)model{
    if(!_model){
        _model = [[CalModel alloc]init];
    }
    return _model;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    [components setHour: 0];
    [components setMinute: 0];
    [components setSecond: 0];
    dateBegin = [myCalendar dateFromComponents:components];
    //self.fromLabel.text = [formatter stringFromDate:dateBegin];
    dateEnd = [dateBegin dateByAddingTimeInterval: +86400.0];
    //self.toLabel.text = [formatter stringFromDate:dateEnd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 2) {
        self.datePicker.hidden = NO;
        self.datePicker.tag = indexPath.row;
        [self setBeginEndDateForDatePicker];
        [self.tableView addSubview:self.datePicker];
        [self setBeginEndDateFromDatePicker];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)setBeginEndDateForDatePicker
{
    if(self.datePicker.tag == 0 && dateBegin){
        self.datePicker.date = dateBegin;
    }else if(dateEnd){
        self.datePicker.date = dateEnd;
    }
}

- (void)setBeginEndDateFromDatePicker
{
    if(self.datePicker.tag == 0){
        dateBegin = self.datePicker.date;
        self.fromLabel.text = [formatter stringFromDate:dateBegin];
    }else{
        dateEnd = self.datePicker.date;
        self.toLabel.text = [formatter stringFromDate:dateEnd];
    }
}

- (IBAction)datePickerValueChange:(id)sender {
    [self setBeginEndDateFromDatePicker];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.datePicker.hidden = YES;
    if ([[segue identifier] isEqualToString:@"showEventsList"]) {
        NSArray *listEvents = [self.model retrieveEventsFrom:dateBegin To:dateEnd inCalendars:self.selectedCalendars];
        [[segue destinationViewController] setEvents:listEvents];
        NSArray *sections = [self.model generateSectionsByIteratingEventsArray:listEvents];
        [[segue destinationViewController] setSections:sections];
    }else if([[segue identifier] isEqualToString:@"chooseCalendars"]){
        CalChooseCalendarViewController *chooseCalController = (CalChooseCalendarViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        chooseCalController.calsList = [self.model retrieveAllCalendars];
        chooseCalController.calsSelected = self.selectedCalendarsIndexPaths;
        chooseCalController.delegate = self;
    }
}

- (void)addChoosingCalendarViewControllerDidFinished:(CalChooseCalendarViewController *)controller
{
    self.calendars.text = [controller calsSelectedToString];
    self.selectedCalendarsIndexPaths = controller.tableView.indexPathsForSelectedRows;
    self.selectedCalendars = [controller calsSelectedData];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
