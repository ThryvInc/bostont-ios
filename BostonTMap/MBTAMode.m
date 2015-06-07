//
//  MBTAMode.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTAMode.h"
#import "MBTARoute.h"

@implementation MBTAMode

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"routes" : @"route",
             @"routeType" : @"route_type"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"routes"]) return [MTLJSONAdapter arrayTransformerWithModelClass:[MBTARoute class]];
    
    return nil;
}

@end
