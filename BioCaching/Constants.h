//
//  Constants.h
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//


#define kOccurrenceSearch @"http://api.gbif.org/v0.9/occurrence/search?georeferenced=TRUE&limit=%d&offset=%d&basisOfRecord=%@&institutionCode=%@&taxonKey=%@&collectorName=%@&year=%@&from=%@&to=%@&geometry=%@"
#define kOccurrenceSearchPolygon @"http://api.gbif.org/v0.9/occurrence/search?georeferenced=TRUE&limit=%d&offset=%d&geometry=%@"

#define kDefaultLimit 300
#define kDefaultOffset 0
