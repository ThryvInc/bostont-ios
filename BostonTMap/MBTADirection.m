//
//  MBTADirection.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTADirection.h"
#import "MBTAStop.h"
#import "MBTATrip.h"

@implementation MBTADirection

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"directionName" : @"direction_name",
             @"stops" : @"stop",
             @"trips" : @"trip"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"stops"]) return [MTLJSONAdapter arrayTransformerWithModelClass:[MBTAStop class]];
    if ([key isEqualToString:@"trips"]) return [MTLJSONAdapter arrayTransformerWithModelClass:[MBTATrip class]];
    
    return nil;
}

@end
