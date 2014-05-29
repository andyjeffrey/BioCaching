//
//  BCButton.m
//  BioCaching
//
//  Created by Andy Jeffrey on 29/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCButton.h"

@implementation BCButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor kColorBCButtonBackground];
        
        // Initialization code
    }
    return self;
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor kColorBCButtonBackgroundHighlight];
    }
    else {
        self.backgroundColor = [UIColor kColorBCButtonBackground];
    }
}

@end
