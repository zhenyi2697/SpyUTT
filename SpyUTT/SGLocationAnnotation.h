//
//  SGLocationAnnotation.h
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Location.h"
#import "Track.h"

@interface SGLocationAnnotation : NSObject <MKAnnotation>

+(SGLocationAnnotation *)annotationForLocation:(Location *)location;

@property (nonatomic,strong) Location *location;

@end
