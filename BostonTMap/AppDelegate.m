//
//  AppDelegate.m
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 10/5/12.
//
//

#import "AppDelegate.h"
#import "Flurry.h"
#import <Fabric/Fabric.h>
#import <MoPub/MoPub.h>
#import <Crashlytics/Crashlytics.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[CrashlyticsKit, MoPubKit]];
    [Flurry startSession:@"R3N3NS36S2BDR4XR4RFD"];
    return YES;
}

@end
