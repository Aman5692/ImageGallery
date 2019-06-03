//
//  GalleryViewManager.m
//  FlickrGallery
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import "GalleryViewManager.h"
#import "NetworkUtility.h"

@interface GalleryViewManager()

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic) BOOL networkRequestInProgress;
@property (nonatomic, strong) NSCache *imageViewCache;
@end

@implementation GalleryViewManager

- (instancetype)init {
    if(self = [super init]) {
        self.cache = [[NSCache alloc] init];
        [self.cache setEvictsObjectsWithDiscardedContent:NO];
        
        self.imageViewCache = [[NSCache alloc] init];
        [self.imageViewCache setEvictsObjectsWithDiscardedContent:NO];
    }
    return self;
}

- (void)fetchDataForKeyword:(NSString *)keyWord withSearchModel:(SearchObjectModel *)model {
    if(![keyWord isKindOfClass:[NSString class]] || keyWord.length <= 0){
        NSError *error = [NSError errorWithDomain:@"GalleryManagerError" code:kInvalidSearchString userInfo:nil];
        [self giveCallbackWithErrorCode:error andModel:model];
    } else if([keyWord isEqualToString:model.keyword]){
        [self giveCallbackWithErrorCode:nil andModel:model];
    } else {
        [self.cache removeAllObjects];
        [self makeNetworkRequestForKeyword:keyWord andPage:@"1" andSearchModel:nil];
    }
}

- (void)fetchDataForScroll:(SearchObjectModel *)model {
    if(model.photosList.count >= [model.total integerValue] || [model.page integerValue] >= [model.pages integerValue]) {
        NSError *error = [NSError errorWithDomain:@"GalleryManagerError" code:kNoMoreDataAvailable userInfo:nil];
        [self giveCallbackWithErrorCode:error andModel:model];
    } else {
        [self makeNetworkRequestForKeyword:model.keyword andPage:[NSString stringWithFormat:@"%d",[model.page intValue]+1] andSearchModel:model];
    }
}

- (void)fetchImageForModel:(PhotoModel *)photoModel {
    //get image from cache or network
    NSString *downloadUrl = [self getDownloadString:photoModel];
    UIImage *image = [self.cache objectForKey:downloadUrl];
    
    // If image does not exist in cache, fetch from network and save in cache
    if(!image) {
        [NetworkUtility fetchImageForUrl:downloadUrl withCompletionBlock:^(NSData * _Nullable data, NSError * _Nullable error){
            if(!error){
                UIImage *image = [[UIImage alloc] initWithData:data];
                if(image) {
                    [self.cache setObject:image forKey:downloadUrl];
                }
            }
        }];
    }
    return;
}

- (void)updateImageForModel:(PhotoModel *)photoModel onImageView:(UIImageView *)imageView {
    
    NSString *downloadUrl = [self getDownloadString:photoModel];
    UIImage *image = [self.cache objectForKey:downloadUrl];
    if(!image) {
        image = [UIImage imageNamed:@"defaultImage"];
        
        //save given imageView in cache, as asked image is not present in cache currently
        [self.imageViewCache setObject:imageView forKey:downloadUrl];
        [NetworkUtility fetchImageForUrl:downloadUrl withCompletionBlock:^(NSData * _Nullable data, NSError * _Nullable error){
            if(!error){
                UIImage *image = [[UIImage alloc] initWithData:data];
                if(image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                          //extract corresponding imageview
                         //add fetched image
                        //remove imageView from cache
                        UIImageView *view = [self.imageViewCache objectForKey:downloadUrl];
                        [view setImage:image];
                        [self.imageViewCache removeObjectForKey:downloadUrl];
                        
                        //save image to cache for future reference
                        [self.cache setObject:image forKey:downloadUrl];
                    });
                    
                }
            }
        }];
    }
    //As image was present in cache, update imageView
    if([NSThread currentThread].isMainThread) {
        [imageView setImage:image];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
    }
    return;
}

#pragma mark - prefetch

- (void)prefetchImageFromStart:(int)start toPosition:(int)end forModel:(SearchObjectModel *)model andGiveCallbackAfter:(int)prefetchCount {
    __block int imageReceived = 0;
    __block BOOL callbackGiven = false;
    for(int i = start;i <= end;i++) {
        if(model.photosList.count > i) {
            NSString *downloadUrl = [self getDownloadString:[model.photosList objectAtIndex:i]];
            UIImage *image = [self.cache objectForKey:downloadUrl];
            if(!image) {
                [NetworkUtility fetchImageForUrl:downloadUrl withCompletionBlock:^(NSData * _Nullable data, NSError * _Nullable error){
                    imageReceived++;
                    if(!error){
                        UIImage *image = [[UIImage alloc] initWithData:data];
                        if(image) {
                            [self.cache setObject:image forKey:downloadUrl];
                        }
                    }
                    if(!callbackGiven && imageReceived >= prefetchCount) {//If prefetch count is reached give a callback
                        //update callbackGiven so refresh callback is given only once
                        callbackGiven = true;
                        [self giveCallbackWithErrorCode:nil andModel:model];
                    }
                }];
            } else {
                imageReceived++;
            }
        }
    }
    if(!callbackGiven && imageReceived >= prefetchCount) {//If prefetch count is reached give a callback
        //update callbackGiven so refresh callback is given only once
        callbackGiven = true;
        [self giveCallbackWithErrorCode:nil andModel:model];
    }
}

#pragma mark - helping methods

- (void)giveCallbackWithErrorCode:(NSError *)error andModel:(SearchObjectModel *)model {
    self.networkRequestInProgress = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(didUpdateDataModel:withError:)]) {
        [self.delegate didUpdateDataModel:model withError:error];
    }
}

- (NSString *)getDownloadString:(PhotoModel *)model {
    NSMutableString * macroString = [[NSMutableString alloc] initWithString:@"http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg"];
    macroString = [[macroString stringByReplacingOccurrencesOfString:@"{farm}" withString:[NSString stringWithFormat:@"%ld",(long)[model.farm integerValue]]] mutableCopy];
    macroString = [[macroString stringByReplacingOccurrencesOfString:@"{server}" withString:model.server] mutableCopy];
    macroString = [[macroString stringByReplacingOccurrencesOfString:@"{id}" withString:[NSString stringWithFormat:@"%ld",(long)[model.identifier integerValue]]] mutableCopy];
    macroString = [[macroString stringByReplacingOccurrencesOfString:@"{secret}" withString:model.secret] mutableCopy];
    return macroString;
}

- (void)makeNetworkRequestForKeyword:(NSString *)keyWord andPage:(NSString *)page andSearchModel:(SearchObjectModel *)model {
    if(!self.networkRequestInProgress) {
        self.networkRequestInProgress = YES;
        [NetworkUtility fetchDataForKeyword:keyWord andPage:page withCompletionBlock:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
            if(error) {
                NSError *error = [NSError errorWithDomain:@"GalleryManagerError" code:kInvalidResponse userInfo:nil];
                [self giveCallbackWithErrorCode:error andModel:nil];
            } else {
                if(!model) {
                    SearchObjectModel *searchModel = [[SearchObjectModel alloc] initWithDictionary:[response valueForKey:@"photos"]];
                    if(searchModel) {
                        searchModel.keyword = keyWord;
                        [self prefetchImageFromStart:0 toPosition:(int)searchModel.photosList.count-1 forModel:searchModel andGiveCallbackAfter:20];
                    } else {
                        NSError *error = [NSError errorWithDomain:@"GalleryManagerError" code:kInvalidResponse userInfo:nil];
                        [self giveCallbackWithErrorCode:error andModel:nil];
                    }
                } else {
                    [self updateModel:model withDictionary:[response valueForKey:@"photos"]];
                }
            }
        }];
    }
}

- (void)updateModel:(SearchObjectModel *)model withDictionary:(NSDictionary *)dictionary {
    NSError *error = nil;
    NSArray *photoList = [dictionary valueForKey:@"photo"];
    NSMutableArray *updateList = [model.photosList mutableCopy];

    if([photoList isKindOfClass:[NSArray class]]) {
        for(NSDictionary *photo in photoList) {
            PhotoModel *obj = [[PhotoModel alloc] initWithDictionary:photo];
            if([obj isKindOfClass:[PhotoModel class]]) {
                [updateList addObject:obj];
            }
        }
        int start = (int)model.photosList.count-1;
        model.photosList = updateList;
        [self prefetchImageFromStart:start toPosition:(int)model.photosList.count-1 forModel:model andGiveCallbackAfter:20];
    } else {
        error = [NSError errorWithDomain:@"GalleryManagerError" code:kInvalidResponse userInfo:nil];
        [self giveCallbackWithErrorCode:error andModel:model];
    }
}

@end
