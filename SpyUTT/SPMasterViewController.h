//
//  SPMasterViewController.h
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-10-20.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SPPhotoLibraryController.h"

@interface SPMasterViewController : UITableViewController <PhotoLibraryControllerDelegate>

@property (nonatomic,strong) SPPhotoLibraryController *photoLibraryController;

@end
