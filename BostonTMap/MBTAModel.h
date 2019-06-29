//
//  MBTAModel.h
//  BostonTMap
//
//  Created by Elliot Schrock on 4/23/18.
//

#import <Foundation/Foundation.h>
#import "JSONAPIResourceBase.h"
@class JSONAPIResourceDescriptor;

@protocol MBTAModelProtocol
+ (void)addPropertiesTo:(JSONAPIResourceDescriptor *)descriptor;
@end

@interface MBTAModel : JSONAPIResourceBase <MBTAModelProtocol>
@property (nonatomic) NSString *modelId;
@end
