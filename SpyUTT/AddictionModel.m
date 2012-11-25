//
//  AddictionModel.m
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "AddictionModel.h"
#import "SBTrack+CreateTrack.h"
#import "DCDTrackDataController.h"
#import "PTDevice.h"

@implementation AddictionModel
{
    DCDTrackDataController *dataController;
}

-(id)init
{
    self = [super init];
    dataController = [[DCDTrackDataController alloc]init];
    return self;
}

- (void)saveTrack
{
    [dataController saveTrack:[[UIDevice currentDevice] getActiveApps]];
}

- (NSMutableDictionary *)retrieveAppDictionaryWithDays:(NSArray *)days BeginTime:(NSDate *)beginTime ToTime:(NSDate *)endTime
{
    NSMutableDictionary *appsDict = [NSMutableDictionary dictionary];
    
    NSArray *result = [dataController fetchAllTracksWithDays:days WithBeginTime:beginTime WithEndTime:endTime];
    
    
    NSInteger count = [result count];
    [appsDict setObject:[NSNumber numberWithInteger:count] forKey:@"records"];
    
    for(SBTrack *t in result){
        if ([t.bundleid isEqualToString:@""] || [@"abcdefghijklmnopqrstuvwxyz" rangeOfString:[t.bundleid substringToIndex:1]].location == NSNotFound){
            t.bundleid = @"not using";
        }
        if ([appsDict objectForKey:t.bundleid]) {
            NSNumber *value = (NSNumber *)[appsDict objectForKey:t.bundleid];
            NSInteger intValue = value.integerValue + 1;
            [appsDict setObject:[NSNumber numberWithInteger:intValue] forKey:t.bundleid];
        }else{
            [appsDict setObject:[NSNumber numberWithInteger:1] forKey:t.bundleid];
        }
    }
  
    return appsDict;
}

- (NSDictionary *)retrieveAppsUtilisationTime
{
    NSMutableDictionary *appsDict = [NSMutableDictionary dictionary];
    
    NSArray *result = [dataController fetchAllTracks];
    
    
    //NSInteger count = [result count];
    //[appsDict setObject:[NSNumber numberWithInteger:count] forKey:@"records"];
    
    for(SBTrack *t in result){
        if ([t.bundleid isEqualToString:@""] || [@"abcdefghijklmnopqrstuvwxyz" rangeOfString:[t.bundleid substringToIndex:1]].location == NSNotFound){
            t.bundleid = @"not using";
        }
        if ([appsDict objectForKey:t.bundleid]) {
            NSNumber *value = (NSNumber *)[appsDict objectForKey:t.bundleid];
            NSInteger intValue = value.integerValue + 1;
            [appsDict setObject:[NSNumber numberWithInteger:intValue] forKey:t.bundleid];
        }else{
            [appsDict setObject:[NSNumber numberWithInteger:1] forKey:t.bundleid];
        }
    }
    
    //NSLog(@"%@", appsDict);
    
    return appsDict;
}

@end
