//
//  BaseNetworkCall.h
//
//  Created by Elliot Schrock on 4/13/14.
//  Copyright (c) 2014 Elliot Schrock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetworkCall : NSObject
@property (nonatomic, strong) NSString *httpMethod;
@property (nonatomic, strong) NSString *endpoint;
@property (nonatomic, strong) NSString *getParams;
@property (nonatomic, strong) NSData *postData;

- (void)executeWithCompletionBlock:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock;
- (void)configure;
- (NSDictionary *)dataToJSON:(NSData *)data;
- (NSString *)getApiKey;
@end
