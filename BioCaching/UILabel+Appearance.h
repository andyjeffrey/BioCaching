//
//  UILabel+Appearance.h
//  BioCaching
//
//  Created by Andy Jeffrey on 08/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Appearance)

- (void)setTextWithDefaults:(NSString *)text;
- (void)setTextWithColor:(NSString *)text color:(UIColor *)color;
- (void)setHtml:(NSString*)html;

@end
