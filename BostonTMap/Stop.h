//
//  Stop.h
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 11/13/12.
//
//

#import <Foundation/Foundation.h>

@interface Stop : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *times;

-(id)initWithJson:(NSDictionary *)json;
-(long)lowestEstimate;
@end
