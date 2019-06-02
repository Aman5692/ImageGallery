//
//  NetworkUtility.h
//  FlickrGallery
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//Error code
typedef NS_ENUM(NSInteger, NetworkUtilityErrorCodes) {
    kInvalidRequestParams = 1,
    kInvalidUrlString,
    kInvalidData,
    kNetworkErrorOccured
};

@interface NetworkUtility : NSObject

/*
 * Api to get network response for given params
 * A completion block with response dictionary and error is invoked at the completion of network operation
 * @param : keyword - search non empty string, page - page number for request
 */
+ (void)fetchDataForKeyword:(NSString *)keyword andPage:(NSString *)page withCompletionBlock:(void (^)(NSDictionary * _Nullable response, NSError * _Nullable error))completionBlock;

/*
 * Api to get network response for given url
 * A completion block with response data and error is invoked at the completion of network operation
 * @param : urlString - string valid for a NSUrl object
 */
+ (void)fetchImageForUrl:(NSString *)urlString withCompletionBlock:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
