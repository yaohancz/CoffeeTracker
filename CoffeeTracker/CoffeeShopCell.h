//
//  CoffeeShopCell.h
//  CoffeeTracker
//
//  Created by Yaohan Zais on 7/30/14.
//  Copyright (c) 2014 Yaohan Christono Zais. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//This class is used as a custom table view cell (Display name, distance, and address)
@interface CoffeeShopCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *coffeeShopNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@end
