//
//  UIImage+Colorize.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/25/15.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Colorize)
+(UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point;
- (UIImage *)imageWithOverlayColor:(UIColor *)color;
+ (UIImage *)getImageWithTintedColor:(UIImage *)image withTint:(UIColor *)color withIntensity:(float)alpha;
+ (UIImage *)image:(UIImage *)img withColor:(UIColor *)color;
@end
