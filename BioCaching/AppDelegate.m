//
//  AppDelegate.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"
#import "LocalyticsSession.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureFlurryAnalytics];
    [self startLocalytics];

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    [self stopLocalytics];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self stopLocalytics];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self resumeLocalytics];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self resumeLocalytics];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self stopLocalytics];
}

- (void)configureFlurryAnalytics
{
#ifdef BIOC_ANALYTICS
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:kFlurryAPIKey];
#endif
}

- (void)startLocalytics
{
#ifdef BIOC_ANALYTICS
    [[LocalyticsSession shared] startSession:kLocalyticsAPIKey];
#endif
}

- (void)stopLocalytics
{
#ifdef BIOC_ANALYTICS
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
#endif
}

- (void)resumeLocalytics
{
#ifdef BIOC_ANALYTICS
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
#endif
}


@end
