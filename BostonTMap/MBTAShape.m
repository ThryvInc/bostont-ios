//
//  MBTAShape.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/8/18.
//

#import "MBTAShape.h"
#import "JSONAPIResourceDescriptor.h"
#import "JSONAPIPropertyDescriptor.h"

@implementation MBTAShape

static JSONAPIResourceDescriptor *_descriptor = nil;

+ (JSONAPIResourceDescriptor*)descriptor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"shape"];
        
        [self addPropertiesTo:_descriptor];
    });
    
    return _descriptor;
}

+ (void)addPropertiesTo:(JSONAPIResourceDescriptor *)descriptor {
    [super addPropertiesTo:descriptor];
    [descriptor addProperty:@"name"];
}

@end
