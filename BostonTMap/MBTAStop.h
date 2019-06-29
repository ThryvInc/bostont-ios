//
//  MBTAStop.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "MBTAModel.h"

@interface MBTAStop : MBTAModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) MBTAStop *parentStation;
@end
