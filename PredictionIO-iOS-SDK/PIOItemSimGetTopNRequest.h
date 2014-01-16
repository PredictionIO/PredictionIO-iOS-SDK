//
//  PIOItemSimGetTopNRequest.h
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOItemSimGetTopNRequest : NSObject

@property (strong, nonatomic) NSString *apiUrl;
@property (strong, nonatomic) NSString *apiFormat;
@property (strong, nonatomic) NSString *appkey;
@property (strong, nonatomic) NSString *engine;
@property (strong, nonatomic) NSString *iid;
@property (strong, nonatomic) NSNumber *n;
@property (strong, nonatomic) NSArray *itypes;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *within;
@property (strong, nonatomic) NSString *unit;
@property (strong, nonatomic) NSArray *attributes;

/**
 * Instantiate a request builder with mandatory arguments.
 * <p>
 * Do not use this directly. Please refer to "See Also".
 *
 * @param apiUrl the API URL
 * @param apiFormat the return format of the API
 * @param appkey the new app key to be used
 * @param engine engine name
 * @param iid IID
 * @param n number of recommendations to return
 *
 * @see Client#getItemSimGetTopNRequestBuilder
 */
- (id)initWithApiUrl:(NSString *)apiUrl apiFormat:(NSString *)apiFormat appkey:(NSString *)appkey engine:(NSString *)engine iid:(NSString *)iid n:(NSInteger)n;

- (NSDictionary *)getRequestParams;

///**
// * Add the "itypes" optional argument to the request.
// *
// * @param itypes array of item types
// */
//public ItemSimGetTopNRequestBuilder itypes(String[] itypes) {
//    this.itypes = itypes;
//    return this;
//}
//
///**
// * Add the "latitude" optional argument to the request.
// * <p>
// * Only certain data backend support geospatial indexing.
// * Please refer to the main documentation for more information.
// *
// * @param latitude latitude
// */
//public ItemSimGetTopNRequestBuilder latitude(Double latitude) {
//    this.latitude = latitude;
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
//public ItemSimGetTopNRequestBuilder longitude(Double longitude) {
//    this.longitude = longitude;
//    return this;
//}
//
///**
// * Add the "within" optional argument to the request.
// * <p>
// * Only certain data backend support geospatial indexing.
// * Please refer to the main documentation for more information.
// *
// * @param within radius of search from the specified location
// */
//public ItemSimGetTopNRequestBuilder within(Double within) {
//    this.within = within;
//    return this;
//}
//
///**
// * Add the "unit" optional argument to the request.
// * <p>
// * Only certain data backend support geospatial indexing.
// * Please refer to the main documentation for more information.
// *
// * @param unit unit of "within" (radius)
// */
//public ItemSimGetTopNRequestBuilder unit(String unit) {
//    this.unit = unit;
//    return this;
//}
//
///**
// * Add the "attributes" optional argument to the request.
// *
// * @param attributes array of item attribute names to be returned with the result
// */
//public ItemSimGetTopNRequestBuilder attributes(String[] attributes) {
//    this.attributes = attributes;
//    return this;
//}
//
///**
// * Build a request.
// * <p>
// * Do not use this directly. Please refer to "See Also".
// *
// * @see Client#getItemSimTopN(ItemSimGetTopNRequestBuilder)
// * @see Client#getItemSimTopNAsFuture(ItemSimGetTopNRequestBuilder)
// */
//public Request build() {
//    RequestBuilder builder = new RequestBuilder("GET");
//    builder.setUrl(this.apiUrl + "/engines/itemsim/" + this.engine + "/topn." + this.apiFormat);
//    builder.addQueryParameter("pio_appkey", this.appkey);
//    builder.addQueryParameter("pio_iid", this.iid);
//    builder.addQueryParameter("pio_n", Integer.toString(this.n));
//    if (this.itypes != null && this.itypes.length > 0) {
//        builder.addQueryParameter("pio_itypes", Utils.arrayToString(this.itypes));
//    }
//    if (this.latitude != null && this.longitude != null) {
//        builder.addQueryParameter("pio_latlng", this.latitude.toString() + "," + this.longitude.toString());
//    }
//    if (this.within != null) {
//        builder.addQueryParameter("pio_within", this.within.toString());
//    }
//    if (this.unit != null) {
//        builder.addQueryParameter("pio_unit", this.unit.toString());
//    }
//    if (this.attributes != null && this.attributes.length > 0) {
//        builder.addQueryParameter("pio_attributes", Utils.arrayToString(this.attributes));
//    }
//    return builder.build();
//}

@end
