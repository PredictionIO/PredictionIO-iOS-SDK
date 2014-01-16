//
//  PIOCreateUserRequest.h
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOCreateUserRequest : NSObject

@property (strong, nonatomic) NSString *apiUrl;
@property (strong, nonatomic) NSString *apiFormat;
@property (strong, nonatomic) NSString *appkey;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;


/**
 * Instantiate a request builder with mandatory arguments.
 * <p>
 * Do not use this directly. Please refer to "See Also".
 *
 * @param apiUrl the API URL
 * @param apiFormat the return format of the API
 * @param appkey the new app key to be used
 * @param uid the user ID
 *
 * @see Client#getCreateUserRequestBuilder
 */
- (id)initWithApiUrl:(NSString *)apiUrl apiFormat:(NSString *)apiFormat appkey:(NSString *)appkey uid:(NSString *)uid;

- (NSDictionary *)getRequestParams;


///**
// * Add the "latitude" optional argument to the request.
// * <p>
// * Only certain data backend support geospatial indexing.
// * Please refer to the main documentation for more information.
// *
// * @param latitude latitude
// */
//public CreateUserRequestBuilder latitude(double latitude) {
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
//public CreateUserRequestBuilder longitude(double longitude) {
//    this.longitude = new Double(longitude);
//    return this;
//}
//
///**
// * Build a request.
// * <p>
// * Do not use this directly. Please refer to "See Also".
// *
// * @see Client#createUser(CreateUserRequestBuilder)
// * @see Client#createUserAsFuture(CreateUserRequestBuilder)
// */
//public Request build() {
//    RequestBuilder builder = new RequestBuilder("POST");
//    builder.setUrl(this.apiUrl + "/users." + this.apiFormat);
//    
//    JsonObject requestJson = new JsonObject();
//    
//    requestJson.addProperty("pio_appkey", this.appkey);
//    requestJson.addProperty("pio_uid", this.uid);
//    if (this.latitude != null && this.longitude != null) {
//        requestJson.addProperty("pio_latlng", this.latitude.toString() + "," + this.longitude.toString());
//    }
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
