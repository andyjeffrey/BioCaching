//
//  BCButton.m
//  BioCaching
//
//  Created by Andy Jeffrey on 29/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCButton.h"

@implementation BCButton {
    UIColor *origColor;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor kColorButtonBackground];
        [self setTransparency];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor kColorButtonBackgroundHighlight];
        [self setTransparency];
    }
    else {
        self.backgroundColor = [UIColor kColorButtonBackground];
        [self setTransparency];
    }
}

- (void)setTransparency {
    if (self.semiTransparent) {
        self.alpha = 0.8f;
    }
}

@end


@implementation BCButtonRounded

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

@end