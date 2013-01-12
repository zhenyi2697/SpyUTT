//
//  SPPhotoMetaDataController.h
//  SpyUTT
//
//  Created by Zhenyi ZHANG on 2013-01-12.
//  Copyright (c) 2013 Zhenyi Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SPPhotoMetaDataController : NSObject
@property (strong, nonatomic) ALAsset *photo;

- (SPPhotoMetaDataController *)initWithPhoto:(ALAsset *)photo;
- (NSString *)prepareText;

@end
