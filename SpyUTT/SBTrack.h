//
//  SBTrack.h
//  ProcSpy
//
//  Created by Zhang on 25/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SBTrack : NSManagedObject

@property (nonatomic, retain) NSString * bundleid;
@property (nonatomic, retain) NSDate * timeOnly;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * day;

@end
