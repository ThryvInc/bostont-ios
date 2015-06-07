//
//  MBTAPredictionObject.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/11/15.
//
//

#import <Mantle/Mantle.h>

@interface MBTAPredictionObject : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *prediction;

@end
