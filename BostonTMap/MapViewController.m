//
//  MapViewController.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MapViewController.h"
#import <MoPub/MPAdView.h>
#import "AdNavController.h"
#import "SchedulesViewController.h"

@interface MapViewController () <UIScrollViewDelegate, MPAdViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *schedulesButtonTopConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *subwayImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *subwayScrollView;
@property (strong, nonatomic) IBOutlet UIButton *schedulesButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyButton;

@property BOOL bannerIsVisible;
@property (nonatomic, retain) MPAdView *adView;

@end

static float const AnimationDuration = .1;

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // TODO: Replace this test id with your personal ad unit id
    MPAdView* adView = [[MPAdView alloc] initWithAdUnitId:@"f34387b7990b4d85976abf940b2ad454"
                                                     size:MOPUB_BANNER_SIZE];
    self.adView = adView;
    self.adView.delegate = self;
    self.adView.frame = CGRectMake(0, -MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    [self.adView loadAd];
    self.bannerIsVisible=NO;
    
    [self.subwayImageView addSubview:self.buttonView];
    [self.subwayImageView bringSubviewToFront:self.buttonView];
    [self.subwayImageView setUserInteractionEnabled:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.subwayImageView;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)schedulesPressed
{
    SchedulesViewController *scheduleVC = [[SchedulesViewController alloc] initWithNibName:@"SchedulesViewController" bundle:nil];
    AdNavController *navVC = [[AdNavController alloc] initWithRootViewController:scheduleVC];
    [self presentViewController:navVC animated:YES completion:^{}];
}

#pragma mark - <MPAdViewDelegate>

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

#pragma mark - iAd delegate

- (void)adViewDidLoadAd:(MPAdView *)banner
{
    if (!self.bannerIsVisible){
        self.schedulesButtonTopConstraint.constant += MOPUB_BANNER_SIZE.height;
        [UIView animateWithDuration:AnimationDuration animations:^{
            // banner is invisible now and moved out of the screen on 50 px
            banner.frame = CGRectOffset(banner.frame, 0, MOPUB_BANNER_SIZE.height + [UIApplication sharedApplication].statusBarFrame.size.height);
            [self.view layoutIfNeeded];
        }];
        self.bannerIsVisible = YES;
    }
}

- (void)adViewDidFailToLoadAd:(MPAdView *)banner
{
    if (self.bannerIsVisible){
        self.schedulesButtonTopConstraint.constant -= MOPUB_BANNER_SIZE.height;
        [UIView animateWithDuration:AnimationDuration animations:^{
            // banner is visible and we move it out of the screen, due to connection issue
            banner.frame = CGRectOffset(banner.frame, 0, -MOPUB_BANNER_SIZE.height - [UIApplication sharedApplication].statusBarFrame.size.height);
            [self.view updateConstraints];
        }];
        self.bannerIsVisible = NO;
    }
}

- (IBAction)policyTapped
{
    NSURL *privacyPolicyURL = [NSURL URLWithString:@"https://teschrock.wordpress.com/transit-app-privacy-policy/"];
    if ([[UIApplication sharedApplication] canOpenURL:privacyPolicyURL]) [[UIApplication sharedApplication] openURL:privacyPolicyURL];
}

@end
