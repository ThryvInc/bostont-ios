//
//  MBTAStopTripTimeHolder.h
//  BostonTMap
//
//  Created by Elliot Schrock on 4/23/18.
//

#import "MBTAModel.h"
@class MBTARoute, MBTATrip, MBTAStop;

@interface MBTAEstimate : MBTAModel
@property (nonatomic, strong) NSDate *predictionTime;
@property (nonatomic, strong) NSDate *arrivalTime;
@property (nonatomic, strong) NSDate *departureTime;

@property (nonatomic) MBTATrip *trip;
@property (nonatomic) MBTARoute *route;
@property (nonatomic) MBTAStop *stop;
@end
