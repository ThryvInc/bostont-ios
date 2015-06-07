//
//  DummyLineDelegate.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/26/15.
//
//

#import "DummyLineDelegate.h"

@implementation DummyLineDelegate

- (void)lineLoaded:(Line *)line
{
    self.lineLoadedBlock(line);
}

@end
