//
//  DetailViewController.h
//  CoffeeTracker
//
//  Created by Yaohan Zais on 7/30/14.
//  Copyright (c) 2014 Yaohan Christono Zais. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "CoffeeShop.h"

@interface DetailViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *banner;
@property (strong, nonatomic) CoffeeShop* detailItem;
@property (nonatomic) CLLocationCoordinate2D coord;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)openMaps:(id)sender;

- (IBAction)callShop:(id)sender;

@end
