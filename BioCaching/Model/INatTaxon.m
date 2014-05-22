//
//  INatTaxon.m
//  BioCaching
//
//  Created by Andy Jeffrey on 02/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "INatTaxon.h"

@implementation INatTaxon

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"common_name.name" : @"common_name",
                                                       @"taxon_photos.photo" : @"taxon_photos"
                                                       }];
}

@end