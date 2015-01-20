//
//  AppDelegate.m
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 10/5/12.
//
//

#import "AppDelegate.h"
#import "Flurry.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession:@"R3N3NS36S2BDR4XR4RFD"];
    return YES;
}

@end
