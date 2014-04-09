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

#define kFirstTimeLoadDataKey @"first_time_load"
#define kUserListKey @"user_list"
#define kUserCreatedFoodListKey @"user_added_foods"

@interface MasterViewController () {
    MBProgressHUD *loadingHUD;
}

@property (nonatomic, strong) NSMutableArray *userList;

@property (nonatomic, strong) NSMutableArray *foodList;
@property (nonatomic, strong) PIOClient *client;

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
    
    self.client = [[PIOClient alloc]
                   initWithAppKey: @"l7fdO5nw5N7djl8wpmfC2YyBm8nyMoWK5lPabRPd3LEZpq6ltnlpmm0Dqg5SyJ8o"
                   apiURL: @"http://localhost:8000"];

    
    //create atleast one user if it doesnt exist
    if ([[NSUserDefaults standardUserDefaults] objectForKey: kUserListKey]) {
        self.userList = [[NSMutableArray alloc] initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey: kUserListKey]];
    } else {
        self.userList = [[NSMutableArray alloc] init];
        [self createNewUser: @"DefaultUser"];
    }
    
    
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
        [defaults setObject: self.userList forKey: kUserListKey];
    }
    //otherwise just load user list
    else {
        self.userList = [[NSMutableArray alloc] initWithArray: [defaults arrayForKey: kUserListKey]];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Loading
- (void) loadFileData {
    //load data from food_simple.json
    NSString *filePath = [[NSBundle bundleForClass: [self class]] pathForResource: @"food_simple" ofType: @"json"];
    NSString* content = [NSString stringWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: nil];
    
    NSLog(@"%@", content);
    
    NSDictionary *foodJson = [NSJSONSerialization JSONObjectWithData: [content dataUsingEncoding: NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error: nil];
    
    NSArray *foods = [foodJson objectForKey: @"foods"];

    NSMutableDictionary *fidDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *foodObject in foods) {
        
        if ([fidDictionary objectForKey: [foodObject objectForKey: @"id"]]) {
            continue;
        }
        
        FoodEntry *foodEntry = [FoodEntry new];
        
        foodEntry.fid = [foodObject objectForKey: @"id"];
        foodEntry.name = [foodObject objectForKey: @"name"];
        
        [self.foodList addObject: foodEntry];
        
        [fidDictionary setObject: @"exists" forKey: foodEntry.fid];
    }
    
    NSLog(@"%lu", (unsigned long)self.foodList.count);
    
    [self.tableView reloadData];
}

- (void) loadUserCreatedData {
    NSArray *userCreatedFoods = [[NSUserDefaults standardUserDefaults] arrayForKey: kUserCreatedFoodListKey];
    
    for (NSDictionary *userFoodEntry in userCreatedFoods) {
        FoodEntry *foodEntry = [FoodEntry new];
        
        foodEntry.fid = [userFoodEntry objectForKey: @"id"];
        foodEntry.name = [userFoodEntry objectForKey: @"name"];
        
        [self.foodList addObject: foodEntry];
    }
    
    [self.tableView reloadData];
}

/*
 * Add all FoodEntry items to the PredictionIO server (once only)
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

- (void) createNewUser: (NSString *) uname {
    [self.userList addObject: uname];
    [[NSUserDefaults standardUserDefaults] setObject: self.userList forKey: kUserListKey];
    
    [self.client createUserWithUID: uname success:
     ^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
         NSLog(@"%@", responseMessage.message);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self showError: error];
     }];
}

- (void) createNewFoodNamed: (NSString *) name withId: (NSString *) fid {
    FoodEntry *foodEntry = [FoodEntry new];
    
    foodEntry.fid = fid;
    foodEntry.name = name;
    
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



#pragma mark - UITableView Delegate

- (void)insertNewObject:(id)sender
{
    if (!self.foodList) {
        self.foodList = [[NSMutableArray alloc] init];
    }
    [self.foodList insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    FoodEntry *foodEntry = self.foodList[indexPath.row];
    cell.textLabel.text = foodEntry.name;
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

#pragma mark - Error Helper

- (void) showError: (NSError *) error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Error" message: error.localizedDescription delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
    
    [errorAlert show];
}

@end
