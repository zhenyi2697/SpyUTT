//
//  SPPhotoLibraryController.h
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-24.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class SPPhotoLibraryController;

@protocol PhotoLibraryControllerDelegate <NSObject>

-(void)photoLibraryControllerhasFinishedEnumeratingPhotos:(SPPhotoLibraryController *)sender;
-(void)photoLibraryController:(SPPhotoLibraryController *)sender hasUpdatedProgress:(float)progress;

@end

@interface SPPhotoLibraryController : NSObject

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic,strong) NSDictionary *photoGPSInfoDic;
@property (nonatomic,strong) id delegate;

+ (ALAssetsLibrary *)defaultAssetsLibrary;

- (int)numberOfPhotoInLibrary;
- (ALAsset *)photoAtIndex:(int)index;

@end
