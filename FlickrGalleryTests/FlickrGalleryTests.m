//
//  FlickrGalleryTests.m
//  FlickrGalleryTests
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GalleryViewManager.h"

@interface FlickrGalleryTests : XCTestCase <GalleryManagerDelegate>

@property (nonatomic, strong) XCTestExpectation *expectation;
@property (nonatomic, strong) NSError *errorReceivedFromDelegate;
@property (nonatomic, strong) SearchObjectModel *modelReceivedFromDelegate;
@property (nonatomic) BOOL expectationFulfilled;

@end

@implementation FlickrGalleryTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.expectation = nil;
    self.errorReceivedFromDelegate = nil;
    self.modelReceivedFromDelegate = nil;
    self.expectationFulfilled = NO;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

#pragma mark - GalleryViewManager unit test cases

- (void)testInitForGalleryViewManager {
    GalleryViewManager *manager = [[GalleryViewManager alloc] init];
    NSCache *cache = [manager valueForKey:@"cache"];
    XCTAssertNotNil(manager,@"GalleryViewManager is not allocated");
    XCTAssertNotNil(cache,@"NSCache is not allocated in GalleryViewManager");
}

- (void)testFetchDataForKeywordInGalleryViewManager_ForEmptyString {
    GalleryViewManager *manager = [[GalleryViewManager alloc] init];
    manager.delegate = self;
    
    self.expectation = [self expectationWithDescription:@"Get callback from GalleryViewManager"];
    [manager fetchDataForKeyword:@"" withSearchModel:[[SearchObjectModel alloc] init] ];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error){
        if(error) {
            XCTAssert(false,@"Callback not received in time");
        } else if (self.errorReceivedFromDelegate.code != kInvalidSearchString) {
            XCTAssert(false,@"Invalid error code received");
        } else {
            XCTAssert(true,@"Correct error code");
        }
    }];
}

- (void)testFetchDataForKeywordInGalleryViewManager_ForInvalidArgument {
    GalleryViewManager *manager = [[GalleryViewManager alloc] init];
    manager.delegate = self;
    
    self.expectation = [self expectationWithDescription:@"Get callback from GalleryViewManager"];
    NSString *param = [NSNumber numberWithBool:NO];
    [manager fetchDataForKeyword:param withSearchModel:[[SearchObjectModel alloc] init] ];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error){
        if(error) {
            XCTAssert(false,@"Callback not received in time");
        } else if (self.errorReceivedFromDelegate.code != kInvalidSearchString) {
            XCTAssert(false,@"Invalid error code received");
        } else {
            XCTAssert(true,@"Correct error code");
        }
    }];
}

- (void)testFetchDataForKeywordInGalleryViewManager_ForValidSearch {
    GalleryViewManager *manager = [[GalleryViewManager alloc] init];
    manager.delegate = self;
    
    self.expectation = [self expectationWithDescription:@"Get callback from GalleryViewManager"];
    [manager fetchDataForKeyword:@"Plane" withSearchModel:[[SearchObjectModel alloc] init] ];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error){
        if(error) {
            XCTAssert(false,@"Callback not received in time");
        } else if (self.errorReceivedFromDelegate || !self.modelReceivedFromDelegate) {
            XCTAssert(false,@"Error occured while fetching data");
        } else {
            XCTAssert(true,@"Non null data received");
        }
    }];
}

- (void)testFetchDataForScrollInGalleryViewManager_ForMaxedOutModel {
    GalleryViewManager *manager = [[GalleryViewManager alloc] init];
    manager.delegate = self;
    
    self.expectation = [self expectationWithDescription:@"Get callback from GalleryViewManager"];
    SearchObjectModel *model = [[SearchObjectModel alloc] init];
    model.total = @"0";
    model.photosList = [NSArray new];
    model.page = [NSNumber numberWithInteger:1];
    model.pages = [NSNumber numberWithInteger:100];
    
    [manager fetchDataForScroll:model];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error){
        if(error) {
            XCTAssert(false,@"Callback not received in time");
        } else if (self.errorReceivedFromDelegate.code != kNoMoreDataAvailable) {
            XCTAssert(false,@"Error occured while fetching data");
        } else {
            XCTAssert(true,@"Correct error code received");
        }
    }];
}

- (void)testFetchDataForScrollInGalleryViewManager_ForFinalPage {
    GalleryViewManager *manager = [[GalleryViewManager alloc] init];
    manager.delegate = self;
    
    self.expectation = [self expectationWithDescription:@"Get callback from GalleryViewManager"];
    SearchObjectModel *model = [[SearchObjectModel alloc] init];
    model.total = @"100";
    model.photosList = [NSArray new];
    model.page = [NSNumber numberWithInteger:100];
    model.pages = [NSNumber numberWithInteger:100];
    
    [manager fetchDataForScroll:model];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error){
        if(error) {
            XCTAssert(false,@"Callback not received in time");
        } else if (self.errorReceivedFromDelegate.code != kNoMoreDataAvailable) {
            XCTAssert(false,@"Error occured while fetching data");
        } else {
            XCTAssert(true,@"Correct error code received");
        }
    }];
}

- (void)testFetchDataForScrollInGalleryViewManager_ValidRequest {
    GalleryViewManager *manager = [[GalleryViewManager alloc] init];
    manager.delegate = self;
    
    self.expectation = [self expectationWithDescription:@"Get callback from GalleryViewManager"];
    SearchObjectModel *model = [[SearchObjectModel alloc] init];
    model.total = @"100";
    model.photosList = [NSArray new];
    model.page = [NSNumber numberWithInteger:1];
    model.pages = [NSNumber numberWithInteger:100];
    model.keyword = @"Plane";
    
    [manager fetchDataForScroll:model];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error){
        if(error) {
            XCTAssert(false,@"Callback not received in time");
        } else if (self.errorReceivedFromDelegate || !self.modelReceivedFromDelegate) {
            XCTAssert(false,@"Error occured while fetching data");
        } else {
            XCTAssert(true,@"Model provided correctly");
        }
    }];
}

//- (void)testFetchImageForModelInGalleryViewManager {
//    GalleryViewManager *manager = [[GalleryViewManager alloc] init];
//    PhotoModel *model = [[PhotoModel alloc] initWithDictionary:@{
//                                                                 @"id": @"47981487342",
//                                                                 @"owner": @"57971685@N02",
//                                                                 @"secret": @"07d9f3848d",
//                                                                 @"server": @"65535",
//                                                                 @"farm": @(66),
//                                                                 @"title": @"Dreaming kittens",
//                                                                 @"ispublic": @(1),
//                                                                 @"isfriend": @(0),
//                                                                 @"isfamily": @(0)
//                                                                 }];
//    UIImage *image = [manager fetchImageForModel:model];
//    XCTAssertNotNil(image,@"nil image received");
//}

- (void)testGetDownloadStringInGalleryViewManager {
    GalleryViewManager *manager = [[GalleryViewManager alloc] init];
    PhotoModel *model = [[PhotoModel alloc] initWithDictionary:@{
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
    NSString *expectedString = @"http://farm66.static.flickr.com/65535/47981487342_07d9f3848d.jpg";
    if([manager respondsToSelector:@selector(getDownloadString:)]) {
        NSString *result = [manager performSelector:@selector(getDownloadString:) withObject:model];
        XCTAssertEqualObjects(result, expectedString,@"result string is not same as expected string");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - GalleryManagerDelegate

- (void)didUpdateDataModel:(SearchObjectModel *)model withError:(NSError *)error {
    self.errorReceivedFromDelegate = error;
    self.modelReceivedFromDelegate = model;
    if(!self.expectationFulfilled) {
        self.expectationFulfilled = YES;
        [self.expectation fulfill];
    }
}

@end
