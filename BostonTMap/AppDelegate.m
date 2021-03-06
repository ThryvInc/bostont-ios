//
//  AppDelegate.m
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 10/5/12.
//
//

#import "AppDelegate.h"
#import "Flurry.h"
#import "MapViewController.h"
#import "NagController.h"
#import <Fabric/Fabric.h>
#import <MoPub/MoPub.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()
@property (nonatomic, strong) NagController *nagger;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[CrashlyticsKit, MoPubKit]];
    [Flurry startSession:@"R3N3NS36S2BDR4XR4RFD"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    int appOpens = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfAppOpens"];
    appOpens++;
    [Flurry logEvent:@"AppOpened" withParameters:@{@"numberOfOpens" : [self returnedCohort:appOpens]}];
    [[NSUserDefaults standardUserDefaults] setInteger:appOpens forKey:@"numberOfAppOpens"];
    self.nagger = [[NagController alloc] init];
    [self.nagger startNag];
}

- (NSString *)returnedCohort:(int)numberOfTimesReturned
{
    NSString *returnedString;
    if (numberOfTimesReturned == 1) {
        returnedString = @"1";
    }else if (numberOfTimesReturned == 2){
        returnedString = @"2";
    }else if (numberOfTimesReturned > 100){
        returnedString = @">100";
    }else if (numberOfTimesReturned > 50){
        returnedString = @"100 > x > 50";
    }else if (numberOfTimesReturned > 20){
        returnedString = @"50 > x > 20";
    }else if (numberOfTimesReturned > 10){
        returnedString = @"20 > x > 10";
    }else if (numberOfTimesReturned > 5){
        returnedString = @"10 > x > 5";
    }else if (numberOfTimesReturned > 2){
        returnedString = @"5 > x > 2";
    }
    return returnedString ? returnedString : @"0";
}

@end
