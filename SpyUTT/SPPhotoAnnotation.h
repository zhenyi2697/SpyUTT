//
//  SPPhotoAnnotation.h
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-05.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SPPhotoAnnotation : NSObject <MKAnnotation>

+(SPPhotoAnnotation *)annotationForPhoto:(ALAsset *)photo andMetaData:(NSDictionary *)gpsInfo;

@property (strong, nonatomic) NSDictionary *gpsInfo;
@property (strong, nonatomic) ALAsset *photo;

@end
