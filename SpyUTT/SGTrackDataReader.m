//
//  SGTrackDataReader.m
//  SpyUTT
//
//  Created by Zhenyi ZHANG on 2013-01-08.
//  Copyright (c) 2013 Zhenyi Zhang. All rights reserved.
//

#import "SGTrackDataReader.h"
#import "XMLWriter.h"

@interface SGTrackDataReader ()

@property (nonatomic,strong) UIManagedDocument *trackDatabase;

@end

@implementation SGTrackDataReader
@synthesize trackDatabase = _trackDatabase;

-(SGTrackDataReader *)init
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
            
                    }];
    }else if (self.trackDatabase.documentState == UIDocumentStateClosed) { //如果数据库被关闭里，那么就打开它
        [self.trackDatabase openWithCompletionHandler:^(BOOL success){
            
        }];
    } else if (self.trackDatabase.documentState == UIDocumentStateNormal) { //如果状态正常（已经被打开了）

    } else if(self.trackDatabase.documentState == UIDocumentStateInConflict) {

    } else if(self.trackDatabase.documentState == UIDocumentStateEditingDisabled) {

    }
}

-(void)setTrackDatabase:(UIManagedDocument *)trackDatabase
{
    if (_trackDatabase != trackDatabase) {
        _trackDatabase = trackDatabase;
        [self useDocument];
    }
}

-(NSArray *)allTracks
{
    NSManagedObjectContext *myContext = self.trackDatabase.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError * error = nil;
    NSArray * tracks = [myContext executeFetchRequest:request error:&error];
    
    return tracks;
}

-(NSString *)prepareText
{
    // allocate serializer
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    // start writing XML elements
    [xmlWriter writeStartElement:@"Tracks"];
    
    NSArray *allTracks = [self allTracks];
    NSArray *locations = nil;
    for (Track *track in allTracks) {
        [xmlWriter writeStartElement:@"Track"];
        [xmlWriter writeAttribute:@"type" value:track.type];
        [xmlWriter writeAttribute:@"interval" value:[track.interval description]];
        locations = [track.locations allObjects];
        
        for (Location *location in locations) {
            [xmlWriter writeStartElement:@"Location"];
            
            [xmlWriter writeStartElement:@"Time"];
            [xmlWriter writeCharacters: [location.currentTime description]];
            [xmlWriter writeEndElement];
            
            [xmlWriter writeStartElement:@"Longitude"];
            [xmlWriter writeCharacters: [location.longitude description]];
            [xmlWriter writeEndElement];
            
            [xmlWriter writeStartElement:@"Latitude"];
            [xmlWriter writeCharacters: [location.latitude description]];
            [xmlWriter writeEndElement];
            
            [xmlWriter writeEndElement];
        }
        
        [xmlWriter writeEndElement];
    }
    
    [xmlWriter writeEndElement];
    
    NSString *xml = [xmlWriter toString];
    return xml;
}

@end
