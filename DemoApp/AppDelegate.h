//
//  AppDelegate.h
//  DemoApp
//
//  Created by Alex Grinman on 4/7/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIOClient.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PIOClient *client;
@property (strong, nonatomic) NSString *currentUser;
@property (strong, nonatomic) NSMutableArray *userList;
@property (nonatomic, strong) NSMutableDictionary *foodDictionary;

- (void) createNewUser: (NSString *) uname;
- (void) changeCurrentUserTo: (NSString *) user;
@end
