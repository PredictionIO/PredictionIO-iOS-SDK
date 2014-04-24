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
#import "AppDelegate.h"

@interface DetailViewController () {
    IBOutlet UIView *imageContainerView;
    IBOutlet UIView *ratingContainerView;
    
    int chosenRating;
    BOOL didEdit;
}

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Rate your Food!";
    
    self.client = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).client;
    
    //if user not set, take current selected user
    if(self.user == nil) {
        self.user   = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentUser;
    }

    self.detailDescriptionLabel.text = self.foodEntry.name;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [self getAndSetFoodImageURL];
    
    [self addRatingControl];

    [self recordView];
}

#pragma mark - Send PIO Actions

- (IBAction) makeConversion {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    [self.client userActionItemWithUID: self.user action: @"conversion" iid: self.foodEntry.fid success:
     ^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

         NSLog(@"Made a conversion for %@", self.foodEntry.name);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

        if (error) {
            [[[UIAlertView alloc] initWithTitle: @"Conversion Error" message: [error localizedDescription] delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
        }
    }];
}

- (void) rateFood: (int) rating {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];

    PIOUserActionItemRequest *userActionItemRequest = [self.client newUserActionItemRequestWithUID: self.user action: @"rate" iid: self.foodEntry.fid];

    userActionItemRequest.rate = [NSNumber numberWithInt: rating];
    [self.client userActionItemWithRequest: userActionItemRequest success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        NSLog(@"Succesfully made a rating of %i for %@", rating, self.foodEntry.name);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

        [[[UIAlertView alloc] initWithTitle: @"Rating Error" message: [error localizedDescription] delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];

    }];
}

- (void) recordView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];

    [self.client userActionItemWithUID: self.user action: @"view" iid: self.foodEntry.fid success:
     ^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

         NSLog(@"View recorded for %@", self.foodEntry.name);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

         if (error) {
             [[[UIAlertView alloc] initWithTitle: @"View Error" message: [error localizedDescription] delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
         }
     }];
}

#pragma mark - getting an image for the food name
/*
 * Use http://image_name.jpg.to to get the image, where "image_name" is the name of the item, and parse the html to get the src img
 */
- (void) getAndSetFoodImageURL {
    NSString *urlName = [self.foodEntry.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSURL *imageURL = [NSURL URLWithString: [NSString stringWithFormat: @"http://%@.jpg.to", urlName]];
    
    [NSURLConnection sendAsynchronousRequest: [NSURLRequest requestWithURL: imageURL] queue: [NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

         if (connectionError) {
             [[[UIAlertView alloc] initWithTitle: @"Image Error" message: [connectionError localizedDescription] delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
             
             return;
         }
         
         NSString *html = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
         NSLog(@"%@", html);
         
         NSXMLParser *parser = [[NSXMLParser alloc] initWithData: data];
         parser.delegate = self;
         [parser parse];
     }];
    
}
#pragma mark - XML Parsing
/*
 *(from above, get the image src address)
 */
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString: @"img"]) {
        NSString *srcUrl = [attributeDict objectForKey: @"src"];
        [self setFoodImageView: srcUrl];
    }
}

#pragma mark Food Image Setup

- (void) setFoodImageView: (NSString *) imageUrl {
    //set image view
    PAImageView *avatarView = [[PAImageView alloc] initWithFrame: imageContainerView.frame backgroundProgressColor:[UIColor grayColor] progressColor:[UIColor redColor]];
    [self.view addSubview: avatarView];
    
    [avatarView setImageURL: imageUrl];
}

#pragma mark Rating Control Setup

- (void) addRatingControl {
    //set rating control
    AMRatingControl *ratingControl = [[AMRatingControl alloc] initWithLocation: ratingContainerView.frame.origin andMaxRating: 5];
    
    [ratingControl setStarFontSize: 40];
    [ratingControl setStarWidthAndHeight: 40];
    
    // Customize the current rating if needed
    [ratingControl setRating: 0];
    
    
    // Define block to handle events
    ratingControl.editingChangedBlock = ^(NSUInteger rating)
    {
        didEdit = YES;
    };
    
    ratingControl.editingDidEndBlock = ^(NSUInteger rating)
    {
        chosenRating = (int)rating;
        [self rateFood: chosenRating];
        didEdit = NO;
    };
    
    [self.view addSubview: ratingControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
