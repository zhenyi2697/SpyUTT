//
//  SPPhotoMapViewController.h
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-05.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SPPhotoAnnotation.h"

#define MAP_SHOWS_ONE_PHOTO @"one photo"
#define MAP_SHOWS_ALL_PHOTOS @"all photos"

@interface SPPhotoMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) NSArray *annotations;  // of id <MKAnnotation>
@property (nonatomic,strong) NSString *currentMap;  // type of current display:
- (IBAction)closeMap:(UIBarButtonItem *)sender;
- (IBAction)showPreviousPhoto:(UIButton *)sender;
- (IBAction)showNextPhoto:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *changePhotoToolBar;

@end
