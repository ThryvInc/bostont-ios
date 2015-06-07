//
//  MBTAMode.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import <Mantle/Mantle.h>

@interface MBTAMode : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *routeType;
@property (nonatomic, strong) NSArray *routes;
@end
