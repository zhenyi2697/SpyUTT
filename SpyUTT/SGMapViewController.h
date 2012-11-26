//
//  SGMapViewController.h
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-01.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SGMapViewController : UIViewController
@property (nonatomic,strong) NSArray *annotations;  // of id <MKAnnotation>
- (IBAction)previousLocation:(UIButton *)sender;
- (IBAction)nextLocation:(id)sender;

@end
