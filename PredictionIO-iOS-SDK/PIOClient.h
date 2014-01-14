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
#import "AFHTTPRequestOperationManager.h"

@interface PIOClient : NSObject

@property (strong, nonatomic) NSString *apiUrl;
@property (strong, nonatomic) NSString *appkey;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;


//Note: all requests are async by default (built on top of AFNetworking).
//TODO: add sync requests later, and other unimplemented methods.

//Instantiate a PredictionIO RESTful API client using default values for API URL.
- (id)initWithAppKey:(NSString *)appkey;

//Instantiate a PredictionIO RESTful API client.
- (id)initWithAppKey:(NSString *)appkey apiURL:(NSString *)apiURL;

//Close all connections associated with this client.
- (void)close;

//Sends an asynchronous create item request to the API.
- (void)createItemWithRequest:(PIOCreateItemRequest *)createItemRequest
                      success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                      failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;
- (void)createItemWithIID:(NSString *)iid itypes:(NSArray *)itypes
                  success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Sends an asynchronous delete item request to the API.
- (void)deleteItem:(NSString *)iid;

//Sends an asynchronous get item request to the API. Execute success block if request is successful; execute failure block otherwise.
//Note: sucesss/failure blocks are called on the main thread after the request returns.
- (void)getItem:(NSString *)iid
        success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
        failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Sends an asynchronous create user request to the API.
- (void)createUserWithRequest:(PIOCreateUserRequest *)createUserRequest;
- (void)createUserWithUID:(NSString *)uid;

//Sends an asynchronous delete user request to the API.
- (void)deleteUser:(NSString *)uid;

//Get a new CreateItemRequest object that can be used to add additional item attributes.
- (PIOCreateItemRequest *)newCreateItemRequestWithItemID:(NSString *)iid itypes:(NSArray *)itypes;

//Get a create user request builder that can be used to add additional user attributes.
- (PIOCreateUserRequest *)newCreateUserRequestWithUserID:(NSString *)uid;

//Get a new get top-n recommendations request object that can be used to add additional request parameters.
- (PIOItemRecGetTopNRequest *)newItemRecGetTopNRequestWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes;

//Sends an asynchronous get recommendations request to the API.
- (NSArray *)getItemRecTopNWithRequest:(PIOItemRecGetTopNRequest *)itemTopNRequest;
- (NSArray *)getItemRecTopNWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n;

//Sends an asynchronous get recommendations request to the API.
- (NSDictionary *)getItemRecTopNWithAttributesWithRequest:(PIOItemRecGetTopNRequest *)itemTopNRequest;
- (NSDictionary *)getItemRecTopNWithAttributesWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes;

//Get a new get top-n similar items request object that can be used to add additional request parameters.
- (PIOItemSimGetTopNRequest *)newItemSimGetTopNRequestWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes;

//Sends an asynchronous get similar items request to the API.
- (NSArray *)getItemSimTopNWithRequest:(PIOItemSimGetTopNRequest *)itemSimTopNRequest;
- (NSArray *)getItemSimTopNWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n;

//Sends an asynchronous get similar items request to the API.
- (NSDictionary *)getItemSimTopNWithAttributesWithRequest:(PIOItemSimGetTopNRequest *)itemSimTopNRequest;
- (NSDictionary *)getItemSimTopNWithAttributesWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes;

//Get status of the API.
- (NSString *)getStatus;

//Sends an asynchronous get user request to the API.
- (PIOUser *)getUser:(NSString *)uid;

//Get a new user-action-on-item request object that can be used to add additional request parameters.
- (PIOUserActionItemRequest *)newUserActionItemRequestWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid;

//Identify the user ID.
- (void)identifyUserID:(NSString *)uid;

//Sends an asynchronous user-action-on-item request to the API.
- (void)userActionItemWithRequest:(PIOUserActionItemRequest *)userActionItemRequest;
- (void)userActionItemWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid;

@end
