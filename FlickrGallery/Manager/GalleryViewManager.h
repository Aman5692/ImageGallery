//
//  GalleryViewManager.h
//  FlickrGallery
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SearchObjectModel.h"

@protocol GalleryManagerDelegate <NSObject>

- (void)didUpdateDataModel:(SearchObjectModel *)model withError:(NSError *)error;

@end

typedef NS_ENUM(NSInteger, GalleryManagerErrorCodes) {
    kInvalidSearchString = 1,
    kInvalidResponse,
    kNoMoreDataAvailable
};

NS_ASSUME_NONNULL_BEGIN

@interface GalleryViewManager : NSObject

@property (nonatomic, weak) id<GalleryManagerDelegate> delegate;

- (void)fetchDataForKeyword:(NSString *)keyWord withSearchModel:(SearchObjectModel *)model;
- (void)fetchDataForScroll:(SearchObjectModel *)model;
- (UIImage *)getImageForModel:(PhotoModel *)photoModel;

@end

NS_ASSUME_NONNULL_END
