//
//  RouteCall.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "RouteCall.h"

@implementation RouteCall

- (void)setRoute:(NSString *)route
{
    self.getParams = [NSString stringWithFormat:@"route=%@&", route];
}

@end
