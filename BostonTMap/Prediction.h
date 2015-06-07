//
//  Prediction.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import <Foundation/Foundation.h>
@class Route;

@interface Prediction : NSObject
@property (nonatomic) int predictionInSeconds;
@property (nonatomic, strong) NSString *directionName;
@property (nonatomic, strong) Route *route;

+ (Prediction *)earliestPredictionInArray:(NSArray *)predictions;
+ (Prediction *)earliestPredictionInArray:(NSArray *)predictions oppositeDirectionOf:(Prediction *)prediction;
@end
