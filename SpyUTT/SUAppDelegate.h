//
//  SUAppDelegate.h
//  SpyUTT
//
//  Created by Zhenyi ZHANG on 2012-11-23.
//  Copyright (c) 2012 Zhenyi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddictionModel.h"
#import "DCDTrackDataController.h"

@interface SUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) AddictionModel *addictionModel;
@property (strong,nonatomic) DCDTrackDataController *databaseController;
@end
