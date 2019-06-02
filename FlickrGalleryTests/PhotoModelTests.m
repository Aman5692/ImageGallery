//
//  PhotoModelTests.m
//  FlickrGalleryTests
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PhotoModel.h"

@interface PhotoModelTests : XCTestCase

@end

@implementation PhotoModelTests

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

- (void)testInitInPhotoModel {
    PhotoModel *model = [[PhotoModel alloc] init];
    XCTAssertNotNil(model,@"Default init not working");
    
    model = [[PhotoModel alloc] initWithDictionary:@{
                                                     @"id": @"47981487342",
                                                     @"owner": @"57971685@N02",
                                                     @"secret": @"07d9f3848d",
                                                     @"server": @"65535",
                                                     @"farm": @(66),
                                                     @"title": @"Dreaming kittens",
                                                     @"ispublic": @(1),
                                                     @"isfriend": @(0),
                                                     @"isfamily": @(0)
                                                     }];
    XCTAssertNotNil(model,@"Custom init not working");
}

- (void)testValidateObjectInPhotoModel {
    PhotoModel *model = [[PhotoModel alloc] initWithDictionary:@{
                                                                 @"id": @(47981487342),
                                                                 @"owner": @"57971685@N02",
                                                                 @"secret": @"07d9f3848d",
                                                                 @"server": @"65535",
                                                                 @"farm": @(66),
                                                                 @"title": @"Dreaming kittens",
                                                                 @"ispublic": @(1),
                                                                 @"isfriend": @(0),
                                                                 @"isfamily": @(0)
                                                                 }];
    if([model respondsToSelector:@selector(validateObject:)]) {
        BOOL result = [model performSelector:@selector(validateObject:) withObject:model];
        XCTAssertFalse(result,@"validate object not working correctly");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
