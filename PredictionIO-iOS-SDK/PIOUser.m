//
//  PIOUser.m
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import "PIOUser.h"

#define kUIDKey         @"pio_uid"
#define kLatLngKey      @"pio_latlng"
#define kInactiveKey    @"pio_inactive"

@interface PIOUser()

@property (strong, nonatomic) NSDictionary *customProperties;

@end
@implementation PIOUser

- (NSString *) getCustomValueForKey: (NSString *) customKey {
    return [self.customProperties objectForKey: customKey];
}
    
+ (PIOUser *) deserializeFromJSON: (NSDictionary *) jsonDictionary {
    PIOUser *user = [PIOUser new];
    
    NSMutableDictionary *custom = [[NSMutableDictionary alloc] init];

    for (NSString *key in [jsonDictionary allKeys]) {
        if ([key isEqualToString: kUIDKey]) {
            user.uid = [jsonDictionary objectForKey: key];
        }
        
        else if ([key isEqualToString: kLatLngKey]) {
            NSArray *latlngArray = [jsonDictionary objectForKey: key];
            
            if (latlngArray.count == 2) {
                user.latitude = [[latlngArray objectAtIndex: 0] doubleValue];
                user.longitude = [[latlngArray objectAtIndex: 1] doubleValue];
            }
        }
        
        else if ([key isEqualToString: kInactiveKey]) {
            user.inactive = [jsonDictionary objectForKey: key];
        }
        
        //otherwise a custom value
        else {
            [custom setObject: [jsonDictionary objectForKey: key] forKey: key];
        }
    }
    
    user.customProperties = custom;
    
    return user;

}

@end
