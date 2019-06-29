//
//  MBTAModel.m
//  BostonTMap
//
//  Created by Elliot Schrock on 4/23/18.
//

#import "MBTAModel.h"
#import "JSONAPIResourceDescriptor.h"

@implementation MBTAModel

+ (void)addPropertiesTo:(JSONAPIResourceDescriptor *)descriptor {
//    [descriptor setIdProperty:@"modelId"];
}

- (NSString *)modelId {
    return super.ID;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    MBTAModel *other = object;
    
    return [other.modelId isEqualToString:self.modelId];
}

@end
