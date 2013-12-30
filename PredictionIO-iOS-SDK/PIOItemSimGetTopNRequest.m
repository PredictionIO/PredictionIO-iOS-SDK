//
//  PIOItemSimGetTopNRequest.m
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import "PIOItemSimGetTopNRequest.h"

@implementation PIOItemSimGetTopNRequest

- (id)initWithApiUrl:(NSString *)apiUrl apiFormat:(NSString *)apiFormat appkey:(NSString *)appkey engine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n
{
    self = [super init];
    if (self) {
        [self setApiUrl:apiUrl];
        [self setApiFormat:apiFormat];
        [self setAppkey:appkey];
        [self setEngine:engine];
        [self setIid:iid];
        [self setN:[NSNumber numberWithInteger:n]];
    }
    return self;
}

@end
