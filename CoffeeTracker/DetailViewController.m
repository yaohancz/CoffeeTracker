//
//  DetailViewController.m
//  CoffeeTracker
//
//  Created by Yaohan Zais on 7/30/14.
//  Copyright (c) 2014 Yaohan Christono Zais. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(CoffeeShop*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        _banner.title = _detailItem.name;
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        
        // create coordinates from the latitude and longitude values
        _coord.latitude = _detailItem.location.lat.doubleValue;
        _coord.longitude = _detailItem.location.lng.doubleValue;
        
        // setup region zoom level
        double miles = 5.0;
        double scalingFactor = ABS( (cos(2 * M_PI * _coord.latitude / 360.0) ));
        MKCoordinateSpan span;
        span.latitudeDelta = miles/69.0;
        span.longitudeDelta = miles/(scalingFactor * 69.0);
        MKCoordinateRegion region;
        region.span = span;
        region.center = _coord;
        [_mapView setRegion:region animated:YES];
        
        // place a single pin
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate: _coord];
        [annotation setTitle:_detailItem.name]; //You can set the subtitle too
        [self.mapView addAnnotation:annotation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //change background colour
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:224.0f/255.0f blue:181.0f/255.0f alpha:1.0f];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MKMapView Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (IBAction)openMaps:(id)sender {
    //open maps in iOS maps application
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:_coord
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:_detailItem.name];
        // Pass the map item to the Maps app
        [mapItem openInMapsWithLaunchOptions:nil];
    }
}

- (IBAction)callShop:(id)sender {
    // redirect user to use phone app to call the coffee shop
    NSString *phNo = _detailItem.contact.formattedPhone;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        NSLog(@"Call is not available");
    }
}
@end
