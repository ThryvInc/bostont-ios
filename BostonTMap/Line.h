//
//  Line.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import <Foundation/Foundation.h>
@class Line, Route, Station;

@protocol LineDelegate <NSObject>
- (void)lineLoaded:(Line *)line;
@optional
- (void)line:(Line *)line errored:(NSError *)error;
@end

@interface Line : NSObject
@property (nonatomic, weak) NSObject<LineDelegate> *delegate;
@property (nonatomic, strong) NSArray<Route *> *routes;
@property (nonatomic, strong) NSMutableArray<Station *> *stations;

- (void)fetchRoutes;
@end
