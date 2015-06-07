//
//  SchedulesByRouteCall.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "SchedulesByRouteCall.h"

@implementation SchedulesByRouteCall

- (NSString *)endpoint
{
    return @"schedulebyroute";
}

- (void)configure
{
    [super configure];
    self.httpMethod = @"GET";
}

@end
