//
//  NetworkUtility.h
//  FlickrGallery
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NetworkUtilityErrorCodes) {
    kInvalidRequestParams = 1,
    kInvalidUrlString,
    kInvalidData,
    kNetworkErrorOccured
};

@interface NetworkUtility : NSObject

+ (void)fetchDataForKeyword:(NSString *)keyword andPage:(NSString *)page withCompletionBlock:(void (^)(NSDictionary * _Nullable response, NSError * _Nullable error))completionBlock;

+ (void)fetchImageForUrl:(NSString *)urlString withCompletionBlock:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
