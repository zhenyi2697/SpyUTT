//
//  SULauncherViewController.h
//  SpyUTT
//
//  Created by Zhenyi ZHANG on 2012-11-23.
//  Copyright (c) 2012 Zhenyi Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SULauncherViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)showInfo:(UIButton *)sender;
- (IBAction)sendByMail:(id)sender;

@end
