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
NSString *const user4 = @"u004";

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
    
    testItemToTypesDictionary = @{item1: @[@"t001"],
                                  item2: @[@"t001", @"t002"],
                                  item3: @[@"t002", @"t003"]};
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

        [self.client createItemWithIID: item itypes: itemTypes success: ^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
            status = 1;
            NSLog(@"Success!");
            NSLog(@"Message: %@", responseMessage.message);
            
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
    [self.client deleteItem: item1 success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"Message: %@", responseMessage.message);
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
}

- (void)testGetItem
{
    __block int status = 0;
    [self.client getItem: item2 success:^(AFHTTPRequestOperation *operation , PIOItem *responseItem){
        status = 1;
        NSLog(@"Success!");
        NSLog(@"Response Item IID: %@", responseItem.iid);
    } failure:^(AFHTTPRequestOperation *operation , NSError *error){
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
}

- (void)testGetItemParams
{
    __block int status = 0;
    [self.client getItem: @"testiid2" success:^(AFHTTPRequestOperation *operation , PIOItem *item){
        status = 1;
        NSLog(@"Success!");

        XCTAssertTrue([item.iid isEqualToString: @"testiid2"]);
        
        XCTAssertTrue([item.itypes[0] isEqualToString: @"type1"]);
        XCTAssertTrue([item.itypes[1] isEqualToString: @"type2"]);
        
        XCTAssertTrue([item.startT timeIntervalSince1970] == 123456789);
        XCTAssertTrue([item.endT timeIntervalSince1970] == 1360647801400);
        
        XCTAssertTrue(item.latitude == 12.34);
        XCTAssertTrue(item.longitude == 5.678);
        
        XCTAssertTrue([[item getCustomValueForKey: @"custom2" ] isEqualToString: @"2.34"]);
        XCTAssertTrue([[item getCustomValueForKey: @"custom1" ] isEqualToString: @"value1"]);
        
    } failure:^(AFHTTPRequestOperation *operation , NSError *error){
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
}

- (void)testCreateUser
{
    NSArray *usersToCreate = @[user1, user2, user3];
    
    for (NSString *user in usersToCreate) {
        
        __block int status = 0;
        
        [self.client createUserWithUID: user success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
            status = 1;
            NSLog(@"Success!");
            NSLog(@"Response Message: %@", responseMessage.message);
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
        
        [self.client deleteUser: user success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
            status = 1;
            NSLog(@"Success!");
            NSLog(@"Response Message: %@", responseMessage.message);
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
    }
}

- (void)testNewCreateItemRequest
{
    NSArray *itypes = [testItemToTypesDictionary objectForKey: item3];
    PIOCreateItemRequest *createItemRequest = [self.client newCreateItemRequestWithItemID: item3 itypes: itypes];
    
    __block int status = 0;

    [self.client createItemWithRequest: createItemRequest success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"Response Message: %@", responseMessage.message);
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
}

- (void)testNewCreateItemRequestParams
{
    
    NSString *filePath = [[NSBundle bundleForClass: [self class]] pathForResource: @"testitem" ofType: @"json"];
    NSData* content = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary *sampleResponse = [NSJSONSerialization JSONObjectWithData: content options: NSJSONReadingAllowFragments error: nil];
    
    PIOItem *item = [PIOItem deserializeFromJSON: sampleResponse];
    
    PIOCreateItemRequest *createItemRequest = [self.client newCreateItemRequestWithItemID: item.iid itypes: item.itypes];
    createItemRequest.latitude = [NSNumber numberWithDouble: item.latitude];
    createItemRequest.longitude = [NSNumber numberWithDouble: item.longitude];
    createItemRequest.startT = item.startT;
    createItemRequest.endT = item.endT;
    [createItemRequest addAttributeWithName: @"custom1" value: [item getCustomValueForKey: @"custom1"]];
    [createItemRequest addAttributeWithName: @"custom2" value: [item getCustomValueForKey: @"custom2"]];
    
    __block int status = 0;
    
    [self.client createItemWithRequest: createItemRequest success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"Response Message: %@", responseMessage);
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
}

- (void)testNewCreateUserRequest
{
    PIOCreateUserRequest *createUserRequest = [self.client newCreateUserRequestWithUserID: user4];
    
    __block int status = 0;
    
    [self.client createUserWithRequest: createUserRequest success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"Response Message: %@", responseMessage);
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
}

- (void)testNewItemRecGetTopNRequest
{
    PIOItemRecGetTopNRequest *itemRecGetTopNRequest = [self.client newItemRecGetTopNRequestWithEngine: @"item-rec" uid: user1 n: 10 attributes: nil];
    
    __block int status = 0;
    
    [self.client getItemRecTopNWithRequest: itemRecGetTopNRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

- (void)testGetItemRecTopN
{
    __block int status = 0;

    [self.client getItemRecTopNWithEngine: @"item-rec" uid: user1 n: 10 success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

- (void)testGetItemRecTopNWithAttributes
{
    __block int status = 0;
    
    [self.client getItemRecTopNWithAttributesWithEngine: @"item-rec" uid: user1 n: 10 attributes: @[@"a001", @"a002"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

- (void)testNewItemSimGetTopNRequest
{
    __block int status = 0;
    
    PIOItemSimGetTopNRequest *itemSimGetTopNRequest = [self.client newItemSimGetTopNRequestWithEngine: @"item-sim" iid: item2 n: 10 attributes: nil];
    
    [self.client getItemSimTopNWithRequest: itemSimGetTopNRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

-(void)testGetItemSimTopN
{
    __block int status = 0;

    [self.client getItemSimTopNWithEngine: @"item-sim" iid: item2 n: 10 success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

- (void)testGetItemSimTopNWithAttributes
{
    __block int status = 0;
    
    [self.client getItemSimTopNWithAttributesWithEngine: @"item-sim" iid: item2 n: 10 attributes: @[@"cost",@"price"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}


//- (void)testGetStatus
//{
//    //not implemented
//}

- (void)testGetUser
{
    __block int status = 0;
    
    [self.client getUser: user1 success:^(AFHTTPRequestOperation *operation, PIOUser *user) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"User uid: %@", user.uid);
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
}

- (void)testNewUserActionItemRequest
{
    //User 2 like item 2 - userActionItemRequest
    PIOUserActionItemRequest *userActionItemRequest = [self.client newUserActionItemRequestWithUID: user2 action: @"like" iid: item2];

    __block int status = 0;
    
    [self.client userActionItemWithRequest: userActionItemRequest success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"Response Message: %@", responseMessage.message);
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
}

- (void)testIdentifyUserID
{
    [self.client identifyUserID: user3];
    
    XCTAssertEqual(self.client.uid, user3);
}

- (void)testUserActionItem
{
    //like action for item1 by user1
    __block int status = 0;

    [self.client userActionItemWithUID: user1 action: @"like" iid: item1 success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"Response Message: %@", responseMessage.message);
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
    [self.client userActionItemWithUID: user1 action: @"dislike" iid: item2 success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"Response Message: %@", responseMessage.message);
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
    [self.client userActionItemWithUID: user1 action: @"view" iid: item3 success:^(AFHTTPRequestOperation *operation, PIOMessage *responseMessage) {
        status = 1;
        NSLog(@"Success!");
        NSLog(@"Response Message: %@", responseMessage.message);
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
}

#pragma mark PIO-Object Tests

- (void) testPIOItemDeserialize {
    NSString *filePath = [[NSBundle bundleForClass: [self class]] pathForResource: @"testitem" ofType: @"json"];
    NSData* content = [NSData dataWithContentsOfFile:filePath];
        
    NSDictionary *sampleResponse = [NSJSONSerialization JSONObjectWithData: content options: NSJSONReadingAllowFragments error: nil];
    
    PIOItem *item = [PIOItem deserializeFromJSON: sampleResponse];
    
    XCTAssertTrue([item.iid isEqualToString: @"testiid2"]);
    
    XCTAssertTrue([item.itypes[0] isEqualToString: @"type1"]);
    XCTAssertTrue([item.itypes[1] isEqualToString: @"type2"]);
    
    XCTAssertTrue([item.startT timeIntervalSince1970] == 123456789);
    XCTAssertTrue([item.endT timeIntervalSince1970] == 1360647801400);

    XCTAssertTrue(item.profit == 9.87);
    XCTAssertTrue(item.price == 1.23);
    
    XCTAssertTrue(item.latitude == 12.34);
    XCTAssertTrue(item.longitude == 5.678);

    XCTAssertTrue([[item getCustomValueForKey: @"custom2" ] isEqualToString: @"2.34"]);
    XCTAssertTrue([[item getCustomValueForKey: @"custom1" ] isEqualToString: @"value1"]);
}

- (void) testPIOMessageDeserialize {
    NSString *filePath = [[NSBundle bundleForClass: [self class]] pathForResource: @"testmessage" ofType: @"json"];
    NSData* content = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary *sampleResponse = [NSJSONSerialization JSONObjectWithData: content options: NSJSONReadingAllowFragments error: nil];
    
    PIOMessage *message = [PIOMessage deserializeFromJSON: sampleResponse];
    
    XCTAssertTrue([message.message isEqualToString: @"User created."]);
    
}

- (void) testPIOUserDeserialize {
    NSString *filePath = [[NSBundle bundleForClass: [self class]] pathForResource: @"testuser" ofType: @"json"];
    NSData* content = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary *sampleResponse = [NSJSONSerialization JSONObjectWithData: content options: NSJSONReadingAllowFragments error: nil];
    
    PIOUser *user = [PIOUser deserializeFromJSON: sampleResponse];
    
    XCTAssertTrue([user.uid isEqualToString: @"testuid2"]);
    
    XCTAssertTrue(user.latitude == 12.34);
    XCTAssertTrue(user.longitude == 5.678);
    
    XCTAssertTrue([[user getCustomValueForKey: @"custom2" ] isEqualToString: @"2.34"]);
    XCTAssertTrue([[user getCustomValueForKey: @"custom1" ] isEqualToString: @"value1"]);
}


@end
