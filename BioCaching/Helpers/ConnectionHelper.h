//
//  ConnectionHelper.h
//  BioCaching
//
//  Created by Andy Jeffrey on 12/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionHelper : NSObject

+ (BOOL)checkNetworkConnectivityAndDisplayAlert:(BOOL)displayAlert;
+ (BOOL)checkWifiConnectivityAndDisplayAlert:(NSString *)alertMessage;

@end
