//
//  PredictionIOTests.m
//  PredictionIOTests
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PIOClient.h"
#import "AFHTTPRequestOperation.h"

@interface PredictionIOTests : XCTestCase {
    NSDictionary *testItemToTypesDictionary;
}

@property (nonatomic, strong) PIOClient *client;
@property (nonatomic, strong) NSCondition *networkResponse;

@end


//API KEY
NSString *const APP_KEY = @"BK54NvmtcbJAMdV1RbBFKyeUQlylCxU0EufjMI3e98S5UjGW3ZZQ0Pn0LBsSxj1h";

//Sample Users
NSString *const user1 = @"u001";
NSString *const user2 = @"u002";
NSString *const user3 = @"u003";

//Sample Items
NSString *const item1 = @"i001";
NSString *const item2 = @"i002";
NSString *const item3 = @"i003";

//

@implementation PredictionIOTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.client = [[PIOClient alloc] initWithAppKey: APP_KEY];
    
    testItemToTypesDictionary = @{item1: @[@"t000", @"t001", @"t002"],
                                  item2: @[@"t010", @"t011", @"t012"],
                                  item3: @[@"t020", @"t021", @"t022"]};
    
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateItem
{
    for (NSString *item in [testItemToTypesDictionary allKeys]) {
        __block int status = 0;
        
        NSArray *itemTypes = [testItemToTypesDictionary objectForKey: item1];

        [self.client createItemWithIID: item itypes: itemTypes success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            status = 1;
            NSLog(@"Success!");
            NSLog(@"JSON: %@", responseObject);
            
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            status = 2;
            NSLog(@"Failure!");
            NSLog(@"Error: %@", error);
        }];
        
        while (status == 0)
        {
            // run runloop so that async dispatch can be handled on main thread AFTER the operation has
            // been marked as finished (even though the call backs haven't finished yet).
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate date]];
        }
        
        XCTAssertEqual(status, 1);
    }
    

}

- (void)testDeleteItem
{
    __block int status = 0;

    //delete item1
    [self.client deleteItem: item1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        status = 2;
        NSLog(@"Failure!");
        NSLog(@"Error: %@", error);
    }];
    
    while (status == 0)
    {
        // run runloop so that async dispatch can be handled on main thread AFTER the operation has
        // been marked as finished (even though the call backs haven't finished yet).
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate date]];
    }
    
    XCTAssertEqual(status, 1);

}

- (void)testGetItem
{
    __block int status = 0;
    [self.client getItem: item2 success:^(AFHTTPRequestOperation *operation , id responseObject){
        status = 1;
        NSLog(@"Success!");
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation , NSError *error){
        status = 2;
        NSLog(@"Failure!");
        NSLog(@"Error: %@", error);
    }];
    
    while (status == 0)
    {
        // run runloop so that async dispatch can be handled on main thread AFTER the operation has
        // been marked as finished (even though the call backs haven't finished yet).
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate date]];
    }
    
    XCTAssertEqual(status, 1);
}

- (void)testCreateUser
{
    NSArray *usersToCreate = @[user1, user2, user3];
    
    for (NSString *user in usersToCreate) {
        
        __block int status = 0;
        
        [self.client createUserWithUID: user success:^(AFHTTPRequestOperation *operation, id responseObject) {
            status = 1;
            NSLog(@"Success!");
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            status = 2;
            NSLog(@"Failure!");
            NSLog(@"Error: %@", error);
        }];
        
        while (status == 0)
        {
            // run runloop so that async dispatch can be handled on main thread AFTER the operation has
            // been marked as finished (even though the call backs haven't finished yet).
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate date]];
        }
        
        XCTAssertEqual(status, 1);
    }
    
}

- (void)testDeleteUser
{
    for (NSString *user in @[item1]) {
        __block int status = 0;
        
        [self.client deleteUser: user2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            status = 1;
            NSLog(@"Success!");
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            status = 2;
            NSLog(@"Failure!");
            NSLog(@"Error: %@", error);
        }];
        
        while (status == 0)
        {
            // run runloop so that async dispatch can be handled on main thread AFTER the operation has
            // been marked as finished (even though the call backs haven't finished yet).
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate date]];
        }
        
        XCTAssertEqual(status, 1);
    }

}

- (void)testNewCreateItemRequest
{
    NSArray *itypes = [testItemToTypesDictionary objectForKey: item3];
    
    PIOCreateItemRequest *createItemRequest = [[PIOCreateItemRequest alloc] initWithApiUrl: @"" apiFormat: @"" appkey: APP_KEY iid: item3 itypes: itypes];
    
    __block int status = 0;

    [self.client createItemWithRequest: createItemRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        status = 2;
        NSLog(@"Failure!");
        NSLog(@"Error: %@", error);
    }];
    
    while (status == 0)
    {
        // run runloop so that async dispatch can be handled on main thread AFTER the operation has
        // been marked as finished (even though the call backs haven't finished yet).
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate date]];
    }
    
    XCTAssertEqual(status, 1);

//- (PIOCreateItemRequest *)newCreateItemRequestWithItemID:(NSString *)iid itypes:(NSArray *)itypes;
}

- (void)testNewCreateUserRequest
{
//- (PIOCreateUserRequest *)newCreateUserRequestWithUserID:(NSString *)uid;
}

- (void)testNewItemRecGetTopNRequest
{
//- (PIOItemRecGetTopNRequest *)newItemRecGetTopNRequestWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes;
}

- (void)testGetItemRecTopN
{
    __block int status = 0;

    [self.client getItemRecTopNWithEngine: @"item-rec" uid: user1 n: 1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        status = 2;
        NSLog(@"Failure!");
        NSLog(@"Error: %@", error);
    }];
    
    while (status == 0)
    {
        // run runloop so that async dispatch can be handled on main thread AFTER the operation has
        // been marked as finished (even though the call backs haven't finished yet).
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate date]];
    }
    
    XCTAssertEqual(status, 1);
    
//- (NSArray *)getItemRecTopNWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n;
}

- (void)testGetItemRecTopNWithAttributes
{
    //TODO: Implement test

//- (NSDictionary *)getItemRecTopNWithAttributesWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes;
}

- (void)testNewItemSimGetTopNRequest
{
    //TODO: Implement test

//- (PIOItemSimGetTopNRequest *)newItemSimGetTopNRequestWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes;
}

-
(void)testGetItemSimTopN
{
    //TODO: Implement test

//- (NSArray *)getItemSimTopNWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n;
}

- (void)testGetItemSimTopNWithAttributes
{
    //TODO: Implement test

//- (NSDictionary *)getItemSimTopNWithAttributesWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes;
}

- (void)testGetStatus
{
    //not implemented
}

- (void)testGetUser
{
    __block int status = 0;
    
    [self.client getUser: user1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        status = 2;
        NSLog(@"Failure!");
        NSLog(@"Error: %@", error);
    }];
    
    while (status == 0)
    {
        // run runloop so that async dispatch can be handled on main thread AFTER the operation has
        // been marked as finished (even though the call backs haven't finished yet).
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate date]];
    }
    
    XCTAssertEqual(status, 1);
}

- (void)testNewUserActionItemRequest
{
    //TODO: Implement test
    
//- (PIOUserActionItemRequest *)newUserActionItemRequestWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid;
}

- (void)testIdentifyUserID
{
    //TODO: Implement test

//- (void)identifyUserID:(NSString *)uid;
}

- (void)testUserActionItem
{
    //like action for item1 by user1
    __block int status = 0;

    [self.client userActionItemWithUID: user1 action: @"like" iid: item1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        status = 2;
        NSLog(@"Failure!");
        NSLog(@"Error: %@", error);
    }];
    
    
    while (status == 0)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate date]];
    }
    
    XCTAssertEqual(status, 1);
    
    status = 0;
    
    //dislike action for item 2 by user1
    [self.client userActionItemWithUID: user1 action: @"dislike" iid: item2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        status = 2;
        NSLog(@"Failure!");
        NSLog(@"Error: %@", error);
    }];
    
    while (status == 0)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate date]];
    }
    
    XCTAssertEqual(status, 1);
    
    status = 0;
    
    //view action for item 3 by user1
    [self.client userActionItemWithUID: user1 action: @"view" iid: item3 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        status = 2;
        NSLog(@"Failure!");
        NSLog(@"Error: %@", error);
    }];
    
    while (status == 0)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate date]];
    }
    
    XCTAssertEqual(status, 1);
    
//- (void)userActionItemWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid;
}

#define Helper Methods


@end
