//
//  ABDMasterViewController.m
//  ABDemo
//
//  Created by Zhenyi ZHANG on 2012-10-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//



#import "ABDMasterViewController.h"

@interface ABDMasterViewController () {
    NSIndexPath *contactSelected;
}
@end

@implementation ABDMasterViewController

@synthesize contactController = _contactController;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*if(self.tableView.tag!=-1){
        return self.contactController.nPeople + 1;
    }else{*/
        return self.contactController.nPeople;
    //}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Two case: for detail and normal content
    
    NSInteger pIndex;
    ABRecordRef ref;
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
        //ABDContentCell *cell = [[ABDContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContentCell"];
    ABDContentCell *cell;
    
    if([contactSelected isEqual:indexPath]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContentDetailCell"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell"];
    }
    
    pIndex = indexPath.row;
    ref = CFArrayGetValueAtIndex( self.contactController.allPeople, pIndex);
    NSString *firstName = [self.contactController getFirstNameForPeople:ref];
    if (!firstName) firstName = @"";
    NSString *lastName = [self.contactController getLastNameForPeople:ref];
    if(!lastName) lastName = @"";
    cell.name.text = [NSString stringWithFormat:@"%@ %@",lastName, firstName];
    
    NSString *phone = [self.contactController getPhoneNumberForPeople:ref];
    if(!phone) phone = @"";
    else phone = [@"Tel : " stringByAppendingString:phone];
    cell.phone.text = phone;
    
    
    NSString *email = [self.contactController getEmailForPeople:ref];
    if(!email) email = @"";
    else email = [@"Email : " stringByAppendingString:email];
    cell.email.text = email;
    
    if([contactSelected isEqual:indexPath]){//if we want to show detail
        
        NSString *address = [self.contactController getAddressForPeople:ref];
        if(!address) address = @"No data";
        cell.address.text = address;
        
        NSString *title = [self.contactController getTitleForPeople:ref];
        if(!title) title = @"No data";
        cell.title.text = title;
        
        NSString *company = [self.contactController getCompanyPhoneNumberForPeople:ref];
        if(!company) company = @"No data";
        cell.company.text = company;
        
        NSString *birthday = [self.contactController getBirthdayPhoneNumberForPeople:ref];
        if(!birthday) birthday = @"No data";
        cell.birthday.text = birthday;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([contactSelected isEqual:indexPath]){
        return 200;
    }else{
        return 75;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/**
  加入右侧的小滑块索引
*/
/*
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    [titles addObject:@"A"];
    return titles;
}
*/

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSLog(@"in");
    }
}*/

/*-(void)hideSubview:(ABDContentCell*)cell
{
    cell.subview.hidden = YES;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *oldSelected = contactSelected;
    if(contactSelected == NULL){
        contactSelected = indexPath;
    }else{
        if ([contactSelected isEqual:indexPath]) {
            contactSelected = NULL;
        }else{
            contactSelected = indexPath;
        }
    }
    
    [tableView beginUpdates];
    //[tableView reloadData];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:oldSelected,nil] withRowAnimation:UITableViewRowAnimationNone];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:contactSelected,nil] withRowAnimation:UITableViewRowAnimationFade];
    
//    ABDContentCell *cell = [tableView ]
    
    
    //ABDContentCell *oldCell = (ABDContentCell *)[tableView cellForRowAtIndexPath:oldSelected];
    //[self performSelector:@selector(hideSubview:) withObject:oldCell afterDelay:0.2];
    //oldCell.subview.hidden = YES;
    [tableView endUpdates];
    
    /*NSIndexPath *index;
    NSInteger tempTag = self.tableView.tag;
    //ABDContentCell *motherCell = (ABDContentCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(self.tableView.tag == -1){
        self.tableView.tag = indexPath.row;
        //motherCell.line.hidden = YES;
        index = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
        [tableView cellForRowAtIndexPath:index].backgroundColor = [UIColor blackColor];
        //motherCell.foldIcon.hidden = NO;
    }else{
        self.tableView.tag = -1;
        //ABDContentCell *oldMotherCell = (ABDContentCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tempTag inSection:indexPath.section]];
        //oldMotherCell.line.hidden = NO;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:tempTag+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        //oldMotherCell.foldIcon.hidden = YES;
        if(tempTag != indexPath.row){
            NSInteger newIndex = indexPath.row;
            if(indexPath.row > tempTag + 1){
                newIndex = indexPath.row -1;
            }
            self.tableView.tag = newIndex;
            //motherCell.line.hidden = YES;
            index = [NSIndexPath indexPathForRow:newIndex+1 inSection:indexPath.section];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
            [tableView cellForRowAtIndexPath:index].backgroundColor = [UIColor blackColor];
            //motherCell.foldIcon.hidden = NO;
        }
    }*/
}

-(void)hideBottomBar:(UIActionSheet *)theBottomBar {
    theBottomBar.title = @"data sent!";
    [theBottomBar dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)sendContacts:(UIBarButtonItem *)sender {
    
    UIActionSheet *bottomBar = [[UIActionSheet alloc]initWithTitle:@"Sending data to server..." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [bottomBar showInView:self.tableView];
    [self.contactController sendContactsWithCallback:^{
        [self performSelector:@selector(hideBottomBar:) withObject:bottomBar afterDelay:1.2];
        //[bottomBar dismissWithClickedButtonIndex:0 animated:YES];
    } inContext:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)contactControllerAccessHasBeenGranted
{
    [self.tableView reloadData];
}

@end
