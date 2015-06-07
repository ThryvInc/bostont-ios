//
//  MBTATrip.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTATrip.h"
#import "MBTAStop.h"

@implementation MBTATrip

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *dict = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    [dict addEntriesFromDictionary:@{
                                     @"name" : @"trip_name",
                                     @"stops" : @"stop"
                                     }];
    return [dict copy];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"stops"]) return [MTLJSONAdapter arrayTransformerWithModelClass:[MBTAStop class]];
    
    return nil;
}

@end
