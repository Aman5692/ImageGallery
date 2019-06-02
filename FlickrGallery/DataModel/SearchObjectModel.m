//
//  SearchObjectModel.m
//  FlickrGallery
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import "SearchObjectModel.h"

@implementation SearchObjectModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if([dictionary isKindOfClass:[NSDictionary class]]) {
        if(self = [super init]) {
            self.page = [dictionary valueForKey:@"page"];
            self.total = [dictionary valueForKey:@"total"];
            self.pages = [dictionary valueForKey:@"pages"];
            self.photosList = [NSArray new];
        }
    }
    NSArray *photos = [dictionary valueForKey:@"photo"];
    NSMutableArray *responseList = [NSMutableArray new];
    for(NSDictionary *dict in photos) {
        PhotoModel *model = [[PhotoModel alloc] initWithDictionary:dict];
        if(model) {
            [responseList addObject:model];
        }
    }
    self.photosList = [responseList copy];
    if([self validateObject:self]) return self;
    else return nil;
}

- (BOOL)validateObject:(SearchObjectModel *)model {
    if(![model.page isKindOfClass:[NSNumber class]]) return false;
    else if(![model.total isKindOfClass:[NSString class]]) return false;
    else if(![model.pages isKindOfClass:[NSNumber class]]) return false;
    else if(![model.photosList isKindOfClass:[NSArray class]]) return false;
    else return true;
}

@end
