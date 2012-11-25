//
//  PROCThirdViewController.m
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "PROCThirdViewController.h"
#import "SUAppDelegate.h"

@interface PROCThirdViewController ()
{
    AddictionModel *model;
    NSDateFormatter *formatter;
    NSTimer *theTimer;
}

@end

@implementation PROCThirdViewController

@synthesize days = _days, beginTime = _beginTime, endTime = _endTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [myCalendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:[NSDate date]];
    [components setHour: 8];
    [components setMinute: 0];
    self.beginTime = [myCalendar dateFromComponents:components];
    self.endTime = [self.beginTime dateByAddingTimeInterval: +3600.0];
	// Do any additional setup after loading the view.
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    self.timePicker.tag = 0;
    self.beginTimeLabel.text = [formatter stringFromDate:self.beginTime];
    self.endTimeLabel.text = [formatter stringFromDate:self.endTime];
    
    //model = [[AddictionModel alloc]init];
    model = [(SUAppDelegate *)[[UIApplication sharedApplication] delegate] addictionModel];
    
    UIBackgroundTaskIdentifier bgtask;
    bgtask = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    theTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(saveTrack) userInfo:nil repeats:YES];
    
}

- (void)saveTrack
{
    [model saveTrack];
}


-(void)setBeginTime:(NSDate *)beginTime
{
    _beginTime = beginTime;
    self.beginTimeLabel.text = [formatter stringFromDate:beginTime];
    if(self.timePicker.tag == 0){
        self.timePicker.date = beginTime;
    }
}

-(void)setEndTime:(NSDate *)endTime
{
    _endTime = endTime;
    self.endTimeLabel.text = [formatter stringFromDate:endTime];
    if (self.timePicker.tag == 1) {
        self.timePicker.date = endTime;
    }
}

- (void)setDays:(NSMutableArray *)days
{
    _days = days;
    NSMutableString *value = [NSMutableString stringWithString:@""];;
    //int weekday = 0;
    //int weekend = 0;
    if([days containsObject:[NSNumber numberWithInt:0]]){
        [value appendString:@"Mon,"];
        //weekday++;
    }if([days containsObject:[NSNumber numberWithInt:1]]){
        [value appendString:@"Tue,"];
        //weekday++;
    }if([days containsObject:[NSNumber numberWithInt:2]]){
        [value appendString:@"Wed,"];
        //weekday++;
    }if([days containsObject:[NSNumber numberWithInt:3]]){
        [value appendString:@"Thu,"];
        //weekday++;
    }if([days containsObject:[NSNumber numberWithInt:4]]){
        [value appendString:@"Fri,"];
        //weekday++;
    }if([days containsObject:[NSNumber numberWithInt:5]]){
        [value appendString:@"Sat,"];
        //weekend++;
    }if([days containsObject:[NSNumber numberWithInt:6]]){
        [value appendString:@"Sun,"];
        //weekend++;
    }
    /*if(weekend == 2){
        if(weekday == 5){
            value = [NSMutableString stringWithString:@"all"];
        }else{
            if (weekday !=0) {
                value = [NSMutableString stringWithString:@"weekend"];
            }
        }
        
    }else if (weekday == 5){
        if (weekend !=0) {
            value = [NSMutableString stringWithString:@"weekdays"];
        }
    }*/
    self.daysLabel.text = value;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Days"]){
        PROCDaysChooserViewController *chooserController = (PROCDaysChooserViewController *)[[segue.destinationViewController viewControllers] objectAtIndex:0];
        chooserController.delegate = self;
        chooserController.days = self.days;
    }else if([segue.identifier isEqualToString:@"SearchAddiction"]){
        PROCAddictionResultViewController *resultViewController = (PROCAddictionResultViewController *)segue.destinationViewController;
        resultViewController.result = [model retrieveAppDictionaryWithDays:self.days BeginTime:self.beginTime ToTime:self.endTime];
        
    }  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            self.timePicker.hidden = YES;
            break;
        case 1:
            self.timePicker.hidden = NO;
            self.timePicker.tag = 0;
            self.timePicker.date = self.beginTime;
            break;
        case 2:
            self.timePicker.hidden = NO;
            self.timePicker.tag = 1;
            self.timePicker.date = self.endTime;
            break;
        default:
            break;
    }
}


- (IBAction)timePickerValueChanged:(id)sender {
    if(self.timePicker.tag == 0){
        self.beginTime = self.timePicker.date;
        self.beginTimeLabel.text = [formatter stringFromDate:self.beginTime];
        self.endTime = [self.beginTime dateByAddingTimeInterval: +3600.0];
    }else{
        self.endTime = self.timePicker.date;
        self.endTimeLabel.text = [formatter stringFromDate:self.endTime];

    }
}

- (IBAction)backToTotal:(UIBarButtonItem *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


-(void)chooseDays:(NSArray *)days forView:(id)sender
{
    NSMutableArray *newDays = [[NSMutableArray alloc]initWithCapacity:7];
    for (NSIndexPath *day in days){
        [newDays addObject:[NSNumber numberWithInt:day.row]];
    }
    self.days = newDays;
}

@end
