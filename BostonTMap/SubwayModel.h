//
//  SubwayModel.h
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 11/13/12.
//
//

#import <Foundation/Foundation.h>

@interface SubwayModel : NSObject
@property (nonatomic, strong) NSString *line;
@property (nonatomic, strong) NSMutableArray *trips;

-(id)initWithJson:(NSDictionary *)json;

@end
