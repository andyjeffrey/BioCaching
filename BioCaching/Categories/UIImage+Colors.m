//
//  UIImage+Colors.m
//  BioCaching
//
//  Created by Andy Jeffrey on 29/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "UIImage+Colors.h"

@implementation UIImage (Colors)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
