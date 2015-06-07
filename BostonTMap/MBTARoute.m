//
//  MBTARoute.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTARoute.h"
#import "MBTADirection.h"

@implementation MBTARoute

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"directions" : @"direction"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"directions"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:[MBTADirection class]];
    }
    return nil;
}

@end
