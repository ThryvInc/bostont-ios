//
//  YSSignificantLocationChangeDelegate.h
//  YextRetapFramework
//
//  Created by Bryan Reed on 9/3/15.
//
//

#import <Foundation/Foundation.h>

@protocol YSSignificantLocationChangeDelegate <NSObject>

@required

- (BOOL) shouldStopMonitoringSignificantLocationChanges;

@end

