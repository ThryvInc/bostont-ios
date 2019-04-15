//
//  Station.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import <Foundation/Foundation.h>
@class Prediction, Route, MBTATrip;

@interface Station : NSObject
@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSMutableArray *routes;
@property (nonatomic, strong) NSMutableArray *stops;
@property (nonatomic, strong) NSMutableArray *mbtaPredictions;
@property (nonatomic, strong) NSMutableArray *predictions;
@property (nonatomic, strong) NSMutableArray *zeroPredictions;
@property (nonatomic, strong) NSMutableArray *onePredictions;

- (void)refresh:(void (^)())completion;
- (NSArray *)zeroPredictionsForRoute:(Route *)route;
- (NSArray *)onePredictionsForRoute:(Route *)route;
@end
