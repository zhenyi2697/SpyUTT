//
//  DCDTrackDataController.m
//  DemoCoreData
//
//  Created by Zhenyi ZHANG on 2012-11-06.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "DCDTrackDataController.h"
#import <CoreData/CoreData.h>

@implementation DCDTrackDataController
@synthesize trackDatabase = _trackDatabase;

-(DCDTrackDataController *)init
{
    self = [super init];
    if (self) {
        if (!self.trackDatabase) {
            //创建一个database需要一个url，所以先创建url（url其实就是文件目录）
            //get document directory as a url
            NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            //在url后面append一个子目录
            url = [url URLByAppendingPathComponent:@"Default Track Database"];
            //之后创建database就好了
            self.trackDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        }
    }
    return self;
}

//用于在磁盘新建文档，打开文档等操作
-(void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.trackDatabase.fileURL path]]) {//如果这个database在磁盘里不存在，那么就创建数据库
        [self.trackDatabase saveToURL:self.trackDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            //如果跟tableView相连，可以设定fetchedResultsController...
            //[self setupFetchedResultsController]; // 这里不用等待下一行的fetch结束，因为一旦hook上了controller，如果数据库更新，controller会自动更新数据
            
            //可以再此预添加数据...
            //[self deleteAllTracks];//先删除所有之前的track
        }];
    }else if (self.trackDatabase.documentState == UIDocumentStateClosed) { //如果数据库被关闭里，那么就打开它
        [self.trackDatabase openWithCompletionHandler:^(BOOL success){
            //[self setupFetchedResultsController];
            //...
        }];
    } else if (self.trackDatabase.documentState == UIDocumentStateNormal) { //如果状态正常（已经被打开了）
        //[self setupFetchedResultsController];
        //...
    }
}

-(void)setTrackDatabase:(UIManagedDocument *)trackDatabase
{
    if (_trackDatabase != trackDatabase) {
        _trackDatabase = trackDatabase;
        [self useDocument];
    }
}

- (void)saveTrack:(NSDictionary *)track
{
    NSDate *time = [track objectForKey:@"time"];
    NSString *bundleid = [track objectForKey:@"bundleid"];
    NSManagedObjectContext *myContext = self.trackDatabase.managedObjectContext;
    
    /*NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    //在url后面append一个子目录
    url = [url URLByAppendingPathComponent:@"Default Track Database"];
    //之后创建database就好了
    NSManagedObjectContext *myContext = [[[UIManagedDocument alloc] initWithFileURL:url] managedObjectContext];*/
    
    
    [SBTrack trackWithTime:time WithBundleId:bundleid inManagedContext:myContext];
}

- (NSArray *)fetchAllTracks
{
    NSManagedObjectContext *myContext = self.trackDatabase.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SBTrack" inManagedObjectContext:myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    //request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"bundleid" ascending:YES]];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"1=1"];
    
    NSError * error = nil;
    NSArray * tracks = [myContext executeFetchRequest:request error:&error];
    
    //NSLog(@"%@", tracks);
    
    return tracks;
}

- (NSArray *)fetchAllTracksWithDays:(NSArray *)days WithBeginTime:(NSDate *)beginTime WithEndTime:(NSDate *)endTime
{
    NSManagedObjectContext *myContext = self.trackDatabase.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SBTrack" inManagedObjectContext:myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    //request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(timeOnly >= %@) AND (timeOnly <= %@) AND (day in %@)", beginTime, endTime, days];
    
    //request.propertiesToGroupBy = @"bundleid";
    
    NSError * error = nil;
    NSArray * tracks = [myContext executeFetchRequest:request error:&error];
    return tracks;
}

-(void)deleteAllTracks
{
    NSFetchRequest * allTracks = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *myContext = self.trackDatabase.managedObjectContext;
    [allTracks setEntity:[NSEntityDescription entityForName:@"SBTrack" inManagedObjectContext:myContext]];
    [allTracks setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * tracks = [myContext executeFetchRequest:allTracks error:&error];
    
    //error handling goes here
    for (SBTrack *track in tracks) {
        [myContext deleteObject:track];
    }
    NSError *saveError = nil;
    [myContext save:&saveError];
}



@end
