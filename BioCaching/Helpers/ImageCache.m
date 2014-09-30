//
//  ImageCache.m
//  BioCaching
//
//  Created by Andy Jeffrey on 28/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ImageCache.h"

static const int ddLogLevel = LOG_LEVEL_DEBUG;

@implementation ImageCache

+ (void)saveImageForURL:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse) {
        DDLogDebug(@"ImageURL already cached:%@", urlString);
    } else {
        DDLogDebug(@"Caching Image URL:%@", urlString);
        UIImageView *tempImageView = [[UIImageView alloc] init];
        [tempImageView setImageWithURL:[NSURL URLWithString:urlString]];
    }
}

+ (UIImage *)getImageForURL:(NSString *)urlString
{
    NSData *responseData;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse) {
        DDLogDebug(@"ImageURL cached:%@", urlString);
        responseData = cachedResponse.data;
    }
    else{
        DDLogDebug(@"ImageURL NOT cached:%@", urlString);
        NSError *error = nil;
        NSURLResponse *response = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    }
    
    return [UIImage imageWithData:responseData];
}

// Adapted from http://stackoverflow.com/questions/1282830/uiimagepickercontroller-uiimage-memory-and-more
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize
{
//    DDLogDebug(@"ImageWithImage Source: %.0f,%.0f %.3f", sourceImage.size.width, sourceImage.size.height, sourceImage.size.width/sourceImage.size.height);
//    DDLogDebug(@"ImageWithImage Frame: %.0f,%.0f %.3f", targetSize.width, targetSize.height, targetSize.width/targetSize.height);
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    // don't scale up
    if (targetSize.width > width || targetSize.height > height) {
        targetWidth = width;
        targetHeight = height;
    }
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        CGFloat translation;
        if (targetWidth == targetHeight) {
            translation = -targetHeight;
        } else {
            translation = -scaledHeight;
        }
        
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, translation);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        CGFloat translation;
        if (targetWidth == targetHeight) {
            translation = -targetWidth;
        } else {
            translation = -scaledWidth;
        }
        
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, translation, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);

//    DDLogDebug(@"ImageWithImage Scaled: %.0f,%.0f %.3f", newImage.size.width, newImage.size.height, newImage.size.width/newImage.size.height);
    
    return newImage;
}

@end
