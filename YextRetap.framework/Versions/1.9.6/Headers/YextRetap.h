//
//  YextRetap.h
//
//  Copyright (c) 2014 Yext. All rights reserved.
//

#import "YSLocationContext.h"
#import "YSRetapViewController.h"
#import "YSRetapTipView.h"
#import "YSSignificantLocationChangeDelegate.h"
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class YextRetap;
@class YSRetapViewController;

@protocol YSRetapDelegate <NSObject>

@optional

- (void)retapWillShow:(YextRetap *)retap forLocationContext:(YSLocationContext*)context;
- (void)retapDidClose:(YextRetap *)retap forLocationContext:(YSLocationContext*)context;

// Implement this to have a custom integration with the ReTap view controller instead of a full screen overlay.
- (void)retap:(YextRetap *)retap showViewController:(YSRetapViewController *)retapViewController;

- (void)retap:(YextRetap *)retap enteredLocation:(YSLocationContext *)context;
- (void)retap:(YextRetap *)retap exitedLocation:(YSLocationContext *)context;

@end

extern NSString *const YextRetapEnteredLocationNotification;
extern NSString *const YextRetapExitedLocationNotification;
extern NSString *const YextRetapWillShowNotification;
extern NSString *const YextRetapDidCloseNotification;
extern NSString *const YextRetapDisabledNotification;
extern NSString *const YextRetapEnabledNotification;

@interface YextRetap : NSObject

@property (nonatomic, weak) id<YSRetapDelegate> delegate;
@property (nonatomic, weak) id<YSSignificantLocationChangeDelegate> significantLocationChangeDelegate;
@property (nonatomic, readonly) YSLocationContext *locationContext;

/*
 *  enabled
 *
 *  Discussion:
 *      Value representing whether or not the SDK is enabled, changed by calling enable or disable on 
 *      this class's sharedInstance.  Useful if you need to set the initial state of UI that provides
 *      the user a way to opt in or opt out of the service.
 *
 *      Note: This value does not necessarily mean the Xone SDK should be running, there are
 *      additional runtime considerations that may prevent the SDK from operating.
 */
@property (nonatomic, readonly) BOOL enabled;

+ (YextRetap *)sharedInstance;

/*
 *  initializeWithAppId:
 *  productionMode:
 *
 *  Discussion:
 *      Overload of initializeWithAppId:productionMode:deferAskPermissions:, sending NO to the
 *      deferAskPermissions parameter
 */
- (void)initializeWithAppId:(NSString *)appId
             productionMode:(BOOL)isProduction;

/*
 *  initializeWithAppId:
 *  productionMode:
 *  deferAskPermissions:
 *
 *  Discussion:
 *      Initializes the SDK. appID is the Yext-provided App ID for this app. isProduction should be set to YES
 *      for release builds and NO for development builds. This affects whether the backend services log debug
 *      metrics to use for the testing app.  If you pass YES to deferAskPermissions you must call
 *      askForPermissionsIfNeeded: when it is appropriate to have the SDK ask the user for
 *      location services permissions
 */
- (void)initializeWithAppId:(NSString *)appId
             productionMode:(BOOL)isProduction
        deferAskPermissions:(BOOL)deferAskPermissions;

/*
 *  askForPermissionsIfNeeded
 *
 *  Discussion:
 *      This will cause the SDK to prompt the user for location services permissions.  This only needs to be
 *      called if you passed YES to the deferAskPermissions paramater of the initialize method.  If the user
 *      has already responded to a permissions request this will not do anything and return NO, otherwise this
 *      will return YES.
 */
- (BOOL)askForPermissionsIfNeeded;

/*
 *  showRetapWithContext:(YSLocationContext *)context fromViewController:
 *
 *  Discussion:
 *      Call this method when a user taps the tip alert if you are using a custom in-app tip.
 *      The SDK will display a view controller modally from the specified view controller
 */
- (void)showRetapWithContext:(YSLocationContext *)context fromViewController:(UIViewController *)parentViewController;

/*
 *  showRetapWithContext:(YSLocationContext *)context
 *
 *  Discussion:
 *      Call this method when a user taps the tip alert if you are using a custom in-app tip.
 *      It is preferred that the parent view controller be specified when calling
 *      showRetapWithContext:, but if one is not provided the Retap SDK will attempt to
 *      determine on its own which active view controller is the appropriate parent view controller
 */
- (void)showRetapWithContext:(YSLocationContext *)context;

/*
 *  disable
 *
 *  Discussion:
 *      Disables the SDK completely.
 */
- (void)disable;

/*
 *  enable
 *
 *  Discussion:
 *      Re-enables SDK functionality.  Note: There might be internal conditions that prevent
 *      SDK functionality from resuming, even if this is explicitly called.
 */
- (void)enable;

@end
