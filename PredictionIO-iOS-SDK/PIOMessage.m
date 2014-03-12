//
//  PIOMessage.m
//  PredictionIO-iOS-SDK
//
//  Created by Alex Grinman on 3/9/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import "PIOMessage.h"

#define kMessageKey @"message"

@implementation PIOMessage

+ (PIOMessage *) deserializeFromJSON: (NSDictionary *) jsonDictionary {
    PIOMessage *pioMessage = [PIOMessage new];
    pioMessage.message = [jsonDictionary objectForKey: kMessageKey];
    
    return pioMessage;
}

@end
