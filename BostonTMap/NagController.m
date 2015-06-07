//
//  NagController.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/27/15.
//
//

#import "NagController.h"
#import "Flurry.h"
#import "NSDate+RelativeTime.h"

@interface NagController ()
@property (nonatomic) BOOL isRatingNag;
@end

static NSString * const LastNaggedKey = @"lastNagged";
static NSString * const ShouldNagRatingKey = @"should_nag_rating";
static NSString * const ShouldNagAppKey = @"should_nag_app";
static int const AffirmativeIndex = 1;
static int const AlreadyHaveIndex = 0;
static int const NeverIndex = 2;

@implementation NagController

- (void)startNag
{
    int appOpens = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfAppOpens"];
    if (appOpens % 3 == 0) {
        if (![self lastNagged] || [[self lastNagged] isBefore:[[NSDate date] incrementUnit:NSCalendarUnitDay by:-2]]) {
            if ([self canNagRating]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(17 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isRatingNag = YES;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry to interrupt," message:@"...but would you mind terribly taking a moment to rate this app?" delegate:self cancelButtonTitle:@"I already have!" otherButtonTitles:@"Yes, I'd be delighted!",@"Nope, I will never rate your app",@"Mmm, not right now",nil];
                    [alert show];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LastNaggedKey];
                });
            }else if ([self canNagApp]){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(17 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isRatingNag = NO;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey!" message:@"You seem to be enjoying the app, would you like to help support an independent app developer and download the paid version?" delegate:self cancelButtonTitle:@"Mmm, maybe later" otherButtonTitles:@"Yes, I'd be delighted!",@"I prefer clicking on ads to support you",nil];
                    [alert show];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LastNaggedKey];
                });
            }
        }
    }
}

- (BOOL)canNagRating
{
    BOOL result;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:ShouldNagRatingKey]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ShouldNagRatingKey];
    }
    result = [[NSUserDefaults standardUserDefaults] boolForKey:ShouldNagRatingKey];
    return result;
}

- (BOOL)canNagApp
{
    BOOL result;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:ShouldNagAppKey]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ShouldNagAppKey];
    }
    result = [[NSUserDefaults standardUserDefaults] boolForKey:ShouldNagAppKey];
    return result;
}

- (NSDate *)lastNagged
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LastNaggedKey];
}

#pragma mark - alertView delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.isRatingNag) {
        switch (buttonIndex) {
            case AffirmativeIndex:
            {
                [Flurry logEvent:@"NagRate-v1" withParameters:@{@"response":@"WillRate"}];
                NSString *iTunesLink = @"https://itunes.apple.com/us/app/mbta-boston-t-map/id568754858?mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ShouldNagRatingKey];
            }
                break;
            case AlreadyHaveIndex:
            {
                [Flurry logEvent:@"NagRate-v1" withParameters:@{@"response":@"HasRated"}];
            }
                break;
            case NeverIndex:
            {
                [Flurry logEvent:@"NagRate-v1" withParameters:@{@"response":@"NeverRate"}];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ShouldNagRatingKey];
            }
                break;
                
            default:
            {
                [Flurry logEvent:@"NagRate-v1" withParameters:@{@"response":@"RateLater"}];
            }
                break;
        }
    }else{
        switch (buttonIndex) {
            case AffirmativeIndex:
            {
                [Flurry logEvent:@"NagBuy-v1" withParameters:@{@"response":@"WillBuy"}];
                NSString *iTunesLink = @"https://itunes.apple.com/us/app/mbta-boston-t-map-ad-free/id999355167?ls=1&mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
            }
                break;
            case AlreadyHaveIndex:
            {
                [Flurry logEvent:@"NagBuy-v1" withParameters:@{@"response":@"HasBought"}];
            }
                break;
            case NeverIndex:
            {
                [Flurry logEvent:@"NagBuy-v1" withParameters:@{@"response":@"NeverBuy"}];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ShouldNagAppKey];
            }
                break;
                
            default:
            {
                [Flurry logEvent:@"NagBuy-v1" withParameters:@{@"response":@"BuyLater"}];
            }
                break;
        }
    }
}

@end
