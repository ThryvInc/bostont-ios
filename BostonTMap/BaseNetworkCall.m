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
    self.scheme = @"https";
    self.host = @"api-v3.mbta.com";
    self.baseRoute = @"/";
}

- (NSURL *)url
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@%@?%@api_key=%@", self.scheme, self.host, self.baseRoute, self.endpoint, self.getParams, [self getApiKey]]];
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
    return @"8dbaee39f9234bf6993aa11fb77c7431";
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

+ (NSString *)timeStringFrom:(NSString *)nowString {
    if ([nowString hasPrefix:@"00"]) {
        nowString = [NSString stringWithFormat:@"%@:%@",@"24", [nowString substringFromIndex:3]];
    }
    if ([nowString hasPrefix:@"01"]) {
        nowString = [NSString stringWithFormat:@"%@:%@",@"25", [nowString substringFromIndex:3]];
    }
    if ([nowString hasPrefix:@"02"]) {
        nowString = [NSString stringWithFormat:@"%@:%@",@"26", [nowString substringFromIndex:3]];
    }
    return nowString;
}

@end
