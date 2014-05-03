//
//  ImageCache.h
//  BioCaching
//
//  Created by Andy Jeffrey on 28/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#define radians( degrees ) ( degrees * M_PI / 180 )

@interface ImageCache : NSObject

+ (void)saveImageForURL:(NSString *)url;
+ (UIImage *)getImageForURL:(NSString *)url;

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;

@end
