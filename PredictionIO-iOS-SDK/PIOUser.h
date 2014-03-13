//
//  PIOUser.h
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOUser : NSObject

@property (strong, nonatomic) NSString *uid;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) BOOL inactive;

- (NSString *) getCustomValueForKey: (NSString *) customKey;

+ (PIOUser *) deserializeFromJSON: (NSDictionary *) jsonDictionary;
@end
