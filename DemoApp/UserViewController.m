//
//  UserViewController.m
//  PredictionIO-iOS-SDK
//
//  Created by Alex Grinman on 4/10/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import "UserViewController.h"
#import "AppDelegate.h"


#define kNewUserAlertTag 0
@interface UserViewController ()

@property (nonatomic, strong) NSMutableArray *userList;
@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Users";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.userList = [[NSMutableArray alloc] initWithArray: appDelegate.userList];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewUser)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - New User

- (void) addNewUser {
    UIAlertView *newUserAlert = [[UIAlertView alloc] initWithTitle:@"Add a new User" message:@"What's the user ID?" delegate: self cancelButtonTitle:@"Add it" otherButtonTitles: @"Cancel", nil];
    
    newUserAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    newUserAlert.tag = kNewUserAlertTag;
    [newUserAlert show];
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kNewUserAlertTag && buttonIndex == 0) {
        
        NSString *uid = [alertView textFieldAtIndex: 0].text;
        
        if ([self.userList indexOfObject: uid] != NSNotFound) {
            
            [[[UIAlertView alloc] initWithTitle: @"Error" message: @"User already exists! Cannot add." delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
            
            return;
        }
        
        if ([uid isEqualToString: @""]) {
            [[[UIAlertView alloc] initWithTitle: @"Error" message: @"User ID cannot be empty." delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] show];
            
            return;
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate createNewUser: uid];
        
        self.userList = appDelegate.userList;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Select a User to view their top Food Recommendations!";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
    
    NSString *cellUid = [self.userList objectAtIndex: indexPath.row];
    cell.textLabel.text = cellUid;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //highlight selected user
    if ([appDelegate.currentUser isEqualToString: cellUid]) {
        cell.textLabel.textColor = [UIColor blueColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
