//
//  YSRetapViewController.h
//  YextRetapFramework
//
//  Created by Bryan Reed on 12/8/14.
//
//

#import <UIKit/UIKit.h>

@class YSRetapViewController;
@class YSLocationContext;

@protocol YSRetapViewControllerDelegate <NSObject>

@required

- (void)dismissRetap:(YSRetapViewController *)retapViewController;

@end


@interface YSRetapViewController : UIViewController

@property (nonatomic, weak) id<YSRetapViewControllerDelegate> delegate;
@property (readonly, nonatomic, strong) YSLocationContext *context;

@end
