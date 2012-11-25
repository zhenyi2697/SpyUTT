//
//  PROCAppDetection.h
//  ProcSpy
//
//  Created by Zhang on 24/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iHasApp.h"

@interface PROCAppDetection : iHasApp

- (void)retrieveAppDictionariesForAppBundleIds:(NSArray *)appBundleIds
                                   withSuccess:(void (^)(NSArray *appDictionaries))successBlock
                                   withFailure:(void (^)(NSError *error))failureBlock;
/*- (void)retrieveAppDictionariesForProcName:(NSString *)ProcName
 withSuccess:(void (^)(NSArray *appDictionaries))successBlock
 withFailure:(void (^)(NSError *error))failureBlock;*/

- (NSDictionary *)retrieveBuiltInAppDictionariesForBundleId:(NSString *)bundleId;

@end
