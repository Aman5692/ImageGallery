//
//  SearchObjectModelTests.m
//  FlickrGalleryTests
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SearchObjectModel.h"

@interface SearchObjectModelTests : XCTestCase

@end

@implementation SearchObjectModelTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitForSearchObjectModel {
    SearchObjectModel *model = [[SearchObjectModel alloc] init];
    XCTAssertNotNil(model,@"Default init is not working");
    model = [[SearchObjectModel alloc] initWithDictionary:@{
                                                            @"page": @(1),
                                                            @"pages": @(1632),
                                                            @"perpage": @(100),
                                                            @"total": @"163112",
                                                            @"photo": @[
                                                                      @{
                                                                          @"id": @"47981767827",
                                                                          @"owner": @"162102327@N06",
                                                                          @"secret": @"6542fb46f6",
                                                                          @"server": @"65535",
                                                                          @"farm": @(66),
                                                                          @"title": @"George",
                                                                          @"ispublic": @(1),
                                                                          @"isfriend": @(0),
                                                                          @"isfamily": @(0)
                                                                      }]
                                                            }];
    XCTAssertNotNil(model,@"InitWithDictionary is not working");
    XCTAssertTrue(model.photosList.count == 1,@"Invalid photo list in model");
    XCTAssertTrue([model.total isEqualToString: @"163112"],@"Invalid total pics in model");
}

- (void)testValidateObjectInSearchObjectModel {
    SearchObjectModel *model = [[SearchObjectModel alloc] initWithDictionary:@{
                                                                               @"page": @(1),
                                                                               @"pages": @(1632),
                                                                               @"perpage": @(100),
                                                                               @"total": @(163112),
                                                                               @"photo": @[
                                                                                       @{
                                                                                           @"id": @"47981767827",
                                                                                           @"owner": @"162102327@N06",
                                                                                           @"secret": @"6542fb46f6",
                                                                                           @"server": @"65535",
                                                                                           @"farm": @(66),
                                                                                           @"title": @"George",
                                                                                           @"ispublic": @(1),
                                                                                           @"isfriend": @(0),
                                                                                           @"isfamily": @(0)
                                                                                           }]
                                                                               }];
    if([model respondsToSelector:@selector(validateObject:)]) {
        BOOL result = [model performSelector:@selector(validateObject:) withObject:model];
        XCTAssertFalse(result,@"validate object not working correctly");
    }
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
