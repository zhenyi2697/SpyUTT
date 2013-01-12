//
//  SPPhotoMetaDataController.m
//  SpyUTT
//
//  Created by Zhenyi ZHANG on 2013-01-12.
//  Copyright (c) 2013 Zhenyi Zhang. All rights reserved.
//

#import "SPPhotoMetaDataController.h"
#import "XMLWriter.h"

@interface SPPhotoMetaDataController()

@end

@implementation SPPhotoMetaDataController

@synthesize photo = _photo;

- (SPPhotoMetaDataController *)initWithPhoto:(ALAsset *)photo
{
    self = [super init];
    if (self) {
        self.photo = photo;
    }
    return self;
}

- (NSString *)prepareText
{
    ALAssetRepresentation *representation = [self.photo defaultRepresentation];
    
    NSString *assetType = [self.photo valueForProperty:ALAssetPropertyType];
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    if ([assetType isEqualToString:ALAssetTypePhoto]){
        //get image metadata
        NSDictionary *metaDictionary = [representation metadata];
        //get all keys from root metadata dictionary
        NSArray *allKeys = [metaDictionary allKeys];
        
        // WRITE XML <Photo> tag
        [xmlWriter writeStartElement:@"Photo"];
        
        //now get all values from metadata dictionary
        for(NSString *key in allKeys) {
            id objectForSection = [metaDictionary objectForKey:key];
            [xmlWriter writeStartElement:key];
            
            //if the value is also a dictionary, then go into it
            if ([objectForSection isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dic = (NSDictionary *)objectForSection;
                NSArray *keys = [(NSDictionary *)objectForSection allKeys];
                
                for (NSString *key2 in keys) {
                    //write each value to xml...
                    [xmlWriter writeStartElement:key2];
                    [xmlWriter writeCharacters:[[dic objectForKey:key2] description]]; // write last level value to xml
                    [xmlWriter writeEndElement];
                }
                
            } else {
                // the value is just some string, then wirte directly to xml
                [xmlWriter writeCharacters:[[metaDictionary objectForKey:key] description]];
            }
            [xmlWriter writeEndElement]; // end for children dictionary for value tag
        }
        
    } else {
        [xmlWriter writeStartElement:@"Video"];
        
        [xmlWriter writeStartElement:@"Duration"];
        float duration = [(NSNumber *)[self.photo valueForProperty:ALAssetPropertyDuration] floatValue];
        [xmlWriter writeCharacters:[NSString stringWithFormat:@"%.2f s",duration]];
        [xmlWriter writeEndElement];
        
        [xmlWriter writeStartElement:@"Size"];
        long long size = [[self.photo defaultRepresentation] size];
        float sizeInFloat = (long double)size/(1024 * 1024);
        [xmlWriter writeCharacters:[NSString stringWithFormat:@"%.2f MB",sizeInFloat]];
        [xmlWriter writeEndElement];
        
    }
    
    [xmlWriter writeEndElement];
    NSString *photoMetaDataText = [xmlWriter toString];
    
    return photoMetaDataText;
}


@end
