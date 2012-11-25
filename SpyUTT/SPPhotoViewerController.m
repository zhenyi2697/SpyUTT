//
//  SPPhotoViewerController.m
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-24.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SPPhotoViewerController.h"

@interface SPPhotoViewerController ()

@end

@implementation SPPhotoViewerController

@synthesize photo = _photo;
@synthesize imageView = _imageView, scrollView = _scrollView;

- (void)configureView
{
    // Update the user interface for the detail item.
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    UIImage *image = [UIImage imageWithCGImage:[[self.photo defaultRepresentation] fullScreenImage]];
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
    //self.imageView.frame = CGRectMake(0,0,self.imageView.image.size.width,self.imageView.image.size.height);
    self.imageView.frame = CGRectMake(0, 0, 320, 504);
}

- (void)setPhoto:(ALAsset *)photo
{
    if (_photo != photo) {
        _photo = photo;
        [self configureView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(UIBarButtonItem *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
