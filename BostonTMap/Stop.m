//
//  Stop.m
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 11/13/12.
//
//

#import "Stop.h"

@implementation Stop
@synthesize name = _name;
@synthesize times = _times;

-(id)init
{
    self = [super init];
    if (self) {
        self.times = [[NSMutableArray alloc]init];
    }
    return self;
}

-(id)initWithJson:(NSDictionary *)json
{
    self = [self init];
    if (self) {
        self.name = [json objectForKey:@"Stop"];
        [self.times addObject:[json objectForKey:@"Seconds"]];
    }
    return self;
}

-(long)lowestEstimate
{
    long min = LONG_MAX;
    for (int i = 0; i<self.times.count; i++) {
        if ([((NSNumber *)[self.times objectAtIndex:i]) longValue] < min) {
            min = [((NSNumber *)[self.times objectAtIndex:i]) longValue];
        }
    }
    return min;
}

@end
