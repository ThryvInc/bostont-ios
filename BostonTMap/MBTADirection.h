//
//  MBTADirection.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import <Mantle/Mantle.h>

@interface MBTADirection : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *directionName;
@property (nonatomic, strong) NSArray *stops;
@property (nonatomic, strong) NSArray *trips;
@end
