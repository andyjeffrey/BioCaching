//
//  INatTaxon.h
//  BioCaching
//
//  Created by Andy Jeffrey on 02/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "INatTaxonPhoto.h"

@class INatTaxonCommonName;
@class INatTaxonDefaultName;

@interface INatTaxon : JSONModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *common_name;
@property (nonatomic, strong) NSString <Optional> *image_url;
@property (nonatomic, strong) NSString <Optional> *wikipedia_summary;

//@property (nonatomic, strong) INatTaxonDefaultName *default_name;
@property (nonatomic, strong) NSArray<INatTaxonPhoto> *taxon_photos;

@end


