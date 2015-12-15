//
//  YSLocationContext.h
//  YextRetapFramework
//
//  Created by Bryan Reed on 11/3/14.
//
//

#import <Foundation/Foundation.h>

extern NSString *const YSLocationContextDidChangeNotification;

@interface YSLocationContext : NSObject

@property (readonly, nonatomic, copy) NSNumber *yextLocationId;
@property (readonly, nonatomic, copy) NSString *partnerListingId;

@property (readonly, nonatomic, copy) NSString *locationName;

@property (readonly, nonatomic) BOOL isExpired;

// If you are implementing the tip view yourself you can use this to track whether or not the tip was closed by the user so you do not reshow it as the user navigates your app.
// If you are using YSRetapTipView, this property is set for you and you can choose to read it if you want the tip to stay closed until the user enters a different venue.
@property (nonatomic, assign) BOOL dismissedByUser;

@end
