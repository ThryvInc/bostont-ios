//
//  MBTARoute.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import <Mantle/Mantle.h>

@interface MBTARoute : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSArray *directions;
@end
