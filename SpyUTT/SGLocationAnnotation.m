//
//  SGLocationAnnotation.m
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SGLocationAnnotation.h"

@implementation SGLocationAnnotation

@synthesize location = _location;

+(SGLocationAnnotation *)annotationForLocation:(Location *)location
{
    SGLocationAnnotation *annotation = [[SGLocationAnnotation alloc] init];
    annotation.location = location;
    return annotation;
}

//MKAnnotation protocol 的方法， title的setter
-(NSString *)title
{
    return [self.location.currentTime description];
}

//MKAnnotation protocol 的方法， subtitle的setter
- (NSString *)subtitle
{
    Track *track = self.location.whoTracked;
    return [track.type stringByAppendingFormat:@" <%@ %@>",self.location.latitude,self.location.longitude];
}

//MKAnnotation protocol 的方法， coordinate的setter
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.location.latitude doubleValue];
    coordinate.longitude = [self.location.longitude doubleValue];
    
    return coordinate;
}

@end
