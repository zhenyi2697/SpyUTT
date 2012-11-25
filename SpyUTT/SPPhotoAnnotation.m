//
//  SPPhotoAnnotation.m
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-05.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SPPhotoAnnotation.h"

@implementation SPPhotoAnnotation
@synthesize gpsInfo = _gpsInfo, photo = _photo;

+(SPPhotoAnnotation *)annotationForPhoto:(ALAsset *)photo andMetaData:(NSDictionary *)gpsInfo
{
    SPPhotoAnnotation *annotation = [[SPPhotoAnnotation alloc] init];
    annotation.gpsInfo = gpsInfo;
    annotation.photo = photo;
    return annotation;
}

+(NSDateFormatter *)formatter
{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return formatter;
}

//MKAnnotation protocol 的方法， title的setter
-(NSString *)title
{
    ALAssetRepresentation *presentation = [self.photo defaultRepresentation];
    NSString *imageName = [presentation filename];
    return imageName;
}

//MKAnnotation protocol 的方法， subtitle的setter
- (NSString *)subtitle
{
    NSDate *imageDate = [self.photo valueForProperty:ALAssetPropertyDate];
    NSString *subtitle = [[SPPhotoAnnotation formatter] stringFromDate:imageDate];
    return subtitle;
}

//MKAnnotation protocol 的方法， coordinate的setter
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    if(self.gpsInfo) {
        coordinate.latitude = [(NSNumber *)[self.gpsInfo objectForKey:@"Latitude"] doubleValue];
        coordinate.longitude = [(NSNumber *)[self.gpsInfo objectForKey:@"Longitude"] doubleValue];
    }
    return coordinate;
}

@end
