//
//  StopsByRouteCall.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "StopsByRouteCall.h"

@implementation StopsByRouteCall

- (NSString *)endpoint
{
    return @"stopsbyroute";
}

- (void)configure
{
    [super configure];
    self.httpMethod = @"GET";
}

@end
