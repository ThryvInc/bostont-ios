//
//  MBTATrip.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTAModel.h"
@class MBTAShape;

@interface MBTATrip : MBTAModel
@property (nonatomic, strong) NSString *headsign;
@property (nonatomic, strong) NSNumber *directionId;
@property (nonatomic, strong) MBTAShape *shape;
@end
