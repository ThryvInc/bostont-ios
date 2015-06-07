//
//  Route.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "Route.h"

@implementation Route

+ (Route *)ashmont
{
    return [[Route alloc] initWithId:@"Ashmont" mbtaId:@"Red" name:@"ASHMONT" color:[UIColor redColor] predictability:YES];
}

+ (Route *)braintree
{
    return [[Route alloc] initWithId:@"Braintree" mbtaId:@"Red" name:@"BRAINTREE" color:[UIColor redColor] predictability:YES];
}

+ (Route *)orange
{
    return [[Route alloc] initWithId:@"Orange" mbtaId:@"Orange" name:@"ORANGE" color:[UIColor orangeColor] predictability:YES];
}

+ (Route *)blue
{
    return [[Route alloc] initWithId:@"Blue" mbtaId:@"Blue" name:@"BLUE LINE" color:[UIColor blueColor] predictability:YES];
}

+ (Route *)greenB
{
    return [[Route alloc] initWithId:@"Boston College" mbtaId:@"Green-B" name:@"B LINE" color:[UIColor colorWithRed:0 green:200.f/255.f blue:0 alpha:1] predictability:NO];
}

+ (Route *)greenC
{
    return [[Route alloc] initWithId:@"Cleveland" mbtaId:@"Green-C" name:@"C LINE" color:[UIColor colorWithRed:0 green:200.f/255.f blue:0 alpha:1] predictability:NO];
}

+ (Route *)greenD
{
    return [[Route alloc] initWithId:@"Riverside" mbtaId:@"Green-D" name:@"D LINE" color:[UIColor colorWithRed:0 green:200.f/255.f blue:0 alpha:1] predictability:NO];
}

+ (Route *)greenE
{
    return [[Route alloc] initWithId:@"Heath" mbtaId:@"Green-E" name:@"E LINE" color:[UIColor colorWithRed:0 green:200.f/255.f blue:0 alpha:1] predictability:NO];
}

- (instancetype)initWithId:(NSString *)routeId mbtaId:(NSString *)mbtaRouteId name:(NSString *)routeName color:(UIColor *)color predictability:(BOOL)isPredictable
{
    self = [super init];
    if (self) {
        self.routeId = routeId;
        self.routeName = routeName;
        self.mbtaRouteId = mbtaRouteId;
        self.color = color;
        self.isPredictable = isPredictable;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object class] != [self class]) return NO;
    Route *otherRoute = object;
    return [otherRoute.routeId isEqualToString:self.routeId];
}

@end
