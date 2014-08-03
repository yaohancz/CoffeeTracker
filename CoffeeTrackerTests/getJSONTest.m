///
//  getJSONTest.m
//  CoffeeTracker
//
//  Created by Yaohan Zais on 8/3/14.
//  Copyright (c) 2014 Yaohan Christono Zais. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "CoffeeShop.h"
#import "Location.h"
#import "Contact.h"
#import <RestKit/Testing.h>


@interface getJSONTest : XCTestCase

@end

@implementation getJSONTest

- (void)setUp
{
    [super setUp];
    NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"YCZ.CoffeeTracker"];
    [RKTestFixture setFixtureBundle:testTargetBundle];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//Setup object mapping
- (RKObjectMapping *)coffeeShopMapping
{
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
    return coffeeShopMapping;
}

//Test Request Operation
- (void)testRequestOperation
{
    RKResponseDescriptor* responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: [self coffeeShopMapping]
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/v2/venues/search"
                                                keyPath:@"response.venues"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    NSURL *URL = [NSURL URLWithString:@"https://api.foursquare.com/v2/venues/search?ll=37.8%2c144.9&categoryID=4bf58dd8d48988d1e0931735&radius=800&client_id=ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G&client_secret=YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL&v=20140730"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
    [requestOperation start];
    [requestOperation waitUntilFinished];
    XCTAssertTrue(requestOperation.HTTPRequestOperation.response.statusCode == 200, @"Expected 200 response");
}

//Test Mapping for Coffee Shop
- (void)testMappingOfCoffeeShopName
{
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"Fixtures.json"];
    RKMappingTest *test = [RKMappingTest testForMapping:[self coffeeShopMapping] sourceObject:parsedJSON destinationObject:nil];
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"name" destinationKeyPath:@"name" value:@"Yarraville Train Station"]];
    XCTAssertTrue([test evaluate], @"Coffee Shop Test");

}



@end

