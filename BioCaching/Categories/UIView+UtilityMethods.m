//
//  UIView+UtilityMethods.m
//  BioCaching
//
//  Created by Andy Jeffrey on 24/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "UIView+UtilityMethods.h"

@implementation UIView (UtilityMethods)

-(NSString *)debugDescription
{
    NSString *debugString = [NSString stringWithFormat:@"%@ = %@", self, self.coords];
    
    return debugString;
}

-(NSString *)coords
{
    NSString *coordsString = [NSString stringWithFormat:@"(%.f,%.f)->(%.f,%.f)", self.frame.origin.x, self.frame.origin.y, self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height];

    return coordsString;
}

@end
