//
//  MBTAStop.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTAStop.h"
#import "JSONAPIResourceDescriptor.h"

@implementation MBTAStop

static JSONAPIResourceDescriptor *_descriptor = nil;

+ (JSONAPIResourceDescriptor*)descriptor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"stop"];
        
        [self addPropertiesTo:_descriptor];
    });
    
    return _descriptor;
}

+ (void)addPropertiesTo:(JSONAPIResourceDescriptor *)descriptor {
    [super addPropertiesTo:descriptor];
    [descriptor addProperty:@"name"];
    [descriptor hasOne:[MBTAStop class] withName:@"parentStation" withJsonName:@"parent_station"];
}


@end
