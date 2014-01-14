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
    self.networkResponse = [[NSCondition alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetItemRequest
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

@end
