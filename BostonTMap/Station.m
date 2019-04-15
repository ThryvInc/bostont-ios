//
//  Station.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "Station.h"
#import "MBTAStop.h"
#import "MBTAEstimate.h"
#import "MBTATrip.h"
#import "MBTAShape.h"
#import "MBTARoute.h"
#import "Prediction.h"
#import "Route.h"
#import "JSONAPI.h"
#import "PredictionsByStopCall.h"
#import "SchedulesByStopCall.h"

@implementation Station

- (NSArray *)zeroPredictionsForRoute:(Route *)route
{
    NSMutableArray *predictions = [[NSMutableArray alloc] init];
    for (Prediction *prediction in self.zeroPredictions){
        if ([prediction.route isEqual:route]) [predictions addObject:prediction];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    return [predictions sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray *)onePredictionsForRoute:(Route *)route
{
    NSMutableArray *predictions = [[NSMutableArray alloc] init];
    for (Prediction *prediction in self.onePredictions){
        if ([prediction.route isEqual:route]) [predictions addObject:prediction];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    return [predictions sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (void)refresh:(void (^)())completion {
    NSMutableArray *predictedRoutes = [NSMutableArray new];
    NSMutableArray *scheduledRoutes = [NSMutableArray new];
    for (Route *route in self.routes) {
        if (route.isPredictable) {
            [predictedRoutes addObject:route.mbtaRouteId];
        } else {
            [scheduledRoutes addObject:route.mbtaRouteId];
        }
    }
    
    __block int semaphore = (int)self.routes.count;
    
    self.routes = [NSMutableArray new];
    self.mbtaPredictions = [NSMutableArray new];
    self.predictions = [NSMutableArray new];
    self.zeroPredictions = [NSMutableArray new];
    self.onePredictions = [NSMutableArray new];
    
    void (^callback)(NSData *, NSURLResponse *, NSError *) = ^void(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && ((NSHTTPURLResponse *)response).statusCode < 300) {
            NSDictionary *jsonDict = [[BaseNetworkCall new] dataToJSON:data];
            JSONAPI *jsonApi = [JSONAPI jsonAPIWithDictionary:jsonDict];
            NSArray<MBTAEstimate *> *estimates = jsonApi.resources;
            
            for (MBTAEstimate *estimate in estimates) {
                [self.mbtaPredictions addObject:estimate];
                
                Prediction *prediction = [Prediction new];
                prediction.directionId = estimate.trip.directionId;
                prediction.date = estimate.predictionTime;
                MBTATrip *trip = estimate.trip;
                if ([trip.headsign.lowercaseString isEqualToString:@"ashmont"] || [trip.shape.name.lowercaseString isEqualToString:@"ashmont"]) {
                    prediction.route = [Route ashmont];
                } else if ([trip.headsign.lowercaseString isEqualToString:@"braintree"] || [trip.shape.name.lowercaseString isEqualToString:@"braintree"]) {
                    prediction.route = [Route braintree];
                } else {
                    continue;
                }
                
                if ([estimate.trip.directionId intValue] == 0) {
                    [self.zeroPredictions addObject:prediction];
                } else if ([estimate.trip.directionId intValue] == 1) {
                    [self.onePredictions addObject:prediction];
                }
                
                [self.predictions addObject:prediction];
            }
            
            semaphore--;
            if (semaphore == 0) {
                completion();
            }
        }
    };
    
    if (predictedRoutes.count) {
        PredictionsByStopCall *call = [PredictionsByStopCall new];
        [call configure];
        call.route = [predictedRoutes componentsJoinedByString:@","];
        call.stopId = self.stationId;
        [call executeWithCompletionBlock:callback];
    }
    
    if (scheduledRoutes.count) {
        SchedulesByStopCall *call = [SchedulesByStopCall new];
        [call configure];
        call.route = [scheduledRoutes componentsJoinedByString:@","];
        call.stopId = self.stationId;
        [call executeWithCompletionBlock:callback];
    }
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[Station class]]) return NO;
    
    Station *otherStation = object;
    
    return [otherStation.stationId isEqualToString:self.stationId];
}

#pragma mark - lazy loading

- (NSMutableArray *)stops
{
    if (!_stops) _stops = [[NSMutableArray alloc] init];
    return _stops;
}

- (NSMutableArray *)mbtaPredictions
{
    if (!_mbtaPredictions) _mbtaPredictions = [[NSMutableArray alloc] init];
    return _mbtaPredictions;
}

- (NSMutableArray *)zeroPredictions
{
    if (!_zeroPredictions) _zeroPredictions = [[NSMutableArray alloc] init];
    return _zeroPredictions;
}

- (NSMutableArray *)onePredictions
{
    if (!_onePredictions) _onePredictions = [[NSMutableArray alloc] init];
    return _onePredictions;
}

- (NSMutableArray *)predictions
{
    if (!_predictions) _predictions = [[NSMutableArray alloc] init];
    return _predictions;
}

- (NSMutableArray *)routes
{
    if (_routes.count == 0) {
        _routes = [NSMutableArray new];
        for (Prediction *prediction in self.predictions) {
            if (prediction.route) {
                if (![_routes containsObject:prediction.route]) {
                    [_routes addObject:prediction.route];
                }
            }
        }
    }
    return _routes;
}

@end
