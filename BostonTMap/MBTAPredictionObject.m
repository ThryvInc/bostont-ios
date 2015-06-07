//
//  MBTAPredictionObject.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/11/15.
//
//

#import "MBTAPredictionObject.h"

@implementation MBTAPredictionObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"prediction" : @"pre_away",
             @"departureTime" : @"sch_dep_dt"};
}

- (NSString *)prediction
{
    if (self.departureTime && !_prediction) {
        NSDate *now = [NSDate date];
        NSDate *depTime = [NSDate dateWithTimeIntervalSince1970:[self.departureTime longLongValue]];
        long predictionInSeconds = depTime.timeIntervalSince1970 - now.timeIntervalSince1970;
        _prediction = [NSString stringWithFormat:@"%ld", predictionInSeconds];
    }
    return _prediction;
}

@end
