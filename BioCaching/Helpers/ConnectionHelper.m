//
//  ConnectionHelper.m
//  BioCaching
//
//  Created by Andy Jeffrey on 12/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ConnectionHelper.h"
#import "Reachability.h"

static Reachability *networkReachability;

@implementation ConnectionHelper

+ (BOOL)checkNetworkConnectivityAndDisplayAlert:(BOOL)displayAlert
{
    networkReachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus internetStatus = [networkReachability currentReachabilityStatus];
    if (internetStatus == NotReachable) {
        if (displayAlert) {
            [BCAlerts displayDefaultInfoAlert:@"Internet Required"
                                      message:@"Please Try Again When\nConnected To The Internet"];
        }
        return FALSE;
    }
    return TRUE;
}

+ (BOOL)checkWifiConnectivityAndDisplayAlert:(NSString *)alertMessage
{
    networkReachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus internetStatus = [networkReachability currentReachabilityStatus];
    if (internetStatus != ReachableViaWiFi) {
        if (alertMessage) {
            [BCAlerts displayDefaultFailureNotification:@"No Wifi Connection Detected" subtitle:alertMessage];
        }
        return FALSE;
    }
    return TRUE;
}

@end
