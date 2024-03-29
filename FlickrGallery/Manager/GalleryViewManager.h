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

/*
 * Delegate callback to provide updated model and error code
 */
- (void)didUpdateDataModel:(SearchObjectModel *)model withError:(NSError *)error;

@end

//Error code
typedef NS_ENUM(NSInteger, GalleryManagerErrorCodes) {
    kInvalidSearchString = 1,
    kInvalidResponse,
    kNoMoreDataAvailable
};

NS_ASSUME_NONNULL_BEGIN

@interface GalleryViewManager : NSObject

@property (nonatomic, weak) id<GalleryManagerDelegate> delegate;

/*
 * Api to fetch data for non empty string keyword
 * @param: keyword - search string, model - existing data model
 */
- (void)fetchDataForKeyword:(NSString *)keyWord withSearchModel:(SearchObjectModel *)model;

/*
 * Api to fetch data for existing model
 * @param: model - existing data model
 */
- (void)fetchDataForScroll:(SearchObjectModel *)model;

/*
 * Api to update image for photoModel in given imageView
 * If image is not present in cache, default image is given to imageView &
 * asyncronously image is fetched and updated on imageView
 */
- (void)updateImageForModel:(PhotoModel *)photoModel onImageView:(UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
