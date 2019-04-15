//
//  MBTAPredictionObject.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/11/15.
//
//

#import "MBTAPrediction.h"
#import "JSONAPIResourceDescriptor.h"

@implementation MBTAPrediction

static JSONAPIResourceDescriptor *_descriptor = nil;

+ (JSONAPIResourceDescriptor*)descriptor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"prediction"];
        
        [self addPropertiesTo:_descriptor];
    });
    
    return _descriptor;
}

+ (void)addPropertiesTo:(JSONAPIResourceDescriptor *)descriptor {
    [super addPropertiesTo:descriptor];
    [descriptor addProperty:@"status"];
}


@end
