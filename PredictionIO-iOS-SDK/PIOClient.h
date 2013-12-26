//
//  PIOClient.h
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIOItem.h"
#import "PIOUser.h"
#import "PIOCreateItemRequest.h"
#import "PIOCreateUserRequest.h"
#import "PIOItemRecGetTopNRequest.h"
#import "PIOItemSimGetTopNRequest.h"
#import "PIOUserActionItemRequest.h"

@interface PIOClient : NSObject

//Note: all requests are async by default (built on top of AFNetworking).
//TODO: add sync requests later

//Instantiate a PredictionIO RESTful API client using default values for API URL and thread limit.
- (id)initWithAppKey:(NSString *)appkey;

//Instantiate a PredictionIO RESTful API client using default values for API URL.
- (id)initWithAppKey:(NSString *)appkey apiURL:(NSString *)apiURL;

//Instantiate a PredictionIO RESTful API client.
- (id)initWithAppKey:(NSString *)appkey apiURL:(NSString *)apiURL threadLimit:(NSInteger)threadLimit;

//Close all connections associated with this client.
- (void)close;

//Sends an asynchronous create item request to the API.
- (void)createItem:(PIOCreateItemRequest *)createItemRequest;

//Sends an asynchronous delete item request to the API.
- (void)deleteItem:(NSString *)iid;

//Sends an asynchronous get item request to the API.
- (PIOItem *)getItem:(NSString *)iid;

//Sends an asynchronous create user request to the API.
- (void)createUser:(PIOCreateUserRequest *)createUserRequest;

//Sends an asynchronous delete user request to the API.
- (void)deleteUser:(NSString *)uid;

//Get a new CreateItemRequest object that can be used to add additional item attributes.
- (PIOCreateItemRequest *)newCreateItemRequestWithItemID:(NSString *)iid itypes:(NSArray *)itypes;

//Get a create user request builder that can be used to add additional user attributes.
- (PIOCreateUserRequest *)newCreateUserRequestWithUserID:(NSString *)uid;

//Get a new get top-n recommendations request object that can be used to add additional request parameters.
- (PIOItemRecGetTopNRequest *)newItemRecGetTopNRequestWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes;

//Sends an asynchronous get recommendations request to the API.
- (NSArray *)getItemRecTopN:(PIOItemRecGetTopNRequest *)itemTopNRequest;

//Sends an asynchronous get recommendations request to the API.
- (NSDictionary *)getItemRecTopNWithAttributes:(PIOItemRecGetTopNRequest *)itemTopNRequest;

//Get a new get top-n similar items request object that can be used to add additional request parameters.
- (PIOItemSimGetTopNRequest *)newItemSimGetTopNRequestWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes;

//Sends an asynchronous get similar items request to the API.
- (NSArray *)getItemSimTopN:(PIOItemSimGetTopNRequest *)itemSimTopNRequest;

//Sends an asynchronous get similar items request to the API.
- (NSDictionary *)getItemSimTopNWithAttributes:(PIOItemSimGetTopNRequest *)itemSimTopNRequest;

//Get status of the API.
- (NSString *)getStatus;

//Sends an asynchronous get user request to the API.
- (PIOUser *)getUser:(NSString *)uid;

//Get a new user-action-on-item request object that can be used to add additional request parameters.
- (PIOUserActionItemRequest *)newUserActionItemRequestWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid;

//Identify the user ID.
- (void)identifyUserID:(NSString *)uid;

//Set the API URL of this client.
- (void)setApiUrl:(NSString *)apiUrl;

//Set the app key of this client.
- (void)setAppkey:(NSString *)appkey;

//Sends an asynchronous user-action-on-item request to the API.
- (void)userActionItem:(PIOUserActionItemRequest *)userActionItemRequest;

@end
