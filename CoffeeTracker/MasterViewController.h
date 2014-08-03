//
//  MasterViewController.h
//  CoffeeTracker
//
//  Created by Yaohan Zais on 7/30/14.
//  Copyright (c) 2014 Yaohan Christono Zais. All rights reserved.
//
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "CoffeeShop.h"
#import "Location.h"
#import "Contact.h"
#import "DetailViewController.h"
#import "CoffeeShopCell.h"

@interface MasterViewController : UITableViewController<CLLocationManagerDelegate>
@property (nonatomic, strong) NSArray* coffeeshop;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
