//
//  AppDelegate.m
//  DemoApp
//
//  Created by Alex Grinman on 4/7/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#define kDefaultUser @"DefaultUser"
#define kUserListKey @"user_list"

#define kCurrentUserKey @"current_user"

#pragma mark - UIApplication Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.client = [[PIOClient alloc]
                   initWithAppKey: @"l7fdO5nw5N7djl8wpmfC2YyBm8nyMoWK5lPabRPd3LEZpq6ltnlpmm0Dqg5SyJ8o"
                   apiURL: @"http://localhost:8000"];
    
    //create atleast one user if it doesnt exist
    if ([[NSUserDefaults standardUserDefaults] objectForKey: kUserListKey]) {
        self.userList = [[NSMutableArray alloc] initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey: kUserListKey]];

        self.currentUser = [[NSUserDefaults standardUserDefaults] objectForKey: kCurrentUserKey];
    } else {
        self.userList = [[NSMutableArray alloc] init];
        self.currentUser = kDefaultUser;
        [self createNewUser: kDefaultUser];
        
        [[NSUserDefaults standardUserDefaults] setObject: kDefaultUser forKey: kCurrentUserKey];
    }
    
    self.foodDictionary = [[NSMutableDictionary alloc] init];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark PIO Create New user

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

- (void) changeCurrentUserTo: (NSString *) user {
    if ([self.userList indexOfObject: user] == NSNotFound) {
        return;
    }
    
    self.currentUser = user;
    [[NSUserDefaults standardUserDefaults] setObject: user forKey: kCurrentUserKey];
}

#pragma mark - Error Helper

- (void) showError: (NSError *) error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Error" message: error.localizedDescription delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
    
    [errorAlert show];
}

@end
