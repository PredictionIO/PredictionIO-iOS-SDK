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
#import "DetailViewController.h"

@interface TopRecViewController ()

@property (nonatomic, strong) NSMutableArray *recommendedFoodList;
@end

@implementation TopRecViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat: @"%@'s Predictions", self.selectedUser];
    
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
    
    #warning Rec Engine Name specified below, it must match what is on the admin panel
    
    [client getItemRecTopNWithEngine: @"item-rec" uid: self.selectedUser n: 15 success:
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

        NSString *errorMessage = [NSString stringWithFormat: @"%@. Make sure the training of the data model has occured and the PredictionIO server is up and running.", error.localizedDescription];
        
        [[[UIAlertView alloc] initWithTitle: @"Error" message: errorMessage delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];

    FoodEntry *foodEntry = [self.recommendedFoodList objectAtIndex: indexPath.row];
    
    [cell.textLabel setFont: [UIFont fontWithName: @"HelveticaNeue" size: 22]];
    cell.textLabel.text = [NSString stringWithFormat: @"%li. %@", (long)indexPath.row + 1, foodEntry.name];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FoodEntry *foodEntry = [self.recommendedFoodList objectAtIndex: indexPath.row];
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"DetailViewController"];
    detailViewController.foodEntry = foodEntry;
    detailViewController.user = self.selectedUser;
    
    [self.navigationController pushViewController: detailViewController animated: YES];
}


@end
