//
//  SearchObjectModel.h
//  FlickrGallery
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchObjectModel : NSObject

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSNumber *pages;
@property (nonatomic, strong) NSArray <PhotoModel*> *photosList;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
