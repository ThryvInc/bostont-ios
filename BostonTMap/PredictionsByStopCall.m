//
//  PredictionsByStopCall.m
//  BostonTMap
//
//  Created by Elliot Schrock on 4/24/18.
//

#import "PredictionsByStopCall.h"
#import "NSDate+RelativeTime.h"

@implementation PredictionsByStopCall

- (NSString *)endpoint {
    return @"predictions";
}

- (NSString *)getParams {
    NSString *params = super.getParams;
    NSString *timeFilters = [self timeFilters];
    return [NSString stringWithFormat:@"%@&%@&include=trip,trip.shape,route&fields[shape]=name&", params, timeFilters];
}

- (NSString *)timeFilters {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm";
    NSString *nowString = [BaseNetworkCall timeStringFrom:[formatter stringFromDate:[NSDate date]]];
    NSString *laterString = [BaseNetworkCall timeStringFrom:[formatter stringFromDate:[[NSDate date] incrementUnit:NSMinuteCalendarUnit by:20]]];
    return [NSString stringWithFormat:@"filter[min_time]=%@&filter[max_time]=%@", nowString, laterString];
}

- (void)configure {
    [super configure];
    self.httpMethod = @"GET";
}

@end
