//
//  DetailViewController.m
//  DemoApp
//
//  Created by Alex Grinman on 4/7/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import "DetailViewController.h"
#import "PAImageView.h"
#import "PIOClient.h"

@interface DetailViewController () {
    IBOutlet UIView *imageContainerView;
}

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Rate your Food!";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
