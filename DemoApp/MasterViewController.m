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

#define kFirstTimeLoadDataKey @"first_time_load"


@interface MasterViewController () {
    MBProgressHUD *loadingHUD;
}

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

    
    [self loadData];
    
    //First time: load sample data to PredictionIO server
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey: kFirstTimeLoadDataKey] == nil) {
        
        loadingHUD = [[MBProgressHUD alloc] initWithView: self.view];
        loadingHUD.labelText = @"Loading data...";
        [loadingHUD show: YES];
        
        [self performSelectorInBackground: @selector(loadDataToPredictionIOServer) withObject: nil];
        
        [defaults setObject: @"no" forKey: kFirstTimeLoadDataKey];
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
- (void) loadData {
    //load data from food_simple.json
    NSString *filePath = [[NSBundle bundleForClass: [self class]] pathForResource: @"food_simple" ofType: @"json"];
    NSData* content = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary *foodJson = [NSJSONSerialization JSONObjectWithData: content options:NSJSONReadingAllowFragments error: nil];
    
    NSArray *foods = [foodJson objectForKey: @"foods"];
    
    //create food list of FoodEntry objects
    self.foodList = [[NSMutableArray alloc] init];

    for (NSDictionary *foodObject in foods) {
        FoodEntry *foodEntry = [FoodEntry new];
        
        foodEntry.fid = [foodObject objectForKey: @"id"];
        foodEntry.name = [foodObject objectForKey: @"name"];
        
        [self.foodList addObject: foodEntry];
    }
}

/*
 * Add all FoodEntry items to the PredictionIO server (once only)
 */
- (void) loadDataToPredictionIOServer {

    
    loadingHUD.labelText = @"Done!";
    [loadingHUD hide: YES afterDelay: 0.5];
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FoodEntry *object = self.foodList[indexPath.row];
        [[segue destinationViewController] setDetailItem: object];
    }
}

@end
