//
//  TopRecViewController.m
//  PredictionIO-iOS-SDK
//
//  Created by Alex Grinman on 4/16/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import "TopRecViewController.h"
#import "AppDelegate.h"
#import "PIOClient.h"
#import "FoodEntry.h"

@interface TopRecViewController ()

@property (nonatomic, strong) NSMutableArray *recommendedFoodList;
@property (nonatomic, strong) NSString *selectedUser;
@end

@implementation TopRecViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    self.recommendedFoodList = [[NSMutableArray alloc] init];
    [self getRecommendations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get recommendations

- (void) getRecommendations {
    
    NSMutableDictionary *foodDictionary = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).foodDictionary;
    
    PIOClient *client = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).client;
    
    [client getItemRecTopNWithEngine: @"item-rec-attr" uid: self.selectedUser n: 15 success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

         NSArray *topItems = [responseObject objectForKey: @"pio_iids"];
         
         for (NSString *item in topItems) {
             FoodEntry *foodEntry = [foodDictionary objectForKey: item];
             
             if (foodEntry != nil) {
                 [self.recommendedFoodList addObject: foodEntry];
             }
         }
         
         [self.tableView reloadData];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];

        [[[UIAlertView alloc] initWithTitle: @"Error" message: error.localizedDescription delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recommendedFoodList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = ((FoodEntry *)[self.recommendedFoodList objectAtIndex: indexPath.row]).name;
    
    return cell;
}


@end
