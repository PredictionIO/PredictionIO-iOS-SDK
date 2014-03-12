//
//  PIOItem.h
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOItem : NSObject

@property (strong, nonatomic) NSString *iid;
@property (strong, nonatomic) NSArray *itypes;
@property (strong, nonatomic) NSDate *startT;
@property (strong, nonatomic) NSDate *endT;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) double price;
@property (assign, nonatomic) double profit;
@property (assign, nonatomic) BOOL  inactive;


- (NSString *) getCustomValueForKey: (NSString *) customKey;

+ (PIOItem *) deserializeFromJSON: (NSDictionary *) jsonDictionary;

@end
