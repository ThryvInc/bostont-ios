//
//  MBTATrip.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTATrip.h"
#import "JSONAPIResourceDescriptor.h"
#import "MBTAShape.h"

@implementation MBTATrip

static JSONAPIResourceDescriptor *_descriptor = nil;

+ (JSONAPIResourceDescriptor*)descriptor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"trip"];
        
        [self addPropertiesTo:_descriptor];
    });
    
    return _descriptor;
}

+ (void)addPropertiesTo:(JSONAPIResourceDescriptor *)descriptor {
    [super addPropertiesTo:descriptor];
    [descriptor addProperty:@"headsign"];
    [descriptor addProperty:@"directionId" withJsonName:@"direction_id"];
    
    [descriptor hasOne:[MBTAShape class] withName:@"shape"];
}

@end
