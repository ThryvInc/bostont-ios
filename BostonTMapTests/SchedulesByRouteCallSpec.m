//
//  SchedulesByRouteCallSpec.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/26/15.
//
//

#import "BaseNetworkCall.h"
#import "SchedulesByRouteCall.h"
#import "Route.h"
#import "OHHTTPStubs.h"
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

@interface BaseNetworkCall ()
- (NSURL *)url;
@end

SpecBegin(SchedulesByRouteCallSpec)

describe(@"Executing a call", ^{
    
    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });
    
    it(@"gets schedule data", ^{
        SchedulesByRouteCall *call = [[SchedulesByRouteCall alloc] init];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [call url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_e_sched.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        
        waitUntil(^(DoneCallback done) {
            [call executeWithCompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
                expect(error).to.beNil();
                done();
            }];
        });
    });
});

SpecEnd
