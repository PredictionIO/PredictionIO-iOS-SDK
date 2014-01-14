//
//  PIOCreateItemRequest.h
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOCreateItemRequest : NSObject

@property (strong, nonatomic) NSString *apiUrl;
@property (strong, nonatomic) NSString *apiFormat;
@property (strong, nonatomic) NSString *appkey;
@property (strong, nonatomic) NSString *iid;
@property (strong, nonatomic) NSArray *itypes;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSDate *startT;
@property (strong, nonatomic) NSDate *endT;
@property (strong, nonatomic) NSDictionary *attributes;

/**
 * Instantiate a request builder with mandatory arguments.
 * <p>
 * Do not use this directly. Please refer to "See Also".
 *
 * @param apiUrl the API URL
 * @param apiFormat the return format of the API
 * @param appkey the new app key to be used
 * @param iid the item ID
 * @param itypes item types
 *
 * @see Client#getCreateItemRequestBuilder
 */
- (id)initWithApiUrl:(NSString *)apiUrl apiFormat:(NSString *)apiFormat appkey:(NSString *)appkey iid:(NSString *)iid itypes:(NSArray *)itypes;

/**
 * Add optional custom item attributes argument to the request.
 * <p>
 * Notice that adding custom attributes with following names will be silently ignored as they collide with system attributes at the REST API:
 * <ul>
 * <li>appkey
 * <li>iid
 * <li>itypes
 * <li>latlng
 * <li>startT
 * <li>endT
 * </ul>
 *
 * @param name name of the custom item attribute
 * @param value value of the custom item attribute
 */

- (void)addAttributeWithName:(NSString *)name value:(NSString *)value;

- (NSDictionary *)getRequestParams;

///**
// * Add the "latitude" optional argument to the request.
// * <p>
// * Only certain data backend support geospatial indexing.
// * Please refer to the main documentation for more information.
// *
// * @param latitude latitude
// */
//public CreateItemRequestBuilder latitude(double latitude) {
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
//public CreateItemRequestBuilder longitude(double longitude) {
//    this.longitude = new Double(longitude);
//    return this;
//}
//
///**
// * Add the "startT" optional argument to the request.
// *
// * @param startT the time when this item becomes valid
// */
//public CreateItemRequestBuilder startT(DateTime startT) {
//    this.startT = startT;
//    return this;
//}
//
///**
// * Add the "endT" optional argument to the request.
// *
// * @param endT the time when this item becomes invalid
// */
//public CreateItemRequestBuilder endT(DateTime endT) {
//    this.endT = endT;
//    return this;
//}


///**
// * Build a request.
// * <p>
// * Do not use this directly. Please refer to "See Also".
// *
// * @see Client#createItem(CreateItemRequestBuilder)
// * @see Client#createItemAsFuture(CreateItemRequestBuilder)
// */
//public Request build() {
//    RequestBuilder builder = new RequestBuilder("POST");
//    builder.setUrl(this.apiUrl + "/items." + this.apiFormat);
//    
//    JsonObject requestJson = new JsonObject();
//    
//    requestJson.addProperty("pio_appkey", this.appkey);
//    requestJson.addProperty("pio_iid", this.iid);
//    requestJson.addProperty("pio_itypes", Utils.arrayToString(this.itypes));
//    if (this.latitude != null && this.longitude != null) {
//        requestJson.addProperty("pio_latlng", this.latitude.toString() + "," + this.longitude.toString());
//    }
//    if (this.startT != null) {
//        requestJson.addProperty("pio_startT", startT.toString());
//    }
//    if (this.endT != null) {
//        requestJson.addProperty("pio_endT", endT.toString());
//    }
//    for (Map.Entry<String, String> attribute : this.attributes.entrySet()) {
//        if (attribute.getValue() != null) {
//            requestJson.addProperty(attribute.getKey(), attribute.getValue());
//        }
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
