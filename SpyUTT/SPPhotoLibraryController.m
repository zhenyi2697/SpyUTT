//
//  SPPhotoLibraryController.m
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-24.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SPPhotoLibraryController.h"

@implementation SPPhotoLibraryController

@synthesize photoGPSInfoDic = _photoGPSInfoDic, photos = _photos;

@synthesize delegate = _delegate;

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
    
    dispatch_queue_t enumeratePhotoQueue = dispatch_queue_create("Photo enumeration", NULL);
    dispatch_async(enumeratePhotoQueue, ^{
        [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos  //ALAssetsGroupPhotoStream
                          usingBlock:^(ALAssetsGroup *group, BOOL *stop)
         {
             int numberOfPhotos = [group numberOfAssets];
             
             [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
              {
                  if (asset) { //&& [[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]
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
              }];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.photos = collector;
                 self.photoGPSInfoDic = gpsInfoDic;
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

@end
