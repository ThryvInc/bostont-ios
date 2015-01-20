//
//  Trip.m
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 11/13/12.
//
//

#import "Trip.h"
#import "Stop.h"

@implementation Trip
@synthesize stops = _stops;
@synthesize destination = _destination;
@synthesize line = _line;

-(id) initWithJson:(NSDictionary *)json andLine:(NSString *)line
{
    self = [super init];
    if (self) {
        self.line = line;
        self.destination = [json objectForKey:@"Destination"];
        [self addAllStops];
        NSDictionary *array = [json objectForKey:@"Predictions"];
        for (NSDictionary *dict in array) {
            Stop *stop = [[Stop alloc]initWithJson:dict];
            BOOL added = NO;
            for (Stop *s in self.stops) {
                if ([s.name isEqualToString:stop.name]) {
                    [s.times addObject:[stop.times objectAtIndex:0]];
                    added = YES;
                }
            }
            if (!added) {
                [self.stops addObject:stop];
            }
        }
    }
    return self;
}

-(NSString *)minEstimateForStop:(int)index
{
    Stop *stop = [self.stops objectAtIndex:index];
    NSString *result = @" ";
    if ([stop lowestEstimate] != LONG_MAX) {
        result = [NSString stringWithFormat:@"%ldm", [stop lowestEstimate]/60];
    }
    return result;
}

-(void)addPredictions:(NSDictionary *)json
{
    NSDictionary *array = [json objectForKey:@"Predictions"];
    for (NSDictionary *dict in array) {
        Stop *stop = [[Stop alloc]initWithJson:dict];
        BOOL added = NO;
        for (Stop *s in self.stops) {
            if ([s.name isEqualToString:stop.name]) {
                [s.times addObject:[stop.times objectAtIndex:0]];
                added = YES;
            }
        }
        if (!added) {
            [self.stops addObject:stop];
        }
    }
}

-(void)addAllStops
{
    NSArray *array;
    if ([self.line isEqualToString:@"Red"]) {
        if ([self.destination isEqualToString:@"Alewife"]) {
            array = [NSArray arrayWithObjects:@"Alewife",
                              @"Davis",
                              @"Porter Square",
                              @"Harvard Square",
                              @"Central Square",
                              @"Kendall/MIT",
                              @"Charles/MGH",
                              @"Park Street",
                              @"Downtown Crossing",
                              @"South Station",
                              @"Broadway",
                              @"Andrew",
                              @"JFK/UMass",
                              @"North Quincy",
                              @"Wollaston",
                              @"Quincy Center",
                              @"Quincy Adams",
                              @"Braintree",
                              @"Savin Hill",
                              @"Fields Corner",
                              @"Shawmut",
                              @"Ashmont", nil];
            
        }else if ([self.destination isEqualToString:@"Ashmont"]) {
            array = [NSArray arrayWithObjects:@"Alewife",
            @"Davis",
            @"Porter Square",
            @"Harvard Square",
            @"Central Square",
            @"Kendall/MIT",
            @"Charles/MGH",
            @"Park Street",
            @"Downtown Crossing",
            @"South Station",
            @"Broadway",
            @"Andrew",
            @"JFK/UMass",
            @"Savin Hill",
            @"Fields Corner",
            @"Shawmut",
            @"Ashmont", nil];
        }else if ([self.destination isEqualToString:@"Braintree"]) {
            array = [NSArray arrayWithObjects:@"Alewife",
            @"Davis",
            @"Porter Square",
            @"Harvard Square",
            @"Central Square",
            @"Kendall/MIT",
            @"Charles/MGH",
            @"Park Street",
            @"Downtown Crossing",
            @"South Station",
            @"Broadway",
            @"Andrew",
            @"JFK/UMass",
            @"North Quincy",
            @"Wollaston",
            @"Quincy Center",
            @"Quincy Adams",
            @"Braintree", nil];
        }
    }else if ([self.line isEqualToString:@"Blue"]) {
        array = [NSArray arrayWithObjects:@"Wonderland",
        @"Revere Beach",
        @"Beachmont",
        @"Suffolk Downs",
        @"Orient Heights",
        @"Wood Island",
        @"Airport",
        @"Maverick",
        @"Aquarium",
        @"State Street",
        @"Government Center",
        @"Bowdoin", nil];
    }else if ([self.line isEqualToString:@"Orange"]) {
        array = [NSArray arrayWithObjects:@"Oak Grove",
        @"Malden Center",
        @"Wellington",
        @"Sullivan",
        @"Community College",
        @"North Station",
        @"Haymarket",
        @"State Street",
        @"Downtown Crossing",
        @"Chinatown",
        @"Tufts Medical",
        @"Back Bay",
        @"Mass Ave",
        @"Ruggles",
        @"Roxbury Crossing",
        @"Jackson Square",
        @"Stony Brook",
        @"Green Street",
        @"Forest Hills", nil];
    }
    
    self.stops = [[NSMutableArray alloc]init];
    if ([self.destination isEqualToString:array.lastObject]) {
        for (NSString *s in array) {
            Stop *stop = [[Stop alloc] init];
            stop.name = s;
            [self.stops addObject:stop];
        }
    }else{
        for (int i = 0; i<array.count; i++) {
            NSString *s = [array objectAtIndex:(array.count - 1 - i)];
            Stop *stop = [[Stop alloc] init];
            stop.name = s;
            [self.stops addObject:stop];
        }
    }
}

@end
