//
//  SUAppDelegate.h
//  SpyUTT
//
//  Created by Zhenyi ZHANG on 2012-11-23.
//  Copyright (c) 2012 Zhenyi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddictionModel.h"
@interface SUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) AddictionModel *addictionModel;
@end
