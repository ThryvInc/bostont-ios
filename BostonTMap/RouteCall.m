//
//  RouteCall.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "RouteCall.h"

@implementation RouteCall

- (NSString *)getParams {
    return [NSString stringWithFormat:@"filter[route]=%@&", self.route];
}

@end
