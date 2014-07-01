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
#define kGBIFTestAPIBaseURL @"http://api.gbif-uat.org/v0.9/"
#define kGBIFOccurrenceSearch @"occurrence/search?georeferenced=TRUE&limit=%d&offset=%d&basisOfRecord=%@&institutionCode=%@&taxonKey=%@&collectorName=%@&year=%@&from=%@&to=%@&geometry=%@"
#define kGBIFOccurrenceDefaultLimit 300
#define kGBIFOccurrenceDefaultOffset 0

#define kINatAuthService @"INatAuthService"
#define kINatAuthServiceExtToken @"INatAuthServiceExtToken"
#define kINatAuthUsernamePrefKey @"INatUsernamePrefKey"
#define kINatAuthPasswordPrefKey @"INatPasswordPrefKey"
#define kINatAuthTokenPrefKey @"INatTokenPrefKey"
#define kINatAuthUserIDPrefKey @"INatUserIDPrefKey"

#define kLastVersionPrefKey @"LastVersionPrefKey"

#ifdef DEBUG
//    #define kINatBaseURL @"http://localhost:3000"
    #define kINatBaseURL @"http://www.inaturalist.org/"
#else
    #define kINatBaseURL @"https://www.inaturalist.org/"
#endif

#define kINatTripsPathPattern @"trips"
#define kINatTripsKeyPath @"trips"

#define kBHLBaseURL @"http://www.biodiversitylibrary.org/"
#define kBHLSpeciesBiblioPath @"name/"

#define kOptionsDefaultSearchAreaSpan 1000
#define kOptionsDefaultMapType 0
#define kOptionsDefaultDisplayPoints 20
#define kOptionsDefaultFullSpeciesNames YES
#define kOptionsDefaultUniqueSpecies YES
#define kOptionsDefaultUniqueLocations YES


#define kDefaultSearchAreaSpan 1000
#define kDefaultViewSpan 5000
#define kDefaultTripDuration 14400

#endif
