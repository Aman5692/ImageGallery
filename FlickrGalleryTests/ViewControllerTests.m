//
//  ViewControllerTests.m
//  FlickrGalleryTests
//
//  Created by Aman Agarwal on 03/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "GalleryViewManager.h"

@interface ViewControllerTests : XCTestCase

@end

@implementation ViewControllerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testCustomSetup {
    ViewController *vc = [[ViewController alloc] init];
    if([vc respondsToSelector:@selector(customSetup)]) {
        [vc performSelector:@selector(customSetup)];
        GalleryViewManager *manager = [vc valueForKey:@"manager"];
        XCTAssertNotNil(manager,@"GalleryViewManager not allocated");
        XCTAssertNotNil(manager.delegate,@"GalleryViewManager delegate not set");
    }
}

- (void)testStartSpinner {
    ViewController *vc = [[ViewController alloc] init];
    if([vc respondsToSelector:@selector(startSpinner)]) {
        [vc performSelector:@selector(startSpinner)];
        UIActivityIndicatorView *spinner = [vc valueForKey:@"spinner"];
        XCTAssertNotNil(spinner,@"UIActivityIndicatorView not allocated");
        XCTAssertTrue(spinner.isAnimating,@"UIActivityIndicatorView is not animating");
    }
}

- (void)testStopSpinner {
    ViewController *vc = [[ViewController alloc] init];
    if([vc respondsToSelector:@selector(stopSpinner)]) {
        [vc performSelector:@selector(stopSpinner)];
        UIActivityIndicatorView *spinner = [vc valueForKey:@"spinner"];
        XCTAssertNotNil(spinner,@"UIActivityIndicatorView not allocated");
        XCTAssertFalse(spinner.isAnimating,@"UIActivityIndicatorView is not animating");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
