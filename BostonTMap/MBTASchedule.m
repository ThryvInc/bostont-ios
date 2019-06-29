//
//  MBTASchedule.m
//  BostonTMap
//
//  Created by Elliot Schrock on 4/23/18.
//

#import "MBTASchedule.h"
#import "JSONAPIResourceDescriptor.h"

@implementation MBTASchedule

static JSONAPIResourceDescriptor *_descriptor = nil;

+ (JSONAPIResourceDescriptor*)descriptor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"schedule"];
        
        [self addPropertiesTo:_descriptor];
    });
    
    return _descriptor;
}


@end
