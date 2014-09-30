//
//  ImageHelper.m
//  BioCaching
//
//  Created by Andy Jeffrey on 29/09/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (double)getFrameAspectRatio:(CGSize)size
{
    return size.width / size.height;
}

@end
