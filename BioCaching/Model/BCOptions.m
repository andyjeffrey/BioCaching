//
//  BCOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 23/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCOptions.h"

@implementation BCOptions

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static BCOptions *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BCOptions sharedInstance]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _searchOptions = [SearchOptions sharedInstance];
        _displayOptions = [DisplayOptions sharedInstance];
    }
    return self;
}


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
