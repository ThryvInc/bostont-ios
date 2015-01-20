//
//  SubwayModel.m
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 11/13/12.
//
//

#import "SubwayModel.h"
#import "Trip.h"

@interface SubwayModel ()
@property (nonatomic) long time;
@end

@implementation SubwayModel
@synthesize time = _time;

@synthesize trips = _trips;
@synthesize line = _line;

-(id)initWithJson:(NSDictionary *)json
{
    if (json == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.line = [json objectForKey:@"Line"];
        //NSLog(@"%@",self.line);
        self.time = [self assignLongFromJson:json key:@"CurrentTime"];
        //NSLog(@"%ld",self.time);
        self.trips = [[NSMutableArray alloc]init];
        NSDictionary *array = [json objectForKey:@"Trips"];
        for (NSDictionary *dict in array) {
            BOOL added = NO;
            for (Trip *t in self.trips) {
                if ([[dict objectForKey:@"Destination"] isEqualToString:t.destination]) {
                    [t addPredictions:dict];
                    added = YES;
                }
            }
            if (!added) {
                Trip *trip = [[Trip alloc]initWithJson:dict andLine:self.line];
                [self.trips addObject:trip];
            }
        }
    }
    return self;
}

- (long) assignLongFromJson:(NSDictionary *)json key:(NSString *)key
{
    long value = 0;
    if ([json valueForKey:key] != [NSNull null]){
        NSNumber *n = [json valueForKey:key];
        value = [n longValue];
    }
    return value;
}
@end
