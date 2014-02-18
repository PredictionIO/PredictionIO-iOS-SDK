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

- (NSDictionary *)getRequestParams
{
    /*
     builder.addQueryParameter("pio_appkey", this.appkey);
     builder.addQueryParameter("pio_iid", this.iid);
     builder.addQueryParameter("pio_n", Integer.toString(this.n));
     if (this.itypes != null && this.itypes.length > 0) {
     builder.addQueryParameter("pio_itypes", Utils.arrayToString(this.itypes));
     }
     if (this.latitude != null && this.longitude != null) {
     builder.addQueryParameter("pio_latlng", this.latitude.toString() + "," + this.longitude.toString());
     }
     if (this.within != null) {
     builder.addQueryParameter("pio_within", this.within.toString());
     }
     if (this.unit != null) {
     builder.addQueryParameter("pio_unit", this.unit.toString());
     }
     if (this.attributes != null && this.attributes.length > 0) {
     builder.addQueryParameter("pio_attributes", Utils.arrayToString(this.attributes));
     }
    */
    NSMutableDictionary *requestParams = [[NSMutableDictionary alloc] init];
    [requestParams setObject:self.appkey forKey:@"pio_appkey"];
    [requestParams setObject:self.iid forKey:@"pio_iid"];
    [requestParams setObject:[NSString stringWithFormat:@"%@", self.n] forKey:@"pio_n"];
    if (self.itypes && [self.itypes count] > 0) {
        [requestParams setObject:[self.itypes componentsJoinedByString:@","] forKey:@"pio_itypes"];
    }
    if (self.latitude && self.longitude) {  //TODO: NSNumber to string need format checking
        [requestParams setObject:[NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude] forKey:@"pio_latlng"];
    }
    if (self.within) {   //TODO: NSNumber to string need format checking
        [requestParams setObject:[NSString stringWithFormat:@"%@", self.within] forKey:@"pio_within"];
    }
    if (self.unit) {
        [requestParams setObject:[NSString stringWithFormat:@"%@", self.unit] forKey:@"pio_unit"];
    }
    if (self.attributes && [self.attributes count] > 0) {
        [requestParams setObject:[self.attributes componentsJoinedByString:@","] forKey:@"pio_attributes"];
    }
    return requestParams;
}


@end
