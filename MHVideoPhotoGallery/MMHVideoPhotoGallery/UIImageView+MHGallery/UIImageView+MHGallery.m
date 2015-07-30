//
//  UIImageView+MHGallery.m
//  MHVideoPhotoGallery
//
//  Created by Mario Hahn on 06.02.14.
//  Copyright (c) 2014 Mario Hahn. All rights reserved.
//

#import "UIImageView+MHGallery.h"
#import "MHGallery.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (MHGallery)

-(void)setThumbWithURL:(NSString*)URL
          successBlock:(void (^)(UIImage *image,NSUInteger videoDuration,NSError *error))succeedBlock{
    
    __weak typeof(self) weakSelf = self;
    
    [MHGallerySharedManager.sharedManager startDownloadingThumbImage:URL
                                                        successBlock:^(UIImage *image, NSUInteger videoDuration, NSError *error) {
                                                            
                                                            if (!weakSelf) return;
                                                            dispatch_main_sync_safe(^{
                                                                if (!weakSelf) return;
                                                                if (image){
                                                                    weakSelf.image = image;
                                                                    [weakSelf setNeedsLayout];
                                                                }
                                                                if (succeedBlock) {                                                                     succeedBlock(image,videoDuration,error);
                                                                }
                                                            });
                                                        }];
}

-(void)setImageForMHGalleryItem:(MHGalleryItem*)item
                      imageType:(MHImageType)imageType
                   successBlock:(void (^)(UIImage *image,NSError *error))succeedBlock{
    [self sd_setImageWithURL:[NSURL URLWithString:item.URLString]
            placeholderImage:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (succeedBlock) {
                           succeedBlock(image, error);
                       }
                   }];
}


-(void)setImageForImageView:(UIImage*)image
               successBlock:(void (^)(UIImage *image,NSError *error))succeedBlock{
    
    __weak typeof(self) weakSelf = self;
    
    if (!weakSelf) return;
    dispatch_main_sync_safe(^{
        weakSelf.image = image;
        [weakSelf setNeedsLayout];
        if (succeedBlock) {
            succeedBlock(image,nil);
        }
    });
}



@end
