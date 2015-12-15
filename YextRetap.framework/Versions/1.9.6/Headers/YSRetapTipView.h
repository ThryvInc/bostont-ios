//
//  YSRetapTipView.h
//
//  Created by Bryan Reed on 3/25/15.
//  Copyright (c) 2015 Yext. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YSLocationContext;
@class UIViewController;

typedef NS_ENUM(NSInteger, YSRetapTipViewAnimationType) {
    YSRetapTipViewAnimationTypeSlide,
    YSRetapTipViewAnimationTypeFade
};

typedef NS_ENUM(NSInteger, YSRetapTipViewPosition) {
    YSRetapTipViewPositionTop,
    YSRetapTipViewPositionBottom
};

extern NSString *const YSRetapTipWillShowNotification;
extern NSString *const YSRetapTipDidDismissNotification;

/** --------------------------------------------------------------------------------------------------
 YSRetapTipView does not support being presented directly in a UITableViewController.  Calling
 presentFromViewController: and sending an instance of type UITableViewController will not display any
 tip view.  Present instead using the UITableViewController's navigationController or see the SDK
 documentation for other workarounds.
-------------------------------------------------------------------------------------------------- **/

@interface YSRetapTipView : UIView

// Controls where in the provided view controller's view this view will appear when presented
@property (nonatomic, assign) YSRetapTipViewPosition position; // Default: YSRetapTipeViewPositionTop

// Specifies the maximum height the tip view can grow for each interface orientation to
// accomodate long location names - if a larger view is needed, the text will be truncated.
@property (nonatomic, assign) NSUInteger maxHeightPortrait; // Default: 110
@property (nonatomic, assign) NSUInteger maxHeightLandscape; // Default: 80

// If set to YES, tip height will not grow or shrink to accomodate text
@property (nonatomic, assign) BOOL fixedHeight;

// This will offset the tip view from the (top or bottom).  Normally there will be no offset, unless
// the presentingViewController is a UINavigationController or UITabBarController, where, if no offset
// is specified, the default bar height will be used for an offset
@property (nonatomic, assign) NSInteger verticalOffsetOverride; // Default:0

// Spacing between the edge of the tip view and the label / button subviews
@property (nonatomic, assign) NSUInteger margin; // Default: 10

// Length of each of the square close button's sides that will be filled with a drawn X
@property (nonatomic, assign) NSUInteger closeButtonLength; // Default: 20

// Margin around the close button's drawn X.  Increasing this will allow you to
// increase the size of the button's tap target without increasing the size of the X.
@property (nonatomic, assign) NSUInteger closeButtonMargin; // Default: 10

// The method and time lengths in which the view is animated in and out of its superview
@property (nonatomic, assign) YSRetapTipViewAnimationType animationType; // Default: YSRetapTipViewAnimationTypeSlide
@property (nonatomic, assign) NSTimeInterval animateInLength; // Default: 0.6
@property (nonatomic, assign) NSTimeInterval animateOutLength; // Default: 0.3

// Fonts and colors for the two sections of the view's label
@property (nonatomic, copy) UIFont *promptFont; // Default: Helvetica Light, size 15
@property (nonatomic, copy) NSString *locationNameFontName; // Default: Helvetica Light
@property (nonatomic, assign) NSUInteger locationNameMaxFontSize; // Default: 23
@property (nonatomic, assign) NSUInteger locationNameMinFontSize; // Default: 20
@property (nonatomic, copy) UIColor *promptColor; // Default: White
@property (nonatomic, copy) UIColor *locationNameColor; // Default: App's tint color ?: White

// Color of the drawn X in the close button
@property (nonatomic, copy) UIColor *closeButtonColor; // Default: White

// The alpha and background colors of this view have the default values of 

/*
 *  initWithContext:
 *
 *  Discussion:
 *      Initializes the view with the context and default display settings.  None of the actual subviews
 *      are created yet as the user may specify different display settings before the present method is called.
 */
- (id)initWithContext:(YSLocationContext *)context;

/*
 *  presentFromViewController:
 *
 *  Discussion:
 *      Uses the current display settings to instantiate, arrange, and style the view's subviews, the arrange within this
 *      view, before adding this view to the provided presentingViewController's view hierarchy and animating itself into view
 */
- (void)presentFromViewController:(UIViewController *)presentingViewController;

/*
 *  presentFromViewController:
 *  animated:
 *  Discussion:
 *      Uses the current display settings to instantiate, arrange, and style the view's subviews, the arrange within this
 *      view, before adding this view to the provided presentingViewController's view hierarchy and animating itself into view
 *      if animated is set to YES
 */
- (void)presentFromViewController:(UIViewController *)presentingViewController animated:(BOOL)animated;

/*
 *  presentGloballyWithAnimation:
 *  Discussion:
 *      Uses the current display settings to instantiate, arrange, and style the view's subviews, then arrange within this
 *      view, before adding this view to a newly created UIWindow (with windowLevel UIWindowLevelStatusBar)  and animating
 *      itself into view if animated is set to YES.  Note that presenting this way does NOT work with apps that support
 *      landscape orientation.  The tip view will not be shown if the current interface orientation is landscape, and will
 *      automatically be removed if the interface orientation rotates to a landscape orientation.  The window will use the
 *      application's current root view controller as its root view controller when this method is called.
 */
- (void)presentGloballyWithAnimation:(BOOL)animated;

/*
 *  dismiss
 *
 *  Discussion:
 *      Removes this view from the superview's hierarchy with animation.
 */
- (void)dismiss;

/*
 *  dismissWithAnimated:
 *
 *  Discussion:
 *      Removes this view from the superview's hierarchy, with animation if specified.
 */
- (void)dismissWithAnimated:(BOOL)animated;

@end
