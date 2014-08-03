//
//  CoffeeShop.h
//  CoffeeTracker
//
//  Created by Yaohan Zais on 7/30/14.
//  Copyright (c) 2014 Yaohan Christono Zais. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Contact.h"
@class Location;
@class Contact;
//Model for coffee shop
@interface CoffeeShop : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Contact *contact;
@end
