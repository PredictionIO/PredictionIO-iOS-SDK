//
//  PIOCreateUserRequest.m
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import "PIOCreateUserRequest.h"

@implementation PIOCreateUserRequest

- (id)initWithApiUrl:(NSString *)apiUrl apiFormat:(NSString *)apiFormat appkey:(NSString *)appkey uid:(NSString *)uid
{
    self = [super init];
    if (self) {
        [self setApiUrl:apiUrl];
        [self setApiFormat:apiFormat];
        [self setAppkey:appkey];
        [self setUid:uid];
    }
    return self;
}

@end
