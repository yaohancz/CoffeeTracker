//
//  MasterViewController.m
//  CoffeeTracker
//
//  Created by Yaohan Zais on 7/30/14.
//  Copyright (c) 2014 Yaohan Christono Zais. All rights reserved.
//



#import "MasterViewController.h"


#define kBASEURL @"https://api.foursquare.com"
#define kCLIENTID @"ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G"
#define kCLIENTSECRET @"YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL"


@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setupRestKit
{
    // initialize AFNetworking
    NSURL *baseURL = [NSURL URLWithString:kBASEURL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *coffeeShopMapping = [RKObjectMapping mappingForClass:[CoffeeShop class]];
    [coffeeShopMapping addAttributeMappingsFromArray:@[@"name"]];
    
    
    // define location object mapping
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
    
    // define contact object mapping
    RKObjectMapping *contactMapping = [RKObjectMapping mappingForClass:[Contact class]];
    [contactMapping addAttributeMappingsFromArray:@[@"phone", @"formattedPhone"]];
    
    // define relationship mapping
    [coffeeShopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];
    
    [coffeeShopMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contact" toKeyPath:@"contact" withMapping:contactMapping]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:coffeeShopMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/v2/venues/search"
                                                keyPath:@"response.venues"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

-(void)sortByDistance {
    // sort array based on distance
    NSSortDescriptor *sortDistance= [NSSortDescriptor sortDescriptorWithKey:@"location.distance" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDistance];
    _coffeeshop = [_coffeeshop sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)loadShops:(NSString *)latitudeLongitude
{
    // setup parameters for the api calls
    NSDictionary *queryParams = @{@"ll" : latitudeLongitude,
                                  @"client_id" : kCLIENTID,
                                  @"client_secret" : kCLIENTSECRET,
                                  @"categoryID" : @"4bf58dd8d48988d1e0931735",
                                  @"radius" :@"800",
                                  @"v" : @"20140730"};
    
    // get Coffee Shop List from foursquare API call
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _coffeeshop = mappingResult.array;
                                                  [self sortByDistance];
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error getting data: %@", error);
                                              }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRestKit];
    
    // initialize location manager (get current location)
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.pausesLocationUpdatesAutomatically = YES;

    //start updating location
    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _coffeeshop.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // initialize custom table view cell
    CoffeeShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoffeeShopCell" forIndexPath:indexPath];
    
    // get coffee shop object from the array of coffee shop based on the index row
    CoffeeShop *coffeeshop = _coffeeshop[indexPath.row];
    cell.backgroundColor =[UIColor colorWithRed:242.0f/255.0f green:224.0f/255.0f blue:181.0f/255.0f alpha:1.0f];
    
    // set the value of the label
    cell.coffeeShopNameLabel.text = coffeeshop.name;
    cell.distanceLabel.text = [NSString stringWithFormat: @"%@ m", coffeeshop.location.distance];
    if ([coffeeshop.location.address length]!=0)
        cell.addressLabel.text = [NSString stringWithFormat: @"%@", coffeeshop.location.address];
    else cell.addressLabel.text = @"";
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMapView"]) {
        
        // Get destination view
        DetailViewController *vc = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Pass the information to your destination view
        [vc setDetailItem:_coffeeshop[indexPath.row]];
    }
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // Failed to obtain device's location
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Success obtaining location
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    //Convert and join string for coordinate (1 digit behind decimal)
    NSString *latitudeStr=[NSString stringWithFormat:@"%.01f,",currentLocation.coordinate.latitude];
    NSString *longitudeStr=[NSString stringWithFormat:@"%.01f",currentLocation.coordinate.longitude];
    NSMutableString*latitudeLongitudeString =[[NSMutableString alloc]initWithString:latitudeStr];
    [latitudeLongitudeString appendString:longitudeStr];
    
    NSString* ll = latitudeLongitudeString;
    if (currentLocation != nil) {
        [self loadShops:ll];
    }
}

@end
