//
//  CrossHairView.m
//  BioCaching
//
//  Created by Andy Jeffrey on 20/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "CrossHairView.h"
#import <QuartzCore/QuartzCore.h>

static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation CrossHairView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}


- (void)drawRect:(CGRect)rect
{
    DDLogDebug(@"CrossHairView Center:(%.0f,%.0f)", self.center.x, self.center.y);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, self.center.x - 10, self.center.y);
    CGContextAddLineToPoint(context, self.center.x + 10, self.center.y);
    CGContextMoveToPoint(context, self.center.x, self.center.y - 10);
    CGContextAddLineToPoint(context, self.center.x, self.center.y + 10);
    CGContextStrokePath(context);
}


@end
