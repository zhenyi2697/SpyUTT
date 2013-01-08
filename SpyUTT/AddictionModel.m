//
//  AddictionModel.m
//  ProcSpy
//
//  Created by Zhang on 22/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "AddictionModel.h"
#import "SBTrack+CreateTrack.h"
#import "PTDevice.h"

@implementation AddictionModel
{
    DCDTrackDataController *dataController;
}

-(id)initWithDataController: (DCDTrackDataController *)newDataController
{
    self = [super init];
    //dataController = [[DCDTrackDataController alloc]init];
    dataController = newDataController;
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
        if ([t.bundleid isEqualToString:@""] || [@"abcdefghijklmnopqrstuvwxyz" rangeOfString:[t.bundleid substringToIndex:1]].location == NSNotFound || [t.bundleid rangeOfString:@"."].location == NSNotFound){
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
    
    //NSString *wiredString = @"q t h p/! p'&! ";
    
    for(SBTrack *t in result){
        
        if ([t.bundleid isEqualToString:@""] || [@"abcdefghijklmnopqrstuvwxyz" rangeOfString:[t.bundleid substringToIndex:1]].location == NSNotFound || [t.bundleid rangeOfString:@"."].location == NSNotFound){
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

- (void) deleteAll
{
    [dataController deleteAllTracks];
}

- (NSString *)prepareText
{
    /*NSDateFormatter *entireFormatter = [[NSDateFormatter alloc]init];
    [entireFormatter setDateStyle:NSDateFormatterFullStyle];
    [entireFormatter setTimeStyle:NSDateFormatterFullStyle];*/
    
    NSArray *result = [dataController fetchAllTracks];
    
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    [xmlWriter writeStartElement:@"Addictions"];
    [xmlWriter writeAttribute:@"interval" value:@"2"];
    
    for(SBTrack *t in result){
        [xmlWriter writeStartElement:@"App"];
        [xmlWriter writeAttribute:@"bundleId" value:t.bundleid];
        [xmlWriter writeAttribute:@"time" value:t.time.description];
        [xmlWriter writeEndElement];
    }
    
    [xmlWriter writeEndElement];
    
    NSString* xml = [xmlWriter toString];
    
    return xml;
}

@end
