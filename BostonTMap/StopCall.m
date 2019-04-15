//
//  StopCall.m
//  BostonTMap
//
//  Created by Elliot Schrock on 4/23/18.
//

#import "StopCall.h"
#import "JSONAPI.h"

@implementation StopCall

- (NSString *)getParams {
    return [NSString stringWithFormat:@"filter[stop]=%@&%@", self.stopId, [super getParams]];
}

@end
