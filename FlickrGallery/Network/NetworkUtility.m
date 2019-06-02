//
//  NetworkUtility.m
//  FlickrGallery
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import "NetworkUtility.h"

@implementation NetworkUtility

+ (void)fetchImageForUrl:(NSString *)urlString withCompletionBlock:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completionBlock {
    NSURL *url = [NSURL URLWithString:urlString];
    if(!url) {
        NSError *error = [NSError errorWithDomain:@"NetworkUtilityError" code:kInvalidUrlString userInfo:nil];
        completionBlock(nil,error);
    } else {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:url];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              
              if(error) {
                  NSError *error = [NSError errorWithDomain:@"NetworkUtilityError" code:kNetworkErrorOccured userInfo:nil];
                  completionBlock(nil,error);
              } else if (data == nil) {
                  NSError *error = [NSError errorWithDomain:@"NetworkUtilityError" code:kInvalidData userInfo:nil];
                  completionBlock(nil,error);
              } else {
                  completionBlock(data,nil);
              }
              
          }] resume];
    }
}

+ (void)fetchDataForKeyword:(NSString *)keyword andPage:(NSString *)page withCompletionBlock:(void (^)(NSDictionary * _Nullable response, NSError * _Nullable error))completionBlock {
    if(![keyword isKindOfClass:[NSString class]] || keyword.length <= 0 || ![page isKindOfClass:[NSString class]] || page.length <= 0){
        NSError *error = [NSError errorWithDomain:@"NetworkUtilityError" code:kInvalidRequestParams userInfo:nil];
        completionBlock(nil,error);
    } else {
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:[NetworkUtility getDownloadStringForKeyword:keyword andPage:page]]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
          ^(NSData * _Nullable data,
            NSURLResponse * _Nullable response,
            NSError * _Nullable error) {
              
              if(error) {
                  NSError *error = [NSError errorWithDomain:@"NetworkUtilityError" code:kNetworkErrorOccured userInfo:nil];
                  completionBlock(nil,error);
              } else if (data == nil) {
                  NSError *error = [NSError errorWithDomain:@"NetworkUtilityError" code:kInvalidData userInfo:nil];
                  completionBlock(nil,error);
              } else {
                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                  completionBlock(json,nil);
              }
              
          }] resume];
    }
}

+ (NSString *)getDownloadStringForKeyword:(NSString *)keyword andPage:(NSString *)page {
    NSMutableString *macroString = [[NSMutableString alloc] initWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text={keyword}&page={page}"];
    macroString = [[macroString stringByReplacingOccurrencesOfString:@"{keyword}" withString:keyword] mutableCopy];
    macroString = [[macroString stringByReplacingOccurrencesOfString:@"{page}" withString:page] mutableCopy];
    return macroString;
}

@end
