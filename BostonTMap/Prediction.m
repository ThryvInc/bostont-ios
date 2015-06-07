//
//  Prediction.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "Prediction.h"

@implementation Prediction

+ (Prediction *)earliestPredictionInArray:(NSArray *)predictions
{
    Prediction *earliest;
    for (Prediction *prediction in predictions){
        if (!earliest || prediction.predictionInSeconds < earliest.predictionInSeconds) {
            earliest = prediction;
        }
    }
    return earliest;
}

+ (Prediction *)earliestPredictionInArray:(NSArray *)predictions oppositeDirectionOf:(Prediction *)firstPrediction
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"predictionInSeconds" ascending:YES];
    NSArray *sortedPredictions = [predictions sortedArrayUsingDescriptors:@[descriptor]];
    for (Prediction *prediction in sortedPredictions){
        if (![prediction.directionName isEqualToString:firstPrediction.directionName]) return prediction;
    }
    return nil;
}

@end
