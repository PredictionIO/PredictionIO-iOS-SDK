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
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;

@end
