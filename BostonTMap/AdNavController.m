//
//  QEAdNavController.m
//  QE
//
//  Created by Ellidi Jatgeirsson on 9/23/12.
//  Copyright (c) 2012 QE. All rights reserved.
//

#import "AdNavController.h"
#import <MoPub/MPAdView.h>
#import <CoreLocation/CoreLocation.h>
#import <YextRetap/YextRetap.h>

@interface AdNavController ()  <MPAdViewDelegate, CLLocationManagerDelegate, YSRetapDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) MPAdView *adView;
@property BOOL bannerIsVisible;
@property (nonatomic) YSRetapTipView *retapTipView;
@property (nonatomic, strong) YSLocationContext *retapContext;
@end

static float const AnimationDuration = .1;

@implementation AdNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // TODO: Replace this test id with your personal ad unit id
    MPAdView *adView = [[MPAdView alloc] initWithAdUnitId:@"f34387b7990b4d85976abf940b2ad454"
                                                     size:MOPUB_BANNER_SIZE];
    self.adView = adView;
    self.adView.delegate = self;
    self.adView.frame = CGRectMake(0, self.view.bounds.size.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    [self.adView loadAd];
    self.bannerIsVisible=NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YextRetap sharedInstance].delegate = self;
    
    // Remove any pre-existing tip without animation.  This can occur if a tip
    // was already shown in this view controller (possibly for a different
    // location) or if your view was hidden by no other view took over as
    // delegate.
    [self hideTip:NO];
    
    // Check to see if a tip should be shown.  The dismissedByUser property is
    // used to persist whether the same tip for a location should be shown in
    // the future.
    if ([YextRetap sharedInstance].locationContext &&
        ![YextRetap sharedInstance].locationContext.dismissedByUser)
    {
        [self showTipWithContext:[YextRetap sharedInstance].locationContext
                        animated:NO];
    }
}

#pragma mark - <MPAdViewDelegate>

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)banner
{
    if (!self.bannerIsVisible){
        [UIView animateWithDuration:AnimationDuration animations:^{
            banner.frame = CGRectOffset(banner.frame, 0, - MOPUB_BANNER_SIZE.height);

        }];
        self.bannerIsVisible = YES;
    }
}

- (void)adViewDidFailToLoadAd:(MPAdView *)banner
{
    if (self.bannerIsVisible){
        [UIView animateWithDuration:AnimationDuration animations:^{
            // banner is visible and we move it out of the screen, due to connection issue
            banner.frame = CGRectOffset(banner.frame, 0, MOPUB_BANNER_SIZE.height);
        }];
        self.bannerIsVisible = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - location manager delegate

- (void)setupLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

-(void)locationStatus
{
    switch (CLLocationManager.authorizationStatus) {
        case kCLAuthorizationStatusAuthorized:{
            // ...
        }
            break;
            
        case kCLAuthorizationStatusNotDetermined:{
            [self.locationManager requestAlwaysAuthorization];
        }
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Background Location Access Disabled" message:@"In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (&UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings];
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:openAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark Yext delegate

- (void)showTipWithContext:(YSLocationContext *)context animated:(BOOL)animated
{
    self.retapTipView = [[YSRetapTipView alloc] initWithContext:context];
    //example view customization:
        self.retapTipView.animationType = YSRetapTipViewAnimationTypeFade;
        self.retapTipView.position = YSRetapTipViewPositionBottom;
        self.retapTipView.backgroundColor = [UIColor darkGrayColor];
    
    [self.retapTipView presentFromViewController:self animated:animated];
}

- (void)hideTip:(BOOL)animated
{
    [self.retapTipView dismissWithAnimated:animated];
    self.retapTipView = nil;
}

- (void)retap:(YextRetap *)retap enteredLocation:(YSLocationContext *)context
{
    self.retapContext = context;
    [self showTipWithContext:context
                    animated:YES];
}

- (void)retap:(YextRetap *)retap exitedLocation:(YSLocationContext *)context
{
    [self hideTip:YES];
}

// This method would be set as the target of your Tip button
- (void)showRetapListing:(UIButton *)sender
{
    // self.retapContext in this example would have been previously stored in retap:enteredLocation:context.
    // The view controller passed to fromViewController should be a top level view controller, it will be used to present the listing modally
    [[YextRetap sharedInstance] showRetapWithContext:self.retapContext fromViewController:self];
}

@end
