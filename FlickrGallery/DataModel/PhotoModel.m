//
//  PhotoModel.m
//  FlickrGallery
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if([dictionary isKindOfClass:[NSDictionary class]]) {
        if(self = [super init]) {
            self.identifier = [dictionary valueForKey:@"id"];
            self.farm = [dictionary valueForKey:@"farm"];
            self.secret = [dictionary valueForKey:@"secret"];
            self.server = [dictionary valueForKey:@"server"];
            self.title = [dictionary valueForKey:@"title"];
        }
    }
    if([self validateObject:self]) return self;
    else return nil;
}

- (BOOL)validateObject:(PhotoModel *)model {
    if(![model.identifier isKindOfClass:[NSString class]]) return false;
    else if(![model.farm isKindOfClass:[NSNumber class]]) return false;
    else if(![model.secret isKindOfClass:[NSString class]]) return false;
    else if(![model.server isKindOfClass:[NSString class]]) return false;
    else if(![model.title isKindOfClass:[NSString class]]) return false;
    else return true;
}

@end
