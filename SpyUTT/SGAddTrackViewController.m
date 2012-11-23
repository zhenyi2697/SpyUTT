//
//  SGAddTrackViewController.m
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-01.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SGAddTrackViewController.h"
#import "Track+Create.h"

@interface SGAddTrackViewController () <UIPickerViewDelegate>
@property (nonatomic,strong) NSString *trackType;
@property (nonatomic) int trackInterval;
@property (nonatomic,strong) NSArray *typeChoices;
@property (nonatomic) BOOL isChoosingType;
@end

@implementation SGAddTrackViewController

@synthesize delegate = _delegate;
@synthesize trackType = _trackType,trackInterval = _trackInterval;
@synthesize typeChoices = _typeChoices;
@synthesize pickerView = _pickerView;
@synthesize isChoosingType = _isChoosingType;

#define TRACK_INTERVAL_DEFAULT 2

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.typeChoices = [[NSArray alloc] initWithObjects:TRACK_TYPE_AUTO, TRACK_TYPE_TIMER, nil];
    
    self.pickerView.hidden = NO;
    
    self.trackType = TRACK_TYPE_AUTO;
    self.trackInterval = TRACK_INTERVAL_DEFAULT;
    
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.pickerView reloadAllComponents];
    
    self.isChoosingType = true;
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startTracking:(UIBarButtonItem *)sender {
    if(!self.trackType) self.trackType = TRACK_TYPE_AUTO;
    [self.delegate addTrackViewController:self didAddedTrackWithType:self.trackType andInterval:[NSNumber numberWithInt:self.trackInterval]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.trackType isEqualToString:TRACK_TYPE_TIMER]) return 2;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Recalculate indexPath based on hidden cells
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.row == 0) {
        NSString *trackType = TRACK_TYPE_AUTO;
        if (self.trackType) trackType = self.trackType;
        cell.detailTextLabel.text = trackType;
    } else if (indexPath.row == 1){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d minutes",self.trackInterval];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.trackType isEqualToString:TRACK_TYPE_AUTO]){
        return 101.0;
    }else{
        return 51.0;
    }
}

- (void)preSelectForPickerView
{
    int rowIndex = 0;
    if(self.isChoosingType) {
        if([self.trackType isEqualToString:TRACK_TYPE_TIMER]) rowIndex = 1;
        [self.pickerView selectRow:rowIndex inComponent:0 animated:NO];
    } else {
        rowIndex = self.trackInterval - 1;
        [self.pickerView selectRow:rowIndex inComponent:0 animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.isChoosingType = YES;
        [self.pickerView reloadAllComponents];
        [self preSelectForPickerView];
    }else if(indexPath.row == 1){
        self.isChoosingType = NO;
        [self.pickerView reloadAllComponents];
        [self preSelectForPickerView];
    }
}

#pragma mark - picker view delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (self.isChoosingType) {
        self.trackType = [self.typeChoices objectAtIndex:row];
        [self.tableView reloadData];
    } else {
        self.trackInterval = row+1;
        [self.tableView reloadData];
    }
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.isChoosingType) return 2;
    else return 10;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (self.isChoosingType) {
        title = [self.typeChoices objectAtIndex:row];
    } else {
        title = [NSString stringWithFormat:@"%d minutes",row+1];
    }
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    return sectionWidth;
}


@end
