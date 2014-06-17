//
//  BCOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 23/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCOptions.h"

@implementation BCOptions

-(id)initWithDefaults
{
    if(self = [[BCOptions alloc] init])
    {
        _searchOptions = [SearchOptions initWithDefaults];
        _displayOptions = [DisplayOptions sharedInstance];
    }
    return self;
}

@end
