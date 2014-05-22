//
//  APIOption.m
//  BioCaching
//
//  Created by Andy Jeffrey on 05/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "APIOption.h"

@implementation APIOption

- (id) initWithValues:(NSString *)displayString queryStringValueGBIF:(NSString *)queryStringValueGBIF
{
    self=[super init];
    if(self)
    {
        _displayString = displayString;
        _queryStringValueGBIF = queryStringValueGBIF;
    }
    return self;
}

@end
