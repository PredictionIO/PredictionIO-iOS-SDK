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

- (NSDictionary *)getRequestParams
{
    NSMutableDictionary *requestParams = [[NSMutableDictionary alloc] init];
    /*
     requestJson.addProperty("pio_appkey", this.appkey);
     requestJson.addProperty("pio_uid", this.uid);
     if (this.latitude != null && this.longitude != null) {
     requestJson.addProperty("pio_latlng", this.latitude.toString() + "," + this.longitude.toString());
     }
     */
    [requestParams setObject:self.appkey forKey:@"pio_appkey"];
    [requestParams setObject:self.uid forKey:@"pio_uid"];
    
    if (self.latitude && self.longitude) {  //TODO: NSNumber to string need format checking
        [requestParams setObject:[NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude] forKey:@"pio_latlng"];
    }
    return requestParams;
}


@end
