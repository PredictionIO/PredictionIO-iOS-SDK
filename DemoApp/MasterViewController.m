//
//  MasterViewController.m
//  DemoApp
//
//  Created by Alex Grinman on 4/7/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import "MasterViewController.h"
#import "PIOClient.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "FoodEntry.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "UserViewController.h"

//userdefaults dictionary keys
#define kFirstTimeLoadDataKey @"first_time_load"
#define kUserCreatedFoodListKey @"user_added_foods"

//uialertview tag identifiers
#define kFoodNameAlertTag 0

@interface MasterViewController () {
    MBProgressHUD *loadingHUD;
}

@property (nonatomic, strong) PIOClient *client;
@property (nonatomic, strong) NSMutableArray *foodList;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Food Predictior";
    
    self.client = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).client;
    
    //create food list of FoodEntry objects
    self.foodList = [[NSMutableArray alloc] init];
    
    //load data from file
    [self loadFileData];
    
    //load data from user
    [self loadUserCreatedData];
    
    //First time: send sample data to PredictionIO server
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey: kFirstTimeLoadDataKey] == nil) {
        loadingHUD = [[MBProgressHUD alloc] initWithView: self.view];
        loadingHUD.labelText = @"Creating PredictionIO items...";
        [loadingHUD show: YES];
        
        [self performSelectorInBackground: @selector(loadDataToPredictionIOServer) withObject: nil];
        
        [defaults setObject: @"no" forKey: kFirstTimeLoadDataKey];
    }
    

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewFoodEntry)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Open User Rec View Controller

- (IBAction) openUsers {
    UserViewController *userViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"UserViewController"];
    [self.navigationController pushViewController: userViewController animated: YES];
}

#pragma mark - Data Loading
- (void) loadFileData {
    //load data from food_simple.json
    NSString *filePath = [[NSBundle bundleForClass: [self class]] pathForResource: @"food_simple" ofType: @"json"];
    NSString* content = [NSString stringWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: nil];
    
    NSLog(@"%@", content);
    
    NSDictionary *foodJson = [NSJSONSerialization JSONObjectWithData: [content dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error: nil];
    
    NSArray *foods = [foodJson objectForKey: @"foods"];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (NSDictionary *foodObject in foods) {
        
        if ([appDelegate.foodDictionary objectForKey: [foodObject objectForKey: @"id"]]) {
            continue;
        }
        
        FoodEntry *foodEntry = [FoodEntry new];
        
        foodEntry.fid = [foodObject objectForKey: @"id"];
        foodEntry.name = [foodObject objectForKey: @"name"];
        
        [self.foodList addObject: foodEntry];
        
        [appDelegate.foodDictionary setObject: foodEntry forKey: foodEntry.fid];
    }
    
    NSLog(@"%lu", (unsigned long)self.foodList.count);
    
    [self.tableView reloadData];
}

- (void) loadUserCreatedData {
    NSArray *userCreatedFoods = [[NSUserDefaults standardUserDefaults] arrayForKey: kUserCreatedFoodListKey];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (NSDictionary *userFoodEntry in userCreatedFoods) {
        FoodEntry *foodEntry = [FoodEntry new];
        
        foodEntry.fid = [userFoodEntry objectForKey: @"id"];
        foodEntry.name = [userFoodEntry objectForKey: @"name"];
        
        [self.foodList insertObject: foodEntry atIndex: 0];
        [appDelegate.foodDictionary setObject: foodEntry forKey: foodEntry.fid];
    }
    
    [self.tableView reloadData];
}


/*
 * Add all FoodEntry items to the PredictionIO server (first run only)
 */
- (void) loadDataToPredictionIOServer {
    
    //create all the items
    for (FoodEntry *foodEntry in self.foodList) {
        [self.client createItemWithIID: foodEntry.fid itypes: @[@"food"] success: nil failure: nil];
    }
    
    loadingHUD.labelText = @"Done!";
    [loadingHUD hide: YES afterDelay: 0.5];
}

#pragma mark - adding user data

- (void) createNewFoodNamed: (NSString *) name withId: (NSString *) fid {
    FoodEntry *foodEntry = [FoodEntry new];
    
    foodEntry.fid = fid;
    foodEntry.name = name;
    
    //create the food on PIO server
    [self.client createItemWithIID: foodEntry.fid itypes: @[@"food"] success: nil failure: nil];
    
    //insert to the front of the food list
    [self.foodList insertObject: foodEntry atIndex: 0];
    
    //save to userCreatedFoodList (update persistant storage)
    NSArray *userCreatedFoods = [[NSUserDefaults standardUserDefaults] arrayForKey: kUserCreatedFoodListKey];
    if (userCreatedFoods == nil) {
        userCreatedFoods = @[@{@"id": fid, @"name": name}];
        
        [[NSUserDefaults standardUserDefaults] setObject: userCreatedFoods forKey: kUserCreatedFoodListKey];
    } else {
        NSMutableArray *newUserCreatedFoods = [NSMutableArray arrayWithArray: userCreatedFoods];
        [newUserCreatedFoods addObject: @{@"id": fid, @"name": name}];
        
        [[NSUserDefaults standardUserDefaults] setObject: newUserCreatedFoods forKey: kUserCreatedFoodListKey];
    }
    
    [self.tableView reloadData];
}

#pragma UI Actions

- (void) addNewFoodEntry {
    UIAlertView *addNewFoodAlert = [[UIAlertView alloc] initWithTitle:@"Add a new Food" message:@"What's it called?" delegate: self cancelButtonTitle:@"Add it" otherButtonTitles:nil];
    
    addNewFoodAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    addNewFoodAlert.tag = kFoodNameAlertTag;
    [addNewFoodAlert show];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.foodList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Select a Food to view it, rate it, or make a conversion";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    FoodEntry *foodEntry = self.foodList[indexPath.row];
    cell.textLabel.text = foodEntry.name;
    [cell.textLabel setFont: [UIFont fontWithName: @"HelveticaNeue" size: 18]];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.foodList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FoodEntry *foodEntry = self.foodList[indexPath.row];
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
        detailViewController.foodEntry = foodEntry;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kFoodNameAlertTag) {
        
        NSString *name = [alertView textFieldAtIndex: 0].text;
        NSString *fid  = name;
        
        [self createNewFoodNamed: name withId: fid];
        
        [self.tableView reloadData];
    }
}

@end
