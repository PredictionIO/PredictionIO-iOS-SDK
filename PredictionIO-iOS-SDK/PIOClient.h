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
#import "PIOMessage.h"
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
                      success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                      failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;
- (void)createItemWithIID:(NSString *)iid itypes:(NSArray *)itypes
                  success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Sends an asynchronous delete item request to the API.
- (void)deleteItem:(NSString *)iid
           success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
           failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Sends an asynchronous get item request to the API. Execute success block if request is successful; execute failure block otherwise.
//Note: sucesss/failure blocks are called on the main thread after the request returns.
- (void)getItem:(NSString *)iid
        success:(void (^)(AFHTTPRequestOperation *operation , PIOItem *item))successBlock
        failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Sends an asynchronous create user request to the API.
- (void)createUserWithRequest:(PIOCreateUserRequest *)createUserRequest
                      success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                      failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;
- (void)createUserWithUID:(NSString *)uid
                  success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;


//Sends an asynchronous delete user request to the API.
- (void)deleteUser:(NSString *)uid
           success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
           failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Get a new CreateItemRequest object that can be used to add additional item attributes.
- (PIOCreateItemRequest *)newCreateItemRequestWithItemID:(NSString *)iid itypes:(NSArray *)itypes;

//Get a create user request builder that can be used to add additional user attributes.
- (PIOCreateUserRequest *)newCreateUserRequestWithUserID:(NSString *)uid;

//Get a new get top-n recommendations request object that can be used to add additional request parameters.
- (PIOItemRecGetTopNRequest *)newItemRecGetTopNRequestWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes;

//Sends an asynchronous get recommendations request to the API.
- (void)getItemRecTopNWithRequest:(PIOItemRecGetTopNRequest *)itemTopNRequest
                               success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;
- (void)getItemRecTopNWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n
                         success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                         failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;


//Sends an asynchronous get recommendations request to the API.
- (void)getItemRecTopNWithAttributesWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes
                                       success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Get a new get top-n similar items request object that can be used to add additional request parameters.
- (PIOItemSimGetTopNRequest *)newItemSimGetTopNRequestWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes;

//Sends an asynchronous get similar items request to the API.
- (void)getItemSimTopNWithRequest:(PIOItemSimGetTopNRequest *)itemSimTopNRequest
                          success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                          failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;
- (void)getItemSimTopNWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n
                              success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Sends an asynchronous get similar items request to the API.
- (void)getItemSimTopNWithAttributesWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes
                                       success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Get status of the API.
- (NSString *)getStatus;

//Sends an asynchronous get user request to the API.
- (void)getUser:(NSString *)uid
             success:(void (^)(AFHTTPRequestOperation *operation , PIOUser *user))successBlock
             failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

//Get a new user-action-on-item request object that can be used to add additional request parameters.
- (PIOUserActionItemRequest *)newUserActionItemRequestWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid;

//Identify the user ID.
- (void)identifyUserID:(NSString *)uid;

//Sends an asynchronous user-action-on-item request to the API.
- (void)userActionItemWithRequest:(PIOUserActionItemRequest *)userActionItemRequest
                          success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                          failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;
- (void)userActionItemWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid
                      success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                      failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;

@end
