//
//  Trip.h
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 11/13/12.
//
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject
@property (nonatomic, strong) NSMutableArray *stops;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) NSString *line;

-(id)initWithJson:(NSDictionary *)json andLine:(NSString *)line;
-(void)addPredictions:(NSDictionary *)json;
-(NSString *)minEstimateForStop:(int)index;
@end
