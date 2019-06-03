//
//  FlickrGalleryUITests.m
//  FlickrGalleryUITests
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FlickrGalleryUITests : XCTestCase

@end

@implementation FlickrGalleryUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSearchView {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app/*@START_MENU_TOKEN@*/.textFields[@"SearchField"]/*[[".textFields[@\"Enter text to search relevent photos\"]",".textFields[@\"SearchField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    XCUIElement *tKey = app/*@START_MENU_TOKEN@*/.keys[@"T"]/*[[".keyboards.keys[@\"T\"]",".keys[@\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [tKey tap];
    
    XCUIElement *rKey = app/*@START_MENU_TOKEN@*/.keys[@"r"]/*[[".keyboards.keys[@\"r\"]",".keys[@\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [rKey tap];
    
    XCUIElement *eKey = app/*@START_MENU_TOKEN@*/.keys[@"e"]/*[[".keyboards.keys[@\"e\"]",".keys[@\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [eKey tap];
    [eKey tap];
    
    [app/*@START_MENU_TOKEN@*/.buttons[@"Go"]/*[[".keyboards.buttons[@\"Go\"]",".buttons[@\"Go\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    [NSThread sleepForTimeInterval:10.0];
    XCUIElementQuery *collectionViewsQuery = app.collectionViews;
    int dataSourceCount = (int)[collectionViewsQuery childrenMatchingType:XCUIElementTypeCell].count;
    XCTAssertTrue(dataSourceCount > 0,@"response not received for querry 'SpiderMan'");
    
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
