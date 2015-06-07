//
//  MBTAStop.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTAPredictionObject.h"

@interface MBTAStop : MBTAPredictionObject
@property (nonatomic, strong) NSString *stopId;
@property (nonatomic, strong) NSString *parentName;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSArray *modes;
@end
