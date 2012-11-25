//
//  PROCAppDetection.m
//  ProcSpy
//
//  Created by Zhang on 24/11/12.
//  Copyright (c) 2012 Zhang. All rights reserved.
//

#import "PROCAppDetection.h"

@implementation PROCAppDetection

- (void)retrieveAppDictionariesForAppBundleIds:(NSArray *)appBundleIds
                                   withSuccess:(void (^)(NSArray *appDictionaries))successBlock
                                   withFailure:(void (^)(NSError *error))failureBlock
{
    dispatch_queue_t retrieval_thread = dispatch_queue_create(NULL, NULL);
    dispatch_async(retrieval_thread, ^{
        
        NSString *appString = [appBundleIds componentsJoinedByString:@","];
        
        NSMutableString *requestUrlString = [NSMutableString new];
        [requestUrlString appendFormat:@"http://itunes.apple.com/lookup"];
        [requestUrlString appendFormat:@"?bundleId=%@", appString];
        [requestUrlString appendFormat:@"&country=%@", self.country];
        
        NSURLResponse *response;
        NSError *connectionError;
        NSMutableURLRequest *request = [NSMutableURLRequest new];
        [request setURL:[NSURL URLWithString:requestUrlString]];
        [request setTimeoutInterval:20.0f];
        [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        NSData *result = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response
                                                           error:&connectionError];
        if (connectionError)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failureBlock)
                {
                    failureBlock(connectionError);
                }
            });
        }
        else
        {
            NSError *jsonError;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:result
                                                                           options:0
                                                                             error:&jsonError];
            if (jsonError)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failureBlock)
                    {
                        failureBlock(jsonError);
                    }
                });
            }
            else
            {
                NSArray *results = [jsonDictionary objectForKey:@"results"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (successBlock)
                    {
                        successBlock(results);
                    }
                });
            }
        }
    });
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    dispatch_release(retrieval_thread);
#endif
}

- (NSDictionary *)retrieveBuiltInAppDictionariesForBundleId:(NSString *)bundleId
{
    NSString *appName;
    UIImage *appIcon;
    if ([bundleId isEqualToString:@"com.apple.mobilemail"]) {
        appIcon = [UIImage imageNamed:@"mail_icon.jpeg"];
        appName = @"Mail";
    }else if ([bundleId isEqualToString:@"com.apple.mobilenotes"]) {
        appIcon = [UIImage imageNamed:@"Notes.png"];
        appName = @"Notes";
    }else if ([bundleId isEqualToString:@"com.apple.videos"]) {
        appIcon = [UIImage imageNamed:@"Videos.png"];
        appName = @"Videos";
    }else if ([bundleId isEqualToString:@"com.apple.Shoebox"]) {
        appIcon = [UIImage imageNamed:@"PassBook-icon.png"];
        appName = @"Passbook";
    }else if ([bundleId isEqualToString:@"com.apple.mobiletimer"]) {
        appIcon = [UIImage imageNamed:@"Clock.png"];
        appName = @"Timer";
    }else if ([bundleId isEqualToString:@"com.apple.MobileAddressBook"]) {
        appIcon = [UIImage imageNamed:@"Contacts.png"];
        appName = @"Contacts";
    }else if ([bundleId isEqualToString:@"com.apple.stocks"]) {
        appIcon = [UIImage imageNamed:@"Stocks.png"];
        appName = @"Stocks";
    }else if ([bundleId isEqualToString:@"com.apple.MobileSMS"]) {
        appIcon = [UIImage imageNamed:@"message_icon.png"];
        appName = @"Message";
    }else if ([bundleId isEqualToString:@"com.apple.Maps"]) {
        appIcon = [UIImage imageNamed:@"map_icon.png"];
        appName = @"Maps";
    }else if ([bundleId isEqualToString:@"com.apple.Preferences"]) {
        appIcon = [UIImage imageNamed:@"Settings.png"];
        appName = @"Preferences";
    }else if ([bundleId isEqualToString:@"com.apple.weather"]) {
        appIcon = [UIImage imageNamed:@"Weather Fahrenheit.png"];
        appName = @"Weather";
    }else if ([bundleId isEqualToString:@"com.apple.mobileslideshow"]) {
        appIcon = [UIImage imageNamed:@"Photos.png"];
        appName = @"Photos";
    }else if ([bundleId isEqualToString:@"com.apple.AppStore"]) {
        appIcon = [UIImage imageNamed:@"App Store.png"];
        appName = @"App Store";
    }else if ([bundleId isEqualToString:@"com.apple.calculator"]) {
        appIcon = [UIImage imageNamed:@"Calcualator.png"];
        appName = @"Calculator";
    }else if ([bundleId isEqualToString:@"com.apple.camera"]) {
        appIcon = [UIImage imageNamed:@"Camera.png"];
        appName = @"Camera";
    }else if ([bundleId isEqualToString:@"com.apple.VoiceMemos"]) {
        appIcon = [UIImage imageNamed:@"Voice Memos  4.2.1.png"];
        appName = @"Voice Memos";
    }else if ([bundleId isEqualToString:@"com.apple.mobilesafari"]) {
        appIcon = [UIImage imageNamed:@"Safari.png"];
        appName = @"Safari";
    }else if ([bundleId isEqualToString:@"com.apple.reminders"]) {
        appIcon = [UIImage imageNamed:@"reminders_icon.jpg"];
        appName = @"Reminders";
    }else if ([bundleId isEqualToString:@"com.apple.mobilecal"]) {
        appIcon = [UIImage imageNamed:@"Calendar.png"];
        appName = @"Calendar";
    }else if ([bundleId isEqualToString:@"com.apple.compass"]) {
        appIcon = [UIImage imageNamed:@"Compass.png"];
        appName = @"Compass";
    }else if ([bundleId isEqualToString:@"com.apple.mobilephone"]) {
        appIcon = [UIImage imageNamed:@"Phone.png"];
        appName = @"Phone";
    }else{
        return nil;
    }
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:appIcon, appName, nil] forKeys:[NSArray arrayWithObjects:@"appIcon", @"appName", nil]];
}


@end
