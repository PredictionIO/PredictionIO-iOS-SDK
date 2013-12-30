//
//  PIOClient.m
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import "PIOClient.h"

@implementation PIOClient

// API base URL constant string
NSString *const defaultApiUrl = @"http://localhost:8000";
NSString *const apiFormat = @"json";
int const defaultThreadLimit = 100;

// HTTP status code
int const HTTP_OK = 200;
int const HTTP_CREATED = 201;
int const HTTP_BAD_REQUEST = 400;
int const HTTP_FORBIDDEN = 403;
int const HTTP_NOT_FOUND = 404;


//Instantiate a PredictionIO RESTful API client.
- (id)initWithAppKey:(NSString *)appkey apiURL:(NSString *)apiURL
{
    self = [super init];
    if (self) {
        [self setAppkey:appkey];
        [self setApiUrl:apiURL];
    }
    return self;
}

//Close all connections associated with this client.
- (void)close
{
    //TODO
    return;
}

//Sends an asynchronous create item request to the API.
- (void)createItemWithRequest:(PIOCreateItemRequest *)createItemRequest
{
    return;
}
- (void)createItemWithIID:(NSString *)iid itypes:(NSArray *)itypes
{
    return;
}

//Sends an asynchronous delete item request to the API.
- (void)deleteItem:(NSString *)iid
{
    return;
}

//Sends an asynchronous get item request to the API.
- (PIOItem *)getItem:(NSString *)iid
{
    return nil;
}

//Sends an asynchronous create user request to the API.
- (void)createUserWithRequest:(PIOCreateUserRequest *)createUserRequest
{
    return;
}
- (void)createUserWithUID:(NSString *)uid
{
    return;
}


//Sends an asynchronous delete user request to the API.
- (void)deleteUser:(NSString *)uid
{
    return;
}

//Get a new CreateItemRequest object that can be used to add additional item attributes.
- (PIOCreateItemRequest *)newCreateItemRequestWithItemID:(NSString *)iid itypes:(NSArray *)itypes
{
    return nil;
}

//Get a create user request builder that can be used to add additional user attributes.
- (PIOCreateUserRequest *)newCreateUserRequestWithUserID:(NSString *)uid
{
    return nil;
}

//Get a new get top-n recommendations request object that can be used to add additional request parameters.
- (PIOItemRecGetTopNRequest *)newItemRecGetTopNRequestWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes
{
    return nil;
}

//Sends an asynchronous get recommendations request to the API.
- (NSArray *)getItemRecTopNWithRequest:(PIOItemRecGetTopNRequest *)itemTopNRequest
{
    return nil;
}
- (NSArray *)getItemRecTopNWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n
{
    return nil;
}

//Sends an asynchronous get recommendations request to the API.
- (NSDictionary *)getItemRecTopNWithAttributesWithRequest:(PIOItemRecGetTopNRequest *)itemTopNRequest
{
    return nil;
}
- (NSDictionary *)getItemRecTopNWithAttributesWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes
{
    return nil;
}

//Get a new get top-n similar items request object that can be used to add additional request parameters.
- (PIOItemSimGetTopNRequest *)newItemSimGetTopNRequestWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes
{
    return nil;
}

//Sends an asynchronous get similar items request to the API.
- (NSArray *)getItemSimTopNWithRequest:(PIOItemSimGetTopNRequest *)itemSimTopNRequest
{
    return nil;
}
- (NSArray *)getItemSimTopNWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n
{
    return nil;
}


//Sends an asynchronous get similar items request to the API.
- (NSDictionary *)getItemSimTopNWithAttributesWithRequest:(PIOItemSimGetTopNRequest *)itemSimTopNRequest
{
    return nil;
}
- (NSDictionary *)getItemSimTopNWithAttributesWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes
{
    return nil;
}

//Get status of the API.
- (NSString *)getStatus
{
    return nil;
}

//Sends an asynchronous get user request to the API.
- (PIOUser *)getUser:(NSString *)uid
{
    return nil;
}

//Get a new user-action-on-item request object that can be used to add additional request parameters.
- (PIOUserActionItemRequest *)newUserActionItemRequestWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid
{
    return nil;
}

//Identify the user ID.
- (void)identifyUserID:(NSString *)uid
{
    [self setUid:uid];
}

//Sends an asynchronous user-action-on-item request to the API.
- (void)userActionItemWithRequest:(PIOUserActionItemRequest *)userActionItemRequest
{
    return;
}
- (void)userActionItemWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid
{
    return;
}

@end
