//
//  UILabel+Appearance.m
//  BioCaching
//
//  Created by Andy Jeffrey on 08/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

static NSString *htmlDocFormat =
@"<html>"
"  <head>"
"    <style type='text/css'>"
"      body { font: 10pt 'Arial'; color: #fff; }"
"      i { color: #fff; }"
"    </style>"
"  </head>"
"  <body>%@</body>"
"</html>";

#import "UILabel+Appearance.h"

@implementation UILabel (Appearance)

- (void)setTextWithDefaults:(NSString *)text
{
    [self setTextColor:[UIColor kColorLabelText]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setText:text];
}

- (void)setTextWithColor:(NSString *)text color:(UIColor *)color
{
    [self setTextColor:color];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setText:text];
}

- (void)setHtml:(NSString*)html
{
    NSString *htmlDoc = [NSString stringWithFormat:htmlDocFormat, html];
    NSError *err = nil;
    self.attributedText =
    [[NSAttributedString alloc]
     initWithData:[htmlDoc dataUsingEncoding:NSUTF8StringEncoding]
     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
     documentAttributes: nil
     error: &err];
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
}
@end
