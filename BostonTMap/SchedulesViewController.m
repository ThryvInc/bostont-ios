//
//  SchedulesViewController.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "SchedulesViewController.h"
#import "LineViewController.h"
#import "Line.h"
#import "Route.h"

@interface SchedulesViewController () <LineDelegate>
@property (nonatomic, strong) UIAlertView *loadingView;

@end

@implementation SchedulesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (IBAction)lineChosen:(UIButton *)sender
{
    self.loadingView = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please wait" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [self.loadingView show];
    
    Line *line = [[Line alloc] init];
    line.delegate = self;
    
    NSString *lineString = [[sender.titleLabel.text componentsSeparatedByString:@" "] objectAtIndex:0];
    NSArray *routes;
    if ([lineString isEqualToString:@"Red"]) {
        routes = @[[Route braintree], [Route ashmont]];
    }else if ([lineString isEqualToString:@"Blue"]){
        routes = @[[Route blue]];
    }else if ([lineString isEqualToString:@"Orange"]){
        routes = @[[Route orange]];
    }else if ([lineString isEqualToString:@"Green"]){
        routes = @[[Route greenB], [Route greenC], [Route greenD], [Route greenE]];
    }
    line.routes = routes;
    
    [line fetchRoutes];
}

- (void)lineLoaded:(Line *)line
{
    [self.loadingView dismissWithClickedButtonIndex:0 animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    
    LineViewController *lineVC = [[LineViewController alloc] initWithNibName:@"LineViewController" bundle:nil];
    lineVC.line = line;
    [self.navigationController pushViewController:lineVC animated:YES];
}

@end
