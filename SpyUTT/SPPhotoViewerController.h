//
//  SPPhotoViewerController.h
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-24.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SPPhotoViewerController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) ALAsset *photo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)close:(UIBarButtonItem *)sender;
@end
