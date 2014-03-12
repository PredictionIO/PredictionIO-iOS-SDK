//
//  PIOMessage.h
//  PredictionIO-iOS-SDK
//
//  Created by Alex Grinman on 3/9/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIOMessage : NSObject

@property (nonatomic, strong) NSString *message;

+ (PIOMessage *) deserializeFromJSON: (NSDictionary *) jsonDictionary;

@end
