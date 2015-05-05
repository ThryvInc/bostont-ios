//
//  QEAdNavController.m
//  QE
//
//  Created by Ellidi Jatgeirsson on 9/23/12.
//  Copyright (c) 2012 QE. All rights reserved.
//

#import "AdNavController.h"
#import <MoPub/MPAdView.h>

@interface AdNavController ()  <MPAdViewDelegate>
@property (nonatomic, retain) MPAdView *adView;
@property BOOL bannerIsVisible;
@end

static float const AnimationDuration = .1;

@implementation AdNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // TODO: Replace this test id with your personal ad unit id
    MPAdView* adView = [[MPAdView alloc] initWithAdUnitId:@"f34387b7990b4d85976abf940b2ad454"
                                                     size:MOPUB_BANNER_SIZE];
    self.adView = adView;
    self.adView.delegate = self;
    self.adView.frame = CGRectMake(0, - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    [self.adView loadAd];
    self.bannerIsVisible=NO;
}

#pragma mark - <MPAdViewDelegate>

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)banner
{
    if (!self.bannerIsVisible){
        [UIView animateWithDuration:AnimationDuration animations:^{
            banner.frame = CGRectOffset(banner.frame, 0, MOPUB_BANNER_SIZE.height
                                        + self.navigationBar.bounds.size.height
                                        + [UIApplication sharedApplication].statusBarFrame.size.height);
        }];
        self.bannerIsVisible = YES;
    }
}

- (void)adViewDidFailToLoadAd:(MPAdView *)banner
{
    if (self.bannerIsVisible){
        [UIView animateWithDuration:AnimationDuration animations:^{
            // banner is visible and we move it out of the screen, due to connection issue
            banner.frame = CGRectOffset(banner.frame, 0, -MOPUB_BANNER_SIZE.height
                                        - self.navigationBar.bounds.size.height
                                        - [UIApplication sharedApplication].statusBarFrame.size.height);
        }];
        self.bannerIsVisible = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
