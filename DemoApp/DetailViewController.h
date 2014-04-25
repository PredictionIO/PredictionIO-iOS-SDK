//
//  DetailViewController.h
//  DemoApp
//
//  Created by Alex Grinman on 4/7/14.
//  Copyright (c) 2014 PredictionIO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodEntry.h"
#import "PIOClient.h"

@interface DetailViewController : UIViewController <NSXMLParserDelegate>

@property (strong, nonatomic) FoodEntry *foodEntry;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) PIOClient *client;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
