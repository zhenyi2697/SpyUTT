//
//  Location+Create.h
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "Location.h"

@interface Location (Create)

+(void)locationWithLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude trackedBy:(Track *)track inManagedContext:(NSManagedObjectContext*) context;

@end
