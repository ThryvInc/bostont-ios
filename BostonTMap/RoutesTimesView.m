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

- (void)timesForRoutes:(NSArray *)routes routeViews:(NSArray *)routeViews constraints:(NSArray *)constraints
{
    if (routes.count == 0 && ![routeViews containsObject:self.firstRoute]) {
        for (int i = 0; i<routeViews.count; i++){
            RouteTimesView *routeView = routeViews[i];
            NSLayoutConstraint *constraint = constraints[i];
            routeView.alpha = 0;
            constraint.constant = -12;
        }
        [self updateConstraints];
        return;
    }else if (routes.count && routes.count == self.station.routes.count){
        //first one
        [self timesForRoute:routes[0] intoRouteView:routeViews[0] constraint:nil];
        [self timesForRoutes:[self arrayOfRemainingElements:routes]
                  routeViews:[self arrayOfRemainingElements:routeViews]
                 constraints:constraints];
    }else if (routes.count > 0){
        [self timesForRoute:routes[0] intoRouteView:routeViews[0] constraint:constraints[0]];
        [self timesForRoutes:[self arrayOfRemainingElements:routes]
                  routeViews:[self arrayOfRemainingElements:routeViews]
                 constraints:[self arrayOfRemainingElements:constraints]];
    }else{
        self.firstRoute.alpha = 0;
    }
}

- (void)timesForRoute:(Route *)route intoRouteView:(RouteTimesView *)routeView constraint:(NSLayoutConstraint *)constraint
{
    routeView.alpha = 1;
    constraint.constant = 2;
    Prediction *prediction1 = [Prediction earliestPredictionInArray:[self.station predictionsForRoute:route]];
    if (prediction1) {
        Prediction *prediction2 = [Prediction earliestPredictionInArray:[self.station predictionsForRoute:route] oppositeDirectionOf:prediction1];
        if (prediction2) {
            routeView.predictions = @[prediction1, prediction2];
        }else {
            routeView.predictions = @[prediction1];
        }
    }
}

- (NSArray *)arrayOfRemainingElements:(NSArray *)array
{
    return [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return array[0] != evaluatedObject;
    }]];
}

@end
