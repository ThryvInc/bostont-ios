//
//  MapViewController.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MapViewController.h"
#import "AdNavController.h"
#import "SchedulesViewController.h"

@interface MapViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *schedulesButtonTopConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *subwayImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *subwayScrollView;
@property (strong, nonatomic) IBOutlet UIButton *schedulesButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyButton;

@property BOOL bannerIsVisible;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.subwayImageView addSubview:self.buttonView];
    [self.subwayImageView bringSubviewToFront:self.buttonView];
    [self.subwayImageView setUserInteractionEnabled:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    
    SchedulesViewController *scheduleVC = [[SchedulesViewController alloc] initWithNibName:@"SchedulesViewController" bundle:nil];
    [self.navigationController pushViewController:scheduleVC animated:YES];
}

@end
