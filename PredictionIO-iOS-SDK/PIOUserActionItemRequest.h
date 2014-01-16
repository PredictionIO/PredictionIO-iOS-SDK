//
//  PIOUserActionItemRequest.h
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOUserActionItemRequest : NSObject

// Mandatory fields
@property (strong, nonatomic) NSString *apiUrl;
@property (strong, nonatomic) NSString *apiFormat;
@property (strong, nonatomic) NSString *appkey;
@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *iid;
@property (strong, nonatomic) NSDate *t;

// Optional fields
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *rate;  // mandatory for u2i rate action



/**
 * Instantiate a request builder with mandatory arguments.
 * <p>
 * Do not use this directly. Please refer to "See Also".
 *
 * @param apiUrl the API URL
 * @param apiFormat the return format of the API
 * @param appkey the new app key to be used
 * @param action the action code
 * @param uid the user ID
 * @param iid the item ID
 *
 * @see Client#getUserActionItemRequestBuilder
 */
- (id)initWithApiUrl:(NSString *)apiUrl apiFormat:(NSString *)apiFormat appkey:(NSString *)appkey action:(NSString *)action uid:(NSString *)uid iid:(NSString *)iid;

- (NSDictionary *)getRequestParams;


///**
// * Add the "latitude" optional argument to the request.
// * <p>
// * Only certain data backend support geospatial indexing.
// * Please refer to the main documentation for more information.
// *
// * @param latitude latitude
// */
//public UserActionItemRequestBuilder latitude(double latitude) {
//    this.latitude = new Double(latitude);
//    return this;
//}
//
///**
// * Add the "longitude" optional argument to the request.
// * <p>
// * Only certain data backend support geospatial indexing.
// * Please refer to the main documentation for more information.
// *
// * @param longitude longitude
// */
//public UserActionItemRequestBuilder longitude(double longitude) {
//    this.longitude = new Double(longitude);
//    return this;
//}
//
///**
// * Add the "rate" argument (mandatory for user-rate-item actions) to the request.
// *
// * @param rate user's rating on item
// */
//public UserActionItemRequestBuilder rate(int rate) {
//    this.rate = rate;
//    return this;
//}
//
///**
// * Add the "t" optional argument to the request.
// *
// * @param t time of action
// */
//public UserActionItemRequestBuilder t(DateTime t) {
//    this.t = t;
//    return this;
//}
//
///**
// * Build a request.
// * <p>
// * Do not use this directly. Please refer to "See Also".
// *
// * @see Client#userActionItem(UserActionItemRequestBuilder)
// */
//public Request build() {
//    RequestBuilder builder = new RequestBuilder("POST");
//    
//    JsonObject requestJson = new JsonObject();
//    
//    requestJson.addProperty("pio_appkey", this.appkey);
//    requestJson.addProperty("pio_uid", this.uid);
//    requestJson.addProperty("pio_iid", this.iid);
//    if (this.latitude != null && this.longitude != null) {
//        requestJson.addProperty("pio_latlng", this.latitude.toString() + "," + this.longitude.toString());
//    }
//    if (this.t != null) {
//        requestJson.addProperty("pio_t", t.toString());
//    }
//    
//    String actionUrl = "/actions/u2i.";
//    requestJson.addProperty("pio_action", this.action);
//    if (RATE.equals(this.action)) {
//        requestJson.addProperty("pio_rate", Integer.toString(this.rate));
//    }
//    
//    builder.setUrl(this.apiUrl + actionUrl + this.apiFormat);
//    
//    String requestJsonString = requestJson.toString();
//    
//    builder.setBody(requestJsonString);
//    builder.setHeader("Content-Type","application/json");
//    builder.setHeader("Content-Length", ""+requestJsonString.length());
//    
//    return builder.build();
//}

@end
