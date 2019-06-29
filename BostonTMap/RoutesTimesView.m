//
//  RoutesTimesView.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/24/15.
//
//

#import "RoutesTimesView.h"
#import "RouteTimesView.h"
#import "Station.h"
#import "Route.h"
#import "Prediction.h"

@interface RoutesTimesView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fifthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sixthConstraint;
@property (weak, nonatomic) IBOutlet RouteTimesView *firstRoute;
@property (weak, nonatomic) IBOutlet RouteTimesView *secondRoute;
@property (weak, nonatomic) IBOutlet RouteTimesView *thirdRoute;
@property (weak, nonatomic) IBOutlet RouteTimesView *fourthRoute;
@property (weak, nonatomic) IBOutlet RouteTimesView *fifthRoute;
@property (weak, nonatomic) IBOutlet RouteTimesView *sixthRoute;

@end

@implementation RoutesTimesView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setStation:(Station *)station
{
    _station = station;
    [self setupRoutes];
    [station refresh:^{
        if ([_station isEqual:station]) {
            [self setupRoutes];
        }
    }];
}

- (void)setup
{
    [[NSBundle mainBundle] loadNibNamed:@"RoutesTimesView" owner:self options:nil];
    [self addSubview:self.view];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_view)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_view)]];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupRoutes
{
    [self timesForRoutes:self.station.routes
              routeViews:@[self.firstRoute, self.secondRoute, self.thirdRoute, self.fourthRoute, self.fifthRoute, self.sixthRoute]
             constraints:@[self.secondConstraint, self.thirdConstraint, self.fourthConstraint, self.fifthConstraint, self.sixthConstraint]];
}

- (void)timesForRoutes:(NSArray *)routes routeViews:(NSArray<RouteTimesView *> *)routeViews constraints:(NSArray<NSLayoutConstraint *> *)constraints
{
    routeViews[0].alpha = 0;
    for (int i = 1; i<routeViews.count; i++){
        routeViews[i].alpha = 0;
        constraints[i - 1].constant = -12;
    }
    
    if (routes.count > 0) {
        [self timesForRoute:routes[0] intoRouteView:routeViews[0] constraint:nil];
        for (int i = 1; i<routes.count; i++){
            [self timesForRoute:routes[i] intoRouteView:routeViews[i] constraint:constraints[i - 1]];
        }
    }
    
    [self updateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)timesForRoute:(Route *)route intoRouteView:(RouteTimesView *)routeView constraint:(NSLayoutConstraint *)constraint
{
    routeView.alpha = 1;
    constraint.constant = 2;
    Prediction *prediction1 = [[self.station zeroPredictionsForRoute:route] firstObject];
    Prediction *prediction2 = [[self.station onePredictionsForRoute:route] firstObject];
    if (prediction1 && prediction2) {
        routeView.predictions = @[prediction1, prediction2];
    } else if (prediction1) {
        routeView.predictions = @[prediction1];
    } else if (prediction2) {
        routeView.predictions = @[prediction2];
    }
}

@end
