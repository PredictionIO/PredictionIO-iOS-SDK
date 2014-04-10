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

//userdefaults dictionary keys
#define kFirstTimeLoadDataKey @"first_time_load"
#define kUserListKey @"user_list"
#define kUserCreatedFoodListKey @"user_added_foods"

//uialertview tag identifiers
#define kFoodNameAlertTag 0

#define kDefaultUser @"DefaultUser"

@interface MasterViewController () {
    MBProgressHUD *loadingHUD;
    NSString *currentUser;
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
        
        currentUser = [self.userList objectAtIndex: 0];
    } else {
        self.userList = [[NSMutableArray alloc] init];
        currentUser = kDefaultUser;
        [self createNewUser: kDefaultUser];
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
    

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewFoodEntry)];
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
        
        [self.foodList insertObject: foodEntry atIndex: 0];
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
        detailViewController.client = self.client;
        detailViewController.foodEntry = foodEntry;
        detailViewController.user = currentUser;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kFoodNameAlertTag) {
        
        NSString *name = [alertView textFieldAtIndex: 0].text;
        NSString *fid  = name;
        
        [self createNewFoodNamed: name withId: fid];
    }
}

#pragma mark - Error Helper

- (void) showError: (NSError *) error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Error" message: error.localizedDescription delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
    
    [errorAlert show];
}

@end
