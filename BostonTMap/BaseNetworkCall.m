//
//  BaseNetworkCall.h
//
//  Created by Elliot Schrock on 4/13/14.
//  Copyright (c) 2014 Elliot Schrock. All rights reserved.
//

#import "BaseNetworkCall.h"

@interface BaseNetworkCall ()
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *baseRoute;

@end

@implementation BaseNetworkCall

- (void)configure
{
    self.scheme = @"http";
    self.host = @"realtime.mbta.com";
    self.baseRoute = @"/developer/api/v2/";
}

- (NSURL *)url
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@%@?%@format=json&api_key=%@", self.scheme, self.host, self.baseRoute, self.endpoint, self.getParams, [self getApiKey]]];
}

- (void)executeWithCompletionBlock:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self url]];
    request.HTTPMethod = self.httpMethod;

    if (self.httpMethod && ![self.httpMethod isEqualToString:@"GET"]) {
        request.HTTPBody = self.postData;
    }
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) NSLog(@"%@", error.debugDescription);
            completionBlock(data, response, error);
        });
    }] resume];
}

- (NSString *)getApiKey
{
    return @"rBlHmm4UkU26TEb0wZjwWQ";
}

- (NSDictionary *)dataToJSON:(NSData *)data
{
    NSError *e;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
    if (e) {
        NSLog(@"%@", e.debugDescription);
    }
    return json;
}

@end