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

- (NSDictionary *)getRequestParams
{
    /*
     requestJson.addProperty("pio_appkey", this.appkey);
     requestJson.addProperty("pio_uid", this.uid);
     requestJson.addProperty("pio_iid", this.iid);
     if (this.latitude != null && this.longitude != null) {
     requestJson.addProperty("pio_latlng", this.latitude.toString() + "," + this.longitude.toString());
     }
     if (this.t != null) {
     requestJson.addProperty("pio_t", t.toString());
     }
     
     
     requestJson.addProperty("pio_action", this.action);
     if (RATE.equals(this.action)) {
     requestJson.addProperty("pio_rate", Integer.toString(this.rate));
     }
     */
    NSMutableDictionary *requestParams = [[NSMutableDictionary alloc] init];
    [requestParams setObject:self.appkey forKey:@"pio_appkey"];
    [requestParams setObject:self.uid forKey:@"pio_uid"];
    [requestParams setObject:self.iid forKey:@"pio_iid"];
    if (self.latitude && self.longitude) {  //TODO: NSNumber to string need format checking
        [requestParams setObject:[NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude] forKey:@"pio_latlng"];
    }
    if (self.t) {   //TODO: NSDate to string need format checking
        [requestParams setObject:[NSString stringWithFormat:@"%@", self.t] forKey:@"pio_t"];
    }
    [requestParams setObject:[NSString stringWithFormat:@"%@", self.action] forKey:@"pio_action"];
    if ([self.action isEqualToString:RATE]) {  //TODO: NSNumber to string need format checking
        [requestParams setObject:[NSString stringWithFormat:@"%@", self.rate] forKey:@"pio_rate"];
    }
    return requestParams;
}


@end
