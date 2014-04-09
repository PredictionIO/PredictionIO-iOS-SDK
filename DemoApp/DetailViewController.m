//
//  DetailViewController.m
//  DemoApp
//
//  Created by Alex Grinman on 4/7/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import "DetailViewController.h"
#import "PAImageView.h"
#import "AMRatingControl.h"
#import "PIOClient.h"

@interface DetailViewController () {
    IBOutlet UIView *imageContainerView;
    IBOutlet UIView *ratingContainerView;
}

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Rate your Food!";
    self.detailDescriptionLabel.text = self.foodEntry.name;
    
    //set image view
    PAImageView *avatarView = [[PAImageView alloc] initWithFrame: imageContainerView.frame backgroundProgressColor:[UIColor grayColor] progressColor:[UIColor redColor]];
    [self.view addSubview: avatarView];
    [avatarView setImageURL: @"http://foodwallpaper.info/wp-content/uploads/2014/03/american-food-clipart.png"];
    
    //set rating control
    AMRatingControl *ratingControl = [[AMRatingControl alloc] initWithLocation: ratingContainerView.frame.origin andMaxRating: 5];
    
    [ratingControl setStarFontSize: 40];
    [ratingControl setStarWidthAndHeight: 40];

    // Customize the current rating if needed
    [ratingControl setRating: 3];
    
    
    // Define block to handle events
    ratingControl.editingChangedBlock = ^(NSUInteger rating)
    {
        //[label setText:[NSString stringWithFormat:@"%d", rating]];
    };
    
    ratingControl.editingDidEndBlock = ^(NSUInteger rating)
    {
        //[endLabel setText:[NSString stringWithFormat:@"%d", rating]];
    };
    
    [self.view addSubview: ratingControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
