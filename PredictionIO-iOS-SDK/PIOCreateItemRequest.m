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
        [self setAttributes:[[NSMutableDictionary alloc] init]];
    }
    return self;
}


- (void)addAttributeWithName:(NSString *)name value:(NSString *)value
{
    if (![name hasPrefix:@"pio_"]) {
        [self.attributes setValue:value forKey:name];
    }
}

- (NSDictionary *)getRequestParams
{
    NSMutableDictionary *requestParams = [[NSMutableDictionary alloc] init];
    [requestParams setObject:self.appkey forKey:@"pio_appkey"];
    [requestParams setObject:self.iid forKey:@"pio_iid"];
    if (self.itypes && [self.itypes count] > 0) {
        [requestParams setObject: [self.itypes componentsJoinedByString: @","] forKey:@"pio_itypes"];
    }
    if (self.latitude && self.longitude) {  //TODO: NSNumber to string need format checking
        [requestParams setObject: [NSString stringWithFormat: @"%@,%@", self.latitude, self.longitude] forKey:@"pio_latlng"];
    }
    if (self.startT) {   //TODO: NSDate to string need format checking
        [requestParams setObject: [NSNumber numberWithDouble: [self.startT timeIntervalSince1970]] forKey: @"pio_startT"];
    }
    if (self.endT) {    //TODO: NSDate to string need format checking
        [requestParams setObject: [NSNumber numberWithDouble: [self.endT timeIntervalSince1970]] forKey: @"pio_endT"];
    }
    if (self.attributes && [self.attributes count] > 0) {
        for (NSString *key in [self.attributes allKeys]) {
            if ([self.attributes objectForKey:key]) {
                [requestParams setObject:[self.attributes objectForKey:key] forKey:key];
            }
        }
    }
    return requestParams;
}

@end
