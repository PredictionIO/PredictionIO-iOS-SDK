//
//  PIOCreateItemRequest.m
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import "PIOCreateItemRequest.h"

@implementation PIOCreateItemRequest

- (id)initWithApiUrl:(NSString *)apiUrl apiFormat:(NSString *)apiFormat appkey:(NSString *)appkey iid:(NSString *)iid itypes:(NSArray *)itypes
{
    self = [super init];
    if (self) {
        [self setApiUrl:apiUrl];
        [self setApiFormat:apiFormat];
        [self setAppkey:appkey];
        [self setIid:iid];
        [self setItypes:itypes];
        [self setAttributes:[[NSDictionary alloc] init]];
    }
    return self;
}


- (void)addAttributeWithName:(NSString *)name value:(NSString *)value
{
    if (![name hasPrefix:@"pio_"]) {
        [self.attributes setValue:value forKey:name];
    }
}


@end
