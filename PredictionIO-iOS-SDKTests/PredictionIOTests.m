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

@interface PredictionIOTests : XCTestCase

@property (nonatomic, strong) PIOClient *client;
@property (nonatomic, strong) NSCondition *networkResponse;

@end

@implementation PredictionIOTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.client = [[PIOClient alloc] initWithAppKey:@"FA2ZhbMtKf1F3FE7dXpUQ4Y0gmthHMigZdZMy71ze1AFdNqjeSTCwmIVuGvcz795"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateItem
{
    /* - (void)createItemWithIID:(NSString *)iid itypes:(NSArray *)itypes
success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;
     */
}

- (void)testDeleteItem
{
//- (void)deleteItem:(NSString *)iid;
}

- (void)testGetItem
{
    __block int status = 0;
    [self.client getItem:@"1" success:^(AFHTTPRequestOperation *operation , id responseObject){
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
//- (void)createUserWithUID:(NSString *)uid;
}

- (void)testDeleteUser
{
//- (void)deleteUser:(NSString *)uid;
}

- (void)testNewCreateItemRequest
{
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
//- (NSArray *)getItemRecTopNWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n;
}

- (void)testGetItemRecTopNWithAttributes
{
//- (NSDictionary *)getItemRecTopNWithAttributesWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes;
}

- (void)testNewItemSimGetTopNRequest
{
//- (PIOItemSimGetTopNRequest *)newItemSimGetTopNRequestWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes;
}

- (void)testGetItemSimTopN
{
//- (NSArray *)getItemSimTopNWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n;
}

- (void)testGetItemSimTopNWithAttributes
{
//- (NSDictionary *)getItemSimTopNWithAttributesWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes;
}

- (void)testGetStatus
{
//- (NSString *)getStatus;
}

- (void)testGetUser
{
//- (PIOUser *)getUser:(NSString *)uid;
}

- (void)testNewUserActionItemRequest
{
//- (PIOUserActionItemRequest *)newUserActionItemRequestWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid;
}

- (void)testIdentifyUserID
{
//- (void)identifyUserID:(NSString *)uid;
}

- (void)testUserActionItem
{
//- (void)userActionItemWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid;
}

@end
