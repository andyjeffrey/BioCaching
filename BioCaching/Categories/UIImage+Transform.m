//
//  UIImage+Transform.m
//  BioCaching
//
//  Created by Andy Jeffrey on 02/10/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "UIImage+Transform.h"

@implementation UIImage (Transform)

- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
