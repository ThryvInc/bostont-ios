//
//  ViewController.h
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 10/5/12.
//
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *subwayImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *subwayScrollView;
@property (strong, nonatomic) IBOutlet UIButton *schedulesButton;

@property ADBannerView *adView;
@property BOOL bannerIsVisible;
@end
