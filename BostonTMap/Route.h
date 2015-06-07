//
//  Route.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import <UIKit/UIKit.h>

@interface Route : NSObject
@property (nonatomic, strong) NSString *routeId;
@property (nonatomic, strong) NSString *mbtaRouteId;
@property (nonatomic, strong) NSString *routeName;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) BOOL isPredictable;

+ (Route *)ashmont;
+ (Route *)braintree;
+ (Route *)orange;
+ (Route *)blue;
+ (Route *)greenB;
+ (Route *)greenC;
+ (Route *)greenD;
+ (Route *)greenE;
@end
