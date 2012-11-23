//
//  SGAddTrackViewController.h
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-01.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SGAddTrackViewController;

@protocol AddTrackViewControllerDelegate <NSObject>
@required
-(void)addTrackViewController:(SGAddTrackViewController *)sender didAddedTrackWithType:(NSString *)type andInterval:(NSNumber *)intervalInMinute;
@end

@interface SGAddTrackViewController : UITableViewController
@property (nonatomic,strong) id delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)startTracking:(UIBarButtonItem *)sender;

@end
