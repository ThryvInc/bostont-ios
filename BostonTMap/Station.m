//
//  Station.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "Station.h"
#import "MBTAStop.h"
#import "Prediction.h"
#import "Route.h"

@implementation Station

- (BOOL)isStopAtStation:(MBTAStop *)stop
{
    if ([self.stops containsObject:stop]) return YES;
    
    return [self.stationId isEqualToString:stop.parentId];
}

- (void)addStopToStation:(MBTAStop *)stop
{
    if (!self.stops.count || [stop.parentId isEqualToString:self.stationId]) {
        [self.stops addObject:stop];
        
        if (!self.stationId) {
            self.stationId = stop.parentId;
            self.stationName = stop.parentName;
        }
    }
}

- (void)addPrediction:(Prediction *)prediction
{
    [self.predictions addObject:prediction];
    if (![self.routes containsObject:prediction.route]) {
        [self.routes addObject:prediction.route];
    }
}

- (NSArray *)predictionsForRoute:(Route *)route
{
    NSMutableArray *predictions = [[NSMutableArray alloc] init];
    for (Prediction *prediction in self.predictions){
        if ([prediction.route isEqual:route]) [predictions addObject:prediction];
    }
    return [predictions copy];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[Station class]]) return NO;
    
    Station *otherStation = object;
    
    for (MBTAStop *stop in otherStation.stops){
        if ([self.stops containsObject:stop]) return YES;
    }
    
    return [otherStation.stationId isEqualToString:self.stationId];
}

#pragma mark - lazy loading

- (NSMutableArray *)stops
{
    if (!_stops) _stops = [[NSMutableArray alloc] init];
    return _stops;
}

- (NSMutableArray *)predictions
{
    if (!_predictions) _predictions = [[NSMutableArray alloc] init];
    return _predictions;
}

- (NSMutableArray *)routes
{
    if (!_routes) _routes = [[NSMutableArray alloc] init];
    return _routes;
}

@end
