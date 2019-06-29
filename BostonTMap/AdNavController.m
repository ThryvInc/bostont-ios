//
//  QEAdNavController.m
//  QE
//
//  Created by Ellidi Jatgeirsson on 9/23/12.
//  Copyright (c) 2012 QE. All rights reserved.
//

#import "AdNavController.h"

@import GoogleMobileAds;

@interface AdNavController () <GADBannerViewDelegate>
@property BOOL bannerIsVisible;
@property (nonatomic, strong) GADBannerView *bannerView;
@end

static float const AnimationDuration = .1;

@implementation AdNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    
    [self addBannerViewToView:self.bannerView];
    self.bannerView.adUnitID = @"ca-app-pub-2574276621042285/9530012507";
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    self.bannerIsVisible=NO;
}

- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    bannerView.alpha = 0;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.bottomLayoutGuide
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]
                                ]];
}

#pragma mark - <MPAdViewDelegate>

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    if (!self.bannerIsVisible){
        [UIView animateWithDuration:AnimationDuration animations:^{
            bannerView.alpha = 1;
        }];
        self.bannerIsVisible = YES;
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    if (self.bannerIsVisible){
        [UIView animateWithDuration:AnimationDuration animations:^{
            // banner is visible and we move it out of the screen, due to connection issue
            bannerView.alpha = 0;
        }];
        self.bannerIsVisible = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
