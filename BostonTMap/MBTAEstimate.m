//
//  MBTAStopTripTimeHolder.m
//  BostonTMap
//
//  Created by Elliot Schrock on 4/23/18.
//

#import "MBTAEstimate.h"
#import "JSONAPIResourceDescriptor.h"
#import "JSONAPIPropertyDescriptor.h"
#import "NSDateFormatter+JSONAPIDateFormatter.h"
#import "MBTATrip.h"
#import "MBTAStop.h"
#import "MBTARoute.h"

@implementation MBTAEstimate

+ (void)addPropertiesTo:(JSONAPIResourceDescriptor *)descriptor {
    [super addPropertiesTo:descriptor];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
    
    [dateFormatter setLocale: enUSPOSIXLocale];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    [descriptor addProperty:@"arrivalTime" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"arrival_time" withFormat:dateFormatter]];
    [descriptor addProperty:@"departureTime" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"departure_time" withFormat:dateFormatter]];
    
    [descriptor hasOne:[MBTARoute class] withName:@"route"];
    [descriptor hasOne:[MBTAStop class] withName:@"stop"];
    [descriptor hasOne:[MBTATrip class] withName:@"trip"];
}

- (NSDate *)predictionTime {
    if (_departureTime) return _departureTime;
    return _arrivalTime;
}

@end
