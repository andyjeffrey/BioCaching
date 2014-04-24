//
//  MapViewLayoutGuide.h
//  BioCaching
//
//  Created by Andy Jeffrey on 23/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapViewLayoutGuide : NSObject <UILayoutSupport>

@property (nonatomic) CGFloat pbLength;
- (id)initWithLength:(CGFloat)length;
@end

@implementation MapViewLayoutGuide

- (id)initWithLength:(CGFloat)length {
    self = [super init];
    if (self) {
        _pbLength = length;
    }
    return self;
}

- (CGFloat)length {
    return _pbLength;
}

@end