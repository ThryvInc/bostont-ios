//
//  DummyLineDelegate.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/26/15.
//
//

#import "Line.h"

@interface DummyLineDelegate : NSObject<LineDelegate>
@property (nonatomic, strong) void (^lineLoadedBlock)(Line *line);
@end
