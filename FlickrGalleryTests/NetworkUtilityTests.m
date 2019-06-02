//
//  NetworkUtilityTests.m
//  FlickrGalleryTests
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetworkUtility.h"

@interface NetworkUtilityTests : XCTestCase

@property (nonatomic, strong) XCTestExpectation *expectation;
@property (nonatomic, strong) NSError *errorReceivedFromBlock;
@property (nonatomic, strong) NSDictionary *responseReceivedFromBlock;
@property (nonatomic, strong) NSData *dataReceivedFromBlock;

@end

@implementation NetworkUtilityTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.expectation = nil;
    self.errorReceivedFromBlock = nil;
    self.responseReceivedFromBlock = nil;
    self.dataReceivedFromBlock = nil;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testFetchDataForKeyword_EmptyKeyword {
    self.expectation = [self expectationWithDescription:@"Wait for network util completion block"];
    [NetworkUtility fetchDataForKeyword:@"" andPage:@"1" withCompletionBlock:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        self.errorReceivedFromBlock = error;
        self.responseReceivedFromBlock = response;
        [self.expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTAssert(false,@"block did not returned in time");
        } else if(self.errorReceivedFromBlock.code != kInvalidRequestParams) {
            XCTAssert(false,@"invalid error code received");
        } else {
            XCTAssert(true,@"correct error code received");
        }
    }];
}

- (void)testFetchDataForKeyword_InvalidParam {
    self.expectation = [self expectationWithDescription:@"Wait for network util completion block"];
    [NetworkUtility fetchDataForKeyword:[NSNumber numberWithBool:NO] andPage:@"1" withCompletionBlock:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        self.errorReceivedFromBlock = error;
        self.responseReceivedFromBlock = response;
        [self.expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTAssert(false,@"block did not returned in time");
        } else if(self.errorReceivedFromBlock.code != kInvalidRequestParams) {
            XCTAssert(false,@"invalid error code received");
        } else {
            XCTAssert(true,@"correct error code received");
        }
    }];
}

- (void)testFetchDataForKeyword_ValidRequest {
    self.expectation = [self expectationWithDescription:@"Wait for network util completion block"];
    [NetworkUtility fetchDataForKeyword:@"Plane" andPage:@"1" withCompletionBlock:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        self.errorReceivedFromBlock = error;
        self.responseReceivedFromBlock = response;
        [self.expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTAssert(false,@"block did not returned in time");
        } else if(self.errorReceivedFromBlock || !self.responseReceivedFromBlock) {
            XCTAssert(false,@"network error occured while fetching data");
        } else {
            XCTAssert(true,@"non null data received");
        }
    }];
}

- (void)testGetDownloadStringForKeyword {
    NSString *expected = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=Plane&page=1";
    if([NetworkUtility respondsToSelector:@selector(getDownloadStringForKeyword:andPage:)]) {
        NSString *result = [NetworkUtility performSelector:@selector(getDownloadStringForKeyword:andPage:) withObject:@"Plane" withObject:@"1"];
        XCTAssertEqualObjects(result, expected, @"result not same as expected");
    }
}

- (void)testFetchImageForUrl_InvalidUrl {
    self.expectation = [self expectationWithDescription:@"Wait for network util completion block"];
    [NetworkUtility fetchImageForUrl:@"" withCompletionBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        self.errorReceivedFromBlock = error;
        self.dataReceivedFromBlock = data;
        [self.expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTAssert(false,@"block did not returned in time");
        } else if(self.errorReceivedFromBlock.code != kNetworkErrorOccured) {
            XCTAssert(false,@"invalid error code received");
        } else {
            XCTAssert(true,@"correct error code received");
        }
    }];
}

- (void)testFetchImageForUrl_InvalidUrlString {
    self.expectation = [self expectationWithDescription:@"Wait for network util completion block"];
    [NetworkUtility fetchImageForUrl:@"http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg" withCompletionBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        self.errorReceivedFromBlock = error;
        self.dataReceivedFromBlock = data;
        [self.expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTAssert(false,@"block did not returned in time");
        } else if(self.errorReceivedFromBlock.code != kInvalidUrlString) {
            XCTAssert(false,@"invalid error code received");
        } else {
            XCTAssert(true,@"correct error code received");
        }
    }];
}

- (void)testFetchImageForUrl_ValidString {
    self.expectation = [self expectationWithDescription:@"Wait for network util completion block"];
    [NetworkUtility fetchImageForUrl:@"http://farm66.static.flickr.com/65535/47981487342_07d9f3848d.jpg" withCompletionBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        self.errorReceivedFromBlock = error;
        self.dataReceivedFromBlock = data;
        [self.expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTAssert(false,@"block did not returned in time");
        } else if(self.errorReceivedFromBlock || !self.dataReceivedFromBlock) {
            XCTAssert(false,@"invalid data received");
        } else {
            XCTAssert(true,@"correct data received");
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
