//
//  PIOUserActionItemRequest.m
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import "PIOUserActionItemRequest.h"

@implementation PIOUserActionItemRequest

NSString *const RATE = @"rate";  // Action name for a user-rate-item action
NSString *const LIKE = @"like";  // Action name for a user-like-item action
NSString *const DISLIKE = @"dislike";  //Action name for a user-dislike-item action
NSString *const VIEW = @"view";  //Action name for a user-view-item action
NSString *const CONVERSION = @"conversion";  //Action name for a user-conversion-item action

- (id)initWithApiUrl:(NSString *)apiUrl apiFormat:(NSString *)apiFormat appkey:(NSString *)appkey action:(NSString *)action uid:(NSString *)uid iid:(NSString *)iid
{
    self = [super init];
    if (self) {
        [self setApiUrl:apiUrl];
        [self setApiFormat:apiFormat];
        [self setAppkey:appkey];
        [self setAction:action];
        [self setUid:uid];
        [self setIid:iid];
    }
    return self;
}

@end
