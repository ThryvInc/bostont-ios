//
//  StopCall.h
//  BostonTMap
//
//  Created by Elliot Schrock on 4/23/18.
//

#import "RouteCall.h"

@protocol StopCallDelegate <NSObject>
- (void)onStopCallSuccess:(NSArray *)responseArray;
- (void)onStopCallFailed;
@end

@interface StopCall : RouteCall
@property (nonatomic, weak) NSObject<StopCallDelegate> *delegate;
@property (nonatomic, strong) NSString *stopId;
@end
