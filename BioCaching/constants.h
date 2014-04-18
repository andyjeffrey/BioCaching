//
//  constants.h
//  BioCaching
//
//  Created by Andy Jeffrey on 16/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#ifndef BioCaching_constants_h
#define BioCaching_constants_h

#define kGBIFBaseURL @"http://api.gbif.org/v0.9/"
#define kGBIFOccurrenceSearch @"occurrence/search?georeferenced=TRUE&limit=%d&offset=%d&basisOfRecord=%@&institutionCode=%@&taxonKey=%@&collectorName=%@&year=%@&from=%@&to=%@&geometry=%@"
#define kGBIFOccurrenceDefaultLimit 300
#define kGBIFOccurrenceDefaultOffset 0

#define kINatBaseURL @"http://www.inaturalist.org/";

#define kOptionsDefaultSearchAreaSpan 1000
#define kOptionsDefaultDisplayPoints 20
#define kOptionsDefaultFullSpeciesNames YES
#define kOptionsDefaultUniqueSpecies YES
#define kOptionsDefaultUniqueLocations YES

/*
#define kOccurrenceSearch @"http://api.gbif.org/v0.9/occurrence/search?georeferenced=TRUE&limit=%d&offset=%d&basisOfRecord=%@&institutionCode=%@&taxonKey=%@&collectorName=%@&year=%@&from=%@&to=%@&geometry=%@"
#define kOccurrenceSearchPolygon @"http://api.gbif.org/v0.9/occurrence/search?georeferenced=TRUE&limit=%d&offset=%d&geometry=%@"
*/



#endif
