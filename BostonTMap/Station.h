//
//  Station.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import <Foundation/Foundation.h>
@class Prediction;
@class Route;

@interface Station : NSObject
@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSMutableArray *routes;
@property (nonatomic, strong) NSMutableArray *stops;
@property (nonatomic, strong) NSMutableArray *predictions;

- (void)addPrediction:(Prediction *)prediction;
- (NSArray *)predictionsForRoute:(Route *)route;
@end
