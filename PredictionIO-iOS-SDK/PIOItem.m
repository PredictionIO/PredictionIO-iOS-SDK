//
//  PIOItem.m
//  PredictionIO-iOS-SDK
//
//  Created by Yanbin Feng on 12/26/13.
//  Copyright (c) 2013 PredictionIO. All rights reserved.
//

#import "PIOItem.h"

#define kItemIDKey      @"pio_iid"
#define kITypesKey      @"pio_itypes"
#define kStartTKey      @"pio_startT"
#define kEndTKey        @"pio_endT"
#define kPriceKey       @"pio_price"
#define kProfitKey      @"pio_profit"
#define kLatLngKey      @"pio_latlng"
#define kInactiveKey    @"pio_inactive"


@interface PIOItem()

@property (strong, nonatomic) NSDictionary *customProperties;

@end

@implementation PIOItem

- (NSString *) getCustomValueForKey: (NSString *) customKey {
    return [self.customProperties objectForKey: customKey];
}

+ (PIOItem *) deserializeFromJSON: (NSDictionary *) jsonDictionary {
    PIOItem *item = [PIOItem new];
    
    NSMutableDictionary *custom = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [jsonDictionary allKeys]) {
        if ([key isEqualToString: kItemIDKey]) {
            item.iid = [jsonDictionary objectForKey: key];
        }
        
        else if ([key isEqualToString: kITypesKey]) {
            item.itypes = [jsonDictionary objectForKey: key];
        }
        
        else if ([key isEqualToString: kStartTKey]) {
            item.startT = [NSDate dateWithTimeIntervalSince1970: [[jsonDictionary objectForKey: key] doubleValue]];
        }
        
        else if ([key isEqualToString: kEndTKey]) {
            item.endT = [NSDate dateWithTimeIntervalSince1970: [[jsonDictionary objectForKey: key] doubleValue]];
        }
        
        else if ([key isEqualToString: kPriceKey]) {
            item.price = [[jsonDictionary objectForKey: key] doubleValue];
        }
        
        else if ([key isEqualToString: kProfitKey]) {
            item.profit = [[jsonDictionary objectForKey: key] doubleValue];
        }
        
        else if ([key isEqualToString: kLatLngKey]) {
            NSArray *latlngArray = [jsonDictionary objectForKey: key];
            
            if (latlngArray.count == 2) {
                item.latitude = [[latlngArray objectAtIndex: 0] doubleValue];
                item.longitude = [[latlngArray objectAtIndex: 1] doubleValue];
            }
        }
        
        else if ([key isEqualToString: kInactiveKey]) {
            item.inactive = [jsonDictionary objectForKey: key];
        }
        
        //otherwise a custom value
        else {
            [custom setObject: [jsonDictionary objectForKey: key] forKey: key];
        }
    }
    
    item.customProperties = custom;
    
    return item;
}

@end
