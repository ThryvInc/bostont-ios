//
//  QEAdNavController.m
//  QE
//
//  Created by Ellidi Jatgeirsson on 9/23/12.
//  Copyright (c) 2012 QE. All rights reserved.
//

#import "AdNavController.h"

@interface AdNavController () <ADBannerViewDelegate>

@end

@implementation AdNavController
@synthesize adView = _adView;
@synthesize bannerIsVisible = _bannerIsVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    self.adView.frame = CGRectOffset(self.adView.frame, 0, -50);
    self.adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
    self.adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    [self.view addSubview:self.adView];
    self.adView.delegate=self;
    self.bannerIsVisible=NO;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - iAd delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, 114);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame, 0, -114);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
