//
//  SGTrackListViewController.h
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-01.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreDataTableViewController.h"
#import "SGAddTrackViewController.h"


@interface SGTrackListViewController : CoreDataTableViewController <AddTrackViewControllerDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) UIManagedDocument *trackDatabase;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addTrackButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
