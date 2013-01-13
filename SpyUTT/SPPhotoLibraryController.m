//
//  SPPhotoLibraryController.m
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-24.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SPPhotoLibraryController.h"
#import "XMLWriter.h"

@implementation SPPhotoLibraryController

@synthesize photoGPSInfoDic = _photoGPSInfoDic, photos = _photos;

@synthesize delegate = _delegate;

@synthesize allPhotosAreLoaded = _allPhotosAreLoaded;

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

-(NSDictionary *)getGPSInfoForPhoto:(ALAsset *)photo
{
    ALAssetRepresentation *representation = [photo defaultRepresentation];
    NSDictionary *metaDictionary = [representation metadata];
    NSString *keyForGPS = @"{GPS}";
    NSArray *allKeys = [metaDictionary allKeys];
    if ([allKeys containsObject:keyForGPS]) {
        return [metaDictionary objectForKey:keyForGPS];
    }
    return nil;
}

- (void)initDefaultPhotoLibrary
{
    // collect the photos
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *gpsInfoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    ALAssetsLibrary *al = [SPPhotoLibraryController defaultAssetsLibrary];
    self.allPhotosAreLoaded = NO;
    
    dispatch_queue_t enumeratePhotoQueue = dispatch_queue_create("Photo enumeration", NULL);
    
    dispatch_async(enumeratePhotoQueue, ^{
        [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos  //ALAssetsGroupPhotoStream
                          usingBlock:^(ALAssetsGroup *group, BOOL *stop)
         {
             int numberOfPhotos = [group numberOfAssets];
             
             void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
             {
                 if (asset)
                 {
                     [collector addObject:asset];
                     NSDictionary *gpsDic = [self getGPSInfoForPhoto:asset];
                     if (gpsDic) {
                         [gpsInfoDic setObject:gpsDic forKey:[NSString stringWithFormat:@"%d",index]];
                     }
                     float progress = index / (float)numberOfPhotos;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.delegate photoLibraryController:self hasUpdatedProgress:progress];
                     });
                 }
             };
             
             if (numberOfPhotos < 10) {
                  [group enumerateAssetsUsingBlock: assetEnumerator];
             } else {
                 
                 for (int i = 0; i < [group numberOfAssets]; i += 10) {
                     NSRange range;
                     range.location = i;
                     range.length = 10;
                     
                     if (i + 10 >= [group numberOfAssets]) {
                         range.length = [group numberOfAssets] - i;
                     }
                     
                     NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange: range];
                     
                     [group enumerateAssetsAtIndexes: set options:0 usingBlock: assetEnumerator];
                 }
             }
             
//             [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
//              {
//                  if (asset) { //&& [[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]
//                      [collector addObject:asset];
//                      NSDictionary *gpsDic = [self getGPSInfoForPhoto:asset];
//                      if (gpsDic) {
//                          [gpsInfoDic setObject:gpsDic forKey:[NSString stringWithFormat:@"%d",index]];
//                      }
//                      float progress = index / (float)numberOfPhotos;
//                      dispatch_async(dispatch_get_main_queue(), ^{
//                          [self.delegate photoLibraryController:self hasUpdatedProgress:progress];
//                    });
//                  }
//              }];
             
             self.photos = collector;
             self.photoGPSInfoDic = gpsInfoDic;
             self.allPhotosAreLoaded = YES;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.delegate photoLibraryControllerhasFinishedEnumeratingPhotos:self];
             });
         }
            failureBlock:^(NSError *error) { NSLog(@"Boom!!!");}
         ];
    });
}

- (id)init {
    if (self = [super init]) {
        [self initDefaultPhotoLibrary];
        return self;
    }
    return nil;
}

- (int)numberOfPhotoInLibrary
{
    return [self.photos count];
}

- (ALAsset *)photoAtIndex:(int)index
{
    return [self.photos objectAtIndex:index];
}

- (NSString *)prepareTextForPhoto:(ALAsset *)photo
{
    NSString *assetType = [photo valueForProperty:ALAssetPropertyType];
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    if ([assetType isEqualToString:ALAssetTypePhoto]){
        //get image metadata
        ALAssetRepresentation *representation = [photo defaultRepresentation];
        NSDictionary *metaDictionary = [representation metadata];
        //get all keys from root metadata dictionary
        NSArray *allKeys = [metaDictionary allKeys];
        
        //now get all values from metadata dictionary
        for(NSString *key in allKeys) {
            
            if ([key isEqualToString:@"{GPS}"]) {
                [xmlWriter writeStartElement:@"Photo"];
                id objectForSection = [metaDictionary objectForKey:key];
                [xmlWriter writeStartElement:key];
                
                //if the value is also a dictionary, then go into it
                //if ([objectForSection isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *dic = (NSDictionary *)objectForSection;
                    NSArray *keys = [(NSDictionary *)objectForSection allKeys];
                    
                    for (NSString *key2 in keys) {
                        //write each value to xml...
                        [xmlWriter writeStartElement:key2];
                        [xmlWriter writeCharacters:[[dic objectForKey:key2] description]]; // write last level value to xml
                        [xmlWriter writeEndElement];
                    }
                    
                //} else {
                //    // the value is just some string, then wirte directly to xml
                //    [xmlWriter writeCharacters:[[metaDictionary objectForKey:key] description]];
                //}
                [xmlWriter writeEndElement]; // end for children dictionary for value tag
                
                [xmlWriter writeEndElement]; // end for tag <Photo>
            }
        }
        
    }
//    else {
//        [xmlWriter writeStartElement:@"Video"];
//        
//        [xmlWriter writeStartElement:@"Duration"];
//        float duration = [(NSNumber *)[photo valueForProperty:ALAssetPropertyDuration] floatValue];
//        [xmlWriter writeCharacters:[NSString stringWithFormat:@"%.2f s",duration]];
//        [xmlWriter writeEndElement];
//        
//        [xmlWriter writeStartElement:@"Size"];
//        long long size = [[photo defaultRepresentation] size];
//        float sizeInFloat = (long double)size/(1024 * 1024);
//        [xmlWriter writeCharacters:[NSString stringWithFormat:@"%.2f MB",sizeInFloat]];
//        [xmlWriter writeEndElement];
//        
//    }
    
    NSString *photoMetaDataText = [xmlWriter toString];
    
    return photoMetaDataText;
}

-(NSString *)prepareText
{
    NSString *photoText = [NSString stringWithFormat:@""];

    //for (ALAsset *photo in self.photos) {
    for (int i = 0; i < 50; i++) {
        photoText = [photoText stringByAppendingFormat:@"%@",[self prepareTextForPhoto:[self.photos objectAtIndex:i]]];
    }
    
    return photoText;
}

@end
