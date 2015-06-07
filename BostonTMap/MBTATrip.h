//
//  MBTATrip.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTAPredictionObject.h"

@interface MBTATrip : MBTAPredictionObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *stops;
@end
