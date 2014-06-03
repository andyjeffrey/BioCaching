//
//  ExploreDataManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 03/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreDataManager.h"

@implementation ExploreDataManager

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static ExploreDataManager *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ExploreDataManager sharedInstance]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


@end
