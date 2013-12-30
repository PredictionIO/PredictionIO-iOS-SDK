//
//  PIOItemRecGetTopNRequest.m
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import "PIOItemRecGetTopNRequest.h"

@implementation PIOItemRecGetTopNRequest

- (id)initWithApiUrl:(NSString *)apiUrl apiFormat:(NSString *)apiFormat appkey:(NSString *)appkey engine:(NSString *)engine uid:(NSString *)uid n:(NSInteger)n
{
    self = [super init];
    if (self) {
        [self setApiUrl:apiUrl];
        [self setApiFormat:apiFormat];
        [self setAppkey:appkey];
        [self setEngine:engine];
        [self setUid:uid];
        [self setN:[NSNumber numberWithInteger:n]];
    }
    return self;
}

@end
