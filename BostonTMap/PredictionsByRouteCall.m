//
//  PredictionsByRouteCall.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "PredictionsByRouteCall.h"

@implementation PredictionsByRouteCall

- (NSString *)endpoint
{
    return @"predictionsbyroute";
}

- (void)configure
{
    [super configure];
    self.httpMethod = @"GET";
}

@end
