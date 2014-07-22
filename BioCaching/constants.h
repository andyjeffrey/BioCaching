//
//  constants.h
//  BioCaching
//
//  Created by Andy Jeffrey on 16/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#ifndef BioCaching_constants_h
#define BioCaching_constants_h

#define kLastVersionPrefKey @"LastVersionPrefKey"
#define kCounterLaunchesKey @"CounterLaunches"
#define kCounterGBIFSearches @"GBIFSearches"
#define kCounterINatSearches @"INatSearches"
#define kCounterTripsCreated @"TripsCreated"
#define kCounterTripsFailed @"TripsFailed"

#define kGBIFBaseURL @"http://api.gbif.org/v1/"
#define kGBIFBaseURLPreV1 @"http://api.gbif.org/v0.9/"
//#define kGBIFTestAPIBaseURL @"http://api.gbif-uat.org/v0.9/"
#define kGBIFOccurrenceSearch @"occurrence/search?georeferenced=TRUE&limit=%d&offset=%d&basisOfRecord=%@&institutionCode=%@&taxonKey=%@&collectorName=%@&year=%@&from=%@&to=%@&geometry=%@"
#define kGBIFOccurrenceDefaultLimit 300
#define kGBIFOccurrenceDefaultOffset 0

#define kINatBaseURL @"https://www.inaturalist.org/"
#define kINatAuthService @"INatAuthService"
#define kINatAuthServiceExtToken @"INatAuthServiceExtToken"
#define kINatAuthUsernamePrefKey @"INatUsernamePrefKey"
#define kINatAuthPasswordPrefKey @"INatPasswordPrefKey"
#define kINatAuthTokenPrefKey @"INatTokenPrefKey"
#define kINatAuthUserIDPrefKey @"INatUserIDPrefKey"

#define kBHLBaseURL @"http://www.biodiversitylibrary.org/"
#define kBHLSpeciesBiblioPath @"name/"

#define kDefaultLocationIndex 1
#define kDefaultSearchAreaSpan 2000
#define kDefaultViewSpan 5000
#define kDefaultTripDuration 14400

#define kOptionsDefaultMaxDisplayPoints 100
#define kOptionsDefaultDisplayPoints 20
#define kOptionsDefaultMapType 1
#define kOptionsDefaultAutoSearch YES;
#define kOptionsDefaultFollowUser NO;
#define kOptionsDefaultPreCacheImages YES;
#define kOptionsDefaultFullSpeciesNames YES
#define kOptionsDefaultUniqueSpecies YES
#define kOptionsDefaultUniqueLocations YES

#ifdef DEBUG
//    #define kDefaultLocationIndex 1
    #define kINatBaseURL @"http://www.inaturalist.org/"
    #define kOptionsDefaultDisplayPoints 15
    #define kOptionsDefaultPreCacheImages NO;
#endif

#endif
