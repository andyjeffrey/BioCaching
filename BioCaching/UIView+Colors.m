//
//  UIView+Colors.m
//  BioCaching
//
//  Created by Andy Jeffrey on 08/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "UIView+Colors.h"

@implementation UIView (Colors)

- (void)changeAllLabelsTextColor:(UIColor *)color
{
    for (id view in [self subviews]) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *viewLabel = (UILabel *)view;
//            [viewLabel setFont:font];
            [viewLabel setTextColor:color];
            [view setBackgroundColor:[UIColor clearColor]];
        }
        if ([view isKindOfClass:[UIView class]]) {
            [self changeAllLabelsTextColor:view];
        }
    }
}

@end
