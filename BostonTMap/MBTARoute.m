//
//  MBTARoute.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTARoute.h"
#import "JSONAPIResourceDescriptor.h"
#import "JSONAPIPropertyDescriptor.h"

@implementation MBTARoute

static JSONAPIResourceDescriptor *_descriptor = nil;

+ (JSONAPIResourceDescriptor*)descriptor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"route"];
        
        [self addPropertiesTo:_descriptor];
    });
    
    return _descriptor;
}

@end
