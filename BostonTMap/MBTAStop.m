//
//  MBTAStop.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTAStop.h"
#import "MBTAMode.h"

@implementation MBTAStop

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *dict = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    [dict addEntriesFromDictionary:@{
                                     @"parentId" : @"parent_station",
                                     @"parentName" : @"parent_station_name",
                                     @"modes" : @"mode",
                                     @"stopId" : @"stop_id"
                                     }];
    return [dict copy];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"modes"]) return [MTLJSONAdapter arrayTransformerWithModelClass:[MBTAMode class]];
    
    return nil;
}

- (BOOL)isEqual:(id)object
{
    if ([object class] != [self class]) return NO;
    
    MBTAStop *otherStop = object;
    
    return [otherStop.stopId isEqualToString:self.stopId];
}

@end
