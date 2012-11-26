//
//  SUAboutViewController.m
//  SpyUTT
//
//  Created by Zhenyi ZHANG on 2012-11-26.
//  Copyright (c) 2012 Zhenyi Zhang. All rights reserved.
//

#import "SUAboutViewController.h"

@interface SUAboutViewController ()

@end

@implementation SUAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(UIBarButtonItem *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
