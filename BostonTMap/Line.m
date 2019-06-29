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
#import "MBTAEstimate.h"
#import "MBTAPrediction.h"
#import "MBTASchedule.h"
#import "MBTARoute.h"
#import "MBTATrip.h"
#import "MBTAStop.h"
#import "MBTAShape.h"
#import "StopsByRouteCall.h"
#import "PredictionsByRouteCall.h"
#import "SchedulesByRouteCall.h"
#import "JSONAPI.h"
#import "JSONAPIResourceDescriptor.h"
#import "NSArray+Reverse.h"

@interface Line ()
@property (nonatomic) int requestSemaphore;
@property (nonatomic) int errorSemaphore;
@end

@implementation Line

- (void)fetchRoutes {
    self.errorSemaphore = 0;
    
    [self setupJsonApiBullshit];
    
    [self fetchStations];
}

- (void)setupJsonApiBullshit {
    [JSONAPIResourceDescriptor addResource:[MBTATrip class]];
    [JSONAPIResourceDescriptor addResource:[MBTAStop class]];
    [JSONAPIResourceDescriptor addResource:[MBTARoute class]];
    [JSONAPIResourceDescriptor addResource:[MBTAShape class]];
    [JSONAPIResourceDescriptor addResource:[MBTAPrediction class]];
    [JSONAPIResourceDescriptor addResource:[MBTASchedule class]];
}

- (void)fetchStations {
    NSMutableArray *mbtaRouteIds = [NSMutableArray new];
    for (Route *route in self.routes) {
        [mbtaRouteIds addObject:route.mbtaRouteId];
    }
    
    StopsByRouteCall *call = [[StopsByRouteCall alloc] init];
    [call configure];
    call.route = [mbtaRouteIds componentsJoinedByString:@","];
    [call executeWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && response && ((NSHTTPURLResponse *)response).statusCode < 300) {
            NSDictionary *jsonDict = [call dataToJSON:data];
            JSONAPI *jsonApi = [JSONAPI jsonAPIWithDictionary:jsonDict];
            NSArray *stops = jsonApi.resources;
            for (MBTAStop *stop in stops) {
                Station *station = [Station new];
                station.stationId = stop.modelId;
                station.stationName = stop.name;
                [self.stations addObject:station];
            }
            if (![self.routes.firstObject.mbtaRouteId hasPrefix:@"Red"]) {
                self.stations = [[self.stations reversedArray] mutableCopy];
            }
            [self fetchEstimates];
        }else{
#warning error
        }
    }];
}

- (void)fetchEstimates {
    for (Route *route in self.routes) {
        if (route.isPredictable) {
            [self fetchPredictionsForRoute:route];
        } else {
            [self fetchSchedulesForRoute:route];
        }
    }
}

- (void)fetchPredictionsForRoute:(Route *)route {
    self.requestSemaphore++;
    PredictionsByRouteCall *call = [[PredictionsByRouteCall alloc] init];
    [call configure];
    call.route = route.mbtaRouteId;
    [call executeWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && ((NSHTTPURLResponse *)response).statusCode < 300) {
            NSDictionary *jsonDict = [call dataToJSON:data];
            JSONAPI *jsonApi = [JSONAPI jsonAPIWithDictionary:jsonDict];
            NSArray<MBTAEstimate *> *predictions = jsonApi.resources;
            [self addEstimates:predictions toStations:self.stations];
            
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
            NSDictionary *jsonDict = [call dataToJSON:data];
            JSONAPI *jsonApi = [JSONAPI jsonAPIWithDictionary:jsonDict];
            NSArray<MBTAEstimate *> *schedules = jsonApi.resources;
            [self addEstimates:schedules toStations:self.stations];
            
            self.requestSemaphore--;
            if (!self.requestSemaphore) [self.delegate lineLoaded:self];
        }else{
#warning error
        }
    }];
}

- (void)addEstimates:(NSArray<MBTAEstimate *> *)estimates toStations:(NSArray<Station *> *)stations {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"predictionTime"
                                                                   ascending:YES];
    NSArray *sortedEstimates = [estimates sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    for (MBTAEstimate *estimate in sortedEstimates) {
        Station *station = [Station new];
        station.stationId = estimate.stop.parentStation.modelId;
        
        NSUInteger index = [stations indexOfObject:station];
        if (index != -1 && index < stations.count) {
            station = stations[index];
        } else {
            continue;
        }
        
        Prediction *prediction = [Prediction new];
        prediction.directionId = estimate.trip.directionId;
        prediction.date = estimate.predictionTime;
        if ([prediction.directionId intValue] == 1) {
            if ([station.stationId isEqualToString:@"place-qnctr"]) {
                NSLog(@"ruh roh");
            }
            if ([estimate.trip.shape.name.lowercaseString isEqualToString:@"ashmont"]) {
                prediction.route = [Route ashmont];
            } else if ([estimate.trip.shape.name.lowercaseString isEqualToString:@"braintree"]) {
                prediction.route = [Route braintree];
            } else {
                continue;
//                prediction.route = [Route routeFor:estimate.route.modelId];
            }
        } else {
            Route *route = [Route routeForHeadsign:estimate.trip.headsign];
            if (route) {
                prediction.route = route;
            } else {
                prediction.route = [Route routeFor:estimate.route.modelId];
            }
        }
        
        if ([estimate.trip.directionId intValue] == 0) {
            [station.zeroPredictions addObject:prediction];
        } else if ([estimate.trip.directionId intValue] == 1) {
            [station.onePredictions addObject:prediction];
        }
        
        if (![station.stops containsObject:estimate.stop]) [station.stops addObject:estimate.stop];
        [station.mbtaPredictions addObject:estimate];
        
        [station.predictions addObject:prediction];
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
