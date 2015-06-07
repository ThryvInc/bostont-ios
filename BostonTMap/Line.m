//
//  Line.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "Line.h"
#import "Route.h"
#import "Prediction.h"
#import "Station.h"
#import "MBTARoute.h"
#import "MBTADirection.h"
#import "MBTATrip.h"
#import "MBTAStop.h"
#import <Mantle/Mantle.h>
#import "StopsByRouteCall.h"
#import "PredictionsByRouteCall.h"
#import "SchedulesByRouteCall.h"

@interface Line ()
@property (nonatomic) int requestSemaphore;
@property (nonatomic) int errorSemaphore;
@end

@implementation Line

- (void)fetchRoutes
{
    self.errorSemaphore = 0;
    for (Route *route in self.routes) {
        [self fetchStopsForRoute:route];
    }
}

- (void)fetchStopsForRoute:(Route *)route
{
    StopsByRouteCall *call = [[StopsByRouteCall alloc] init];
    [call configure];
    call.route = route.mbtaRouteId;
    [call executeWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && response && ((NSHTTPURLResponse *)response).statusCode < 300) {
            NSDictionary *routeDict = [call dataToJSON:data];
            NSError *mantleError;
            MBTARoute *mbtaRoute = [MTLJSONAdapter modelOfClass:[MBTARoute class] fromJSONDictionary:routeDict error:&mantleError];
            for (MBTADirection *direction in mbtaRoute.directions){
                [self addStops:direction.stops toStationsInRoute:route withTripName:nil directionName:direction.directionName];
            }
            if (route.isPredictable) {
                [self fetchPredictionsForRoute:route];
            }else{
                [self fetchSchedulesForRoute:route];
            }
        }else{
#warning error
        }
    }];
}

- (void)fetchPredictionsForRoute:(Route *)route
{
    self.requestSemaphore++;
    PredictionsByRouteCall *call = [[PredictionsByRouteCall alloc] init];
    [call configure];
    call.route = route.mbtaRouteId;
    [call executeWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && ((NSHTTPURLResponse *)response).statusCode < 300) {
            NSDictionary *routeDict = [call dataToJSON:data];
            [self stopsFromTripsInMbtaRoute:routeDict forRoute:route];
            self.requestSemaphore--;
            if (!self.requestSemaphore) [self.delegate lineLoaded:self];
        }else{
#warning error
        }
    }];
}

- (void)fetchSchedulesForRoute:(Route *)route
{
    self.requestSemaphore++;
    SchedulesByRouteCall *call = [[SchedulesByRouteCall alloc] init];
    [call configure];
    call.route = route.mbtaRouteId;
    [call executeWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && ((NSHTTPURLResponse *)response).statusCode < 300) {
            NSLog(@"%li", (long)((NSHTTPURLResponse *)response).statusCode);
            NSDictionary *routeDict = [call dataToJSON:data];
            [self stopsFromTripsInMbtaRoute:routeDict forRoute:route];
            self.requestSemaphore--;
            if (!self.requestSemaphore) [self.delegate lineLoaded:self];
        }else{
#warning error
        }
    }];
}

- (void)stopsFromTripsInMbtaRoute:(NSDictionary *)routeDict forRoute:(Route *)route
{
    NSError *mantleError;
    MBTARoute *mbtaRoute = [MTLJSONAdapter modelOfClass:[MBTARoute class] fromJSONDictionary:routeDict error:&mantleError];
    for (MBTADirection *direction in mbtaRoute.directions){
        for (MBTATrip *trip in direction.trips){
            [self addStops:trip.stops toStationsInRoute:route withTripName:trip.name directionName:direction.directionName];
        }
    }
}

- (void)addStops:(NSArray *)stops toStationsInRoute:(Route *)route withTripName:(NSString *)tripName directionName:(NSString *)directionName
{
    for (MBTAStop *stop in stops){
        Prediction *prediction;
        if ([stop.prediction intValue]) {
            if (self.routes.count > 1) {
                if ([[NSString stringWithFormat:@"%@ ", tripName.lowercaseString] containsString:[NSString stringWithFormat:@" %@ ", route.routeId.lowercaseString]]) {
                    if ([stop.prediction intValue] > 0) {
                        prediction = [[Prediction alloc] init];
                        prediction.predictionInSeconds = [stop.prediction intValue];
                        prediction.route = route;
                        prediction.directionName = directionName;
                    }
                }
            }else{
                if ([stop.prediction intValue] > 0) {
                    prediction = [[Prediction alloc] init];
                    prediction.predictionInSeconds = [stop.prediction intValue];
                    prediction.route = route;
                    prediction.directionName = directionName;
                }
            }
        }
        
        if (stop.parentId && stop.parentName) {
            Station *station = [[Station alloc] init];
            station.stationId = stop.parentId;
            station.stationName = stop.parentName;
            [station.stops addObject:stop];
            if ([self.stations containsObject:station]) {
                Station *originalStation = [self.stations objectAtIndex:[self.stations indexOfObject:station]];
                if (![originalStation.stops containsObject:stop]) {
                    [originalStation.stops addObject:stop];
                    if (prediction) [originalStation addPrediction:prediction];
                }
            }else{
                if (prediction) [station addPrediction:prediction];
                
                [self.stations addObject:station];
            }
        }else if (prediction){
            for (Station *station in self.stations){
                if ([station.stops containsObject:stop]) {
                    [station addPrediction:prediction];
                }
            }
        }
    }
}

#pragma mark - lazy loading

- (NSMutableArray *)stations
{
    if (!_stations) _stations = [[NSMutableArray alloc] init];
    return _stations;
}

- (NSArray *)routes
{
    if (!_routes) _routes = [[NSArray alloc] init];
    return _routes;
}

@end
