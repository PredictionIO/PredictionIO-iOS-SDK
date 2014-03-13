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

- (id)initWithAppKey:(NSString *)appkey
{
    return [self initWithAppKey:appkey apiURL:defaultApiUrl];
}

//Instantiate a PredictionIO RESTful API client.
- (id)initWithAppKey:(NSString *)appkey apiURL:(NSString *)apiURL
{
    self = [super init];
    if (self) {
        [self setAppkey:appkey];
        [self setApiUrl:apiURL];
        self.requestManager = [AFHTTPRequestOperationManager manager];
        self.requestManager = [self.requestManager initWithBaseURL:[NSURL URLWithString:[apiURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    return self;
}

//Close all connections associated with this client.
- (void)close
{
    [self.requestManager.operationQueue cancelAllOperations];
}

//Sends an asynchronous create item request to the API.
- (void)createItemWithRequest:(PIOCreateItemRequest *)createItemRequest
                      success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                      failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;
{
    [self.requestManager POST:[NSString stringWithFormat:@"/items.%@", apiFormat] parameters:[createItemRequest getRequestParams] success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        
        if (successBlock) {
            PIOMessage *message = [PIOMessage deserializeFromJSON: (NSDictionary *)responseJSON];
            successBlock(operation, message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation, error);
        }
    }];
}
- (void)createItemWithIID:(NSString *)iid itypes:(NSArray *)itypes
                  success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    PIOCreateItemRequest *createItemRequest = [[PIOCreateItemRequest alloc] initWithApiUrl:self.apiUrl apiFormat:apiFormat appkey:self.appkey iid:iid itypes:itypes];
    [self createItemWithRequest:createItemRequest success:successBlock failure:failureBlock];
}

//Sends an asynchronous delete item request to the API.
- (void)deleteItem:(NSString *)iid
           success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
           failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    [self.requestManager DELETE:[NSString stringWithFormat:@"/items/%@.%@", iid, apiFormat] parameters:@{@"pio_appkey": self.appkey} success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (successBlock) {
            PIOMessage *message = [PIOMessage deserializeFromJSON: (NSDictionary *)responseJSON];
            successBlock(operation, message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation, error);
        }
    }];
}

//Sends an asynchronous get item request to the API. Execute success block if request is successful; execute failure block otherwise.
- (void)getItem:(NSString *)iid
        success:(void (^)(AFHTTPRequestOperation *operation , PIOItem *item))successBlock
        failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock;
{
    [self.requestManager GET:[NSString stringWithFormat:@"/items/%@.%@", iid, apiFormat] parameters:@{@"pio_appkey": self.appkey} success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (successBlock) {
            PIOItem *item = [PIOItem deserializeFromJSON: (NSDictionary *)responseJSON];
            successBlock(operation, item);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation, error);
        }
    }];
}

//Sends an asynchronous create user request to the API.
- (void)createUserWithRequest:(PIOCreateUserRequest *)createUserRequest
                      success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                      failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    [self.requestManager POST:[NSString stringWithFormat:@"/users.%@", apiFormat] parameters:[createUserRequest getRequestParams] success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (successBlock) {
            PIOMessage *message = [PIOMessage deserializeFromJSON: (NSDictionary *)responseJSON];
            successBlock(operation, message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation, error);
        }
    }];
}

- (void)createUserWithUID:(NSString *)uid
                  success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    PIOCreateUserRequest *createUserRequest = [[PIOCreateUserRequest alloc] initWithApiUrl:self.apiUrl apiFormat:apiFormat appkey:self.appkey uid:uid];
    [self createUserWithRequest:createUserRequest success:successBlock failure:failureBlock];
}


//Sends an asynchronous delete user request to the API.
- (void)deleteUser:(NSString *)uid
           success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
           failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{

    [self.requestManager DELETE:[NSString stringWithFormat:@"/users/%@.%@", uid, apiFormat] parameters:@{@"pio_appkey": self.appkey} success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (successBlock) {
            PIOMessage *message = [PIOMessage deserializeFromJSON: (NSDictionary *)responseJSON];
            successBlock(operation, message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation, error);
        }
    }];
}

//Get a new CreateItemRequest object that can be used to add additional item attributes.
- (PIOCreateItemRequest *)newCreateItemRequestWithItemID:(NSString *)iid itypes:(NSArray *)itypes
{
    return [[PIOCreateItemRequest alloc] initWithApiUrl:self.apiUrl apiFormat:apiFormat appkey:self.appkey iid:iid itypes:itypes];
}

//Get a create user request builder that can be used to add additional user attributes.
- (PIOCreateUserRequest *)newCreateUserRequestWithUserID:(NSString *)uid
{
    return [[PIOCreateUserRequest alloc] initWithApiUrl:self.apiUrl apiFormat:apiFormat appkey:self.appkey uid:uid];
}

//Get a new get top-n recommendations request object that can be used to add additional request parameters.
- (PIOItemRecGetTopNRequest *)newItemRecGetTopNRequestWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes
{
    PIOItemRecGetTopNRequest *itemTopNRequest = [[PIOItemRecGetTopNRequest alloc] initWithApiUrl:self.apiUrl apiFormat:apiFormat appkey:self.appkey engine:engine uid:uid n:n];
    [itemTopNRequest setAttributes:attributes];
    return itemTopNRequest;
}

//Sends an asynchronous get recommendations request to the API.
- (void)getItemRecTopNWithRequest:(PIOItemRecGetTopNRequest *)itemTopNRequest
                               success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock

{
    /*
     RequestBuilder builder = new RequestBuilder("GET");
     builder.setUrl(this.apiUrl + "/engines/itemrec/" + this.engine + "/topn." + this.apiFormat);
     */
    [self.requestManager GET:[NSString stringWithFormat:@"/engines/itemrec/%@/topn.%@", itemTopNRequest.engine, apiFormat] parameters:[itemTopNRequest getRequestParams] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation, error);
        }
    }];
}
- (void)getItemRecTopNWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n
                              success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    PIOItemRecGetTopNRequest *itemTopNRequest = [self newItemRecGetTopNRequestWithEngine:engine uid:uid n:n attributes:nil];
    [self getItemRecTopNWithRequest:itemTopNRequest success:successBlock failure:failureBlock];
}

//Sends an asynchronous get recommendations request to the API.
- (void)getItemRecTopNWithAttributesWithEngine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n attributes:(NSArray *)attributes
                                       success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    PIOItemRecGetTopNRequest *itemTopNRequest = [self newItemRecGetTopNRequestWithEngine:engine uid:uid n:n attributes:attributes];
    [self getItemRecTopNWithRequest:itemTopNRequest success:successBlock failure:failureBlock];
}

//Get a new get top-n similar items request object that can be used to add additional request parameters.
- (PIOItemSimGetTopNRequest *)newItemSimGetTopNRequestWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes
{
    PIOItemSimGetTopNRequest *itemSimTopNRequest = [[PIOItemSimGetTopNRequest alloc] initWithApiUrl:self.apiUrl apiFormat:apiFormat appkey:self.appkey engine:engine iid:iid n:n];
    [itemSimTopNRequest setAttributes:attributes];
    return itemSimTopNRequest;
}

//Sends an asynchronous get similar items request to the API.
- (void)getItemSimTopNWithRequest:(PIOItemSimGetTopNRequest *)itemSimTopNRequest
                          success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                          failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    /*
     RequestBuilder builder = new RequestBuilder("GET");
     builder.setUrl(this.apiUrl + "/engines/itemsim/" + this.engine + "/topn." + this.apiFormat);
     */
    [self.requestManager GET:[NSString stringWithFormat:@"/engines/itemsim/%@/topn.%@", itemSimTopNRequest.engine, apiFormat] parameters:[itemSimTopNRequest getRequestParams] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation, error);
        }
    }];
}
- (void)getItemSimTopNWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n
                         success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                         failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    PIOItemSimGetTopNRequest *itemSimTopNRequest = [self newItemSimGetTopNRequestWithEngine:engine iid:iid n:n attributes:nil];
    [self getItemSimTopNWithRequest:itemSimTopNRequest success:successBlock failure:failureBlock];
}


//Sends an asynchronous get similar items request to the API.
- (void)getItemSimTopNWithAttributesWithEngine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n attributes:(NSArray *)attributes
                                       success:(void (^)(AFHTTPRequestOperation *operation , id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    PIOItemSimGetTopNRequest *itemSimTopNRequest = [self newItemSimGetTopNRequestWithEngine:engine iid:iid n:n attributes:attributes];
    [self getItemSimTopNWithRequest:itemSimTopNRequest success:successBlock failure:failureBlock];
}

//Get status of the API.
//TODO: is this still useful?
- (NSString *)getStatus
{
    return nil;
}

//Sends an asynchronous get user request to the API.
- (void)getUser:(NSString *)uid
             success:(void (^)(AFHTTPRequestOperation *operation , PIOUser *user))successBlock
             failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    //Request request = (new RequestBuilder("GET")).setUrl(this.apiUrl + "/users/" + uid + "." + apiFormat).addQueryParameter("pio_appkey", this.appkey).build();
    [self.requestManager GET:[NSString stringWithFormat:@"/users/%@.%@", uid, apiFormat] parameters:@{@"pio_appkey": self.appkey} success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (successBlock) {
            PIOUser *user = [PIOUser deserializeFromJSON: (NSDictionary *)responseJSON];
            successBlock(operation, user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation, error);
        }
    }];
}

//Get a new user-action-on-item request object that can be used to add additional request parameters.
- (PIOUserActionItemRequest *)newUserActionItemRequestWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid
{
    PIOUserActionItemRequest *userActionItemRequest = [[PIOUserActionItemRequest alloc] initWithApiUrl:self.apiUrl apiFormat:apiFormat appkey:self.appkey action:action uid:uid iid:iid];
    return userActionItemRequest;
}

//Identify the user ID.
- (void)identifyUserID:(NSString *)uid
{
    [self setUid:uid];
}

//Sends an asynchronous user-action-on-item request to the API.
- (void)userActionItemWithRequest:(PIOUserActionItemRequest *)userActionItemRequest
                          success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                          failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    
    [self.requestManager POST:[NSString stringWithFormat:@"/actions/u2i.%@", apiFormat] parameters:[userActionItemRequest getRequestParams] success:^(AFHTTPRequestOperation *operation, id responseJSON) {
        if (successBlock) {
            PIOMessage *message = [PIOMessage deserializeFromJSON: (NSDictionary *)responseJSON];
            successBlock(operation, message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation, error);
        }
    }];
}
- (void)userActionItemWithUID:(NSString *)uid action:(NSString *)action iid:(NSString *)iid
                      success:(void (^)(AFHTTPRequestOperation *operation , PIOMessage *responseMessage))successBlock
                      failure:(void (^)(AFHTTPRequestOperation *operation , NSError *error))failureBlock
{
    PIOUserActionItemRequest *userActionItemRequest = [self newUserActionItemRequestWithUID:uid action:action iid:iid];
    [self userActionItemWithRequest:userActionItemRequest success:successBlock failure:failureBlock];

}

@end
