//
//  config.h
//  BioCaching
//
//  Created by Andy Jeffrey on 13/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#ifndef BioCaching_config_h
#define BioCaching_config_h

#define kINatClientID               @""
#define kINatClientSecret           @""

#define kParseAppId                 @""
#define kParseClientKey             @""

#define kFlurryAPIKey               @""
#define kLocalyticsAPIKey           @""
#define kGoogleTrackingID           @""

// N.B. Only use ONE error logging tool
#define kCrashlyticsAPIKey          @""
#define kUseCrashlyticsLogging      YES
#define kUseFlurryErrorLogging      NO
#define kUseGoogleErrorLogging      NO

#ifdef DEBUG
    #define kINatTestAccountId          @""
    #define kINatTestAccountPassword    @""
//    #define kClearUserDefaults      YES
//    #define kClearDataStore         YES
    #define BC_ANALYTICS
//    #define GA_LOGGING
//    #define TESTING
#else
    #define BC_ANALYTICS
#endif

#endif
