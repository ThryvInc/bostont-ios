//
//  AdNavController.h
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 9/23/12.
//  Copyright (c) 2012 Elliot Schrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface AdNavController : UINavigationController

@property ADBannerView *adView;
@property BOOL bannerIsVisible;
@end
