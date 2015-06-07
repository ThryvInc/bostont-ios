//
//  LineSpec.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/26/15.
//
//

#import "Line.h"
#import "DummyLineDelegate.h"
#import "OCMock.h"

#import "BaseNetworkCall.h"
#import "StopsByRouteCall.h"
#import "SchedulesByRouteCall.h"

#import "Route.h"
#import "Prediction.h"
#import "Station.h"

@import ObjectiveC;

#import "OHHTTPStubs.h"
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

@interface BaseNetworkCall ()
- (NSURL *)url;
@end

SpecBegin(LineSpec)

describe(@"Line", ^{
    
    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });
    
    it(@"gets scheduled stops for single route", ^{
        id mockDate = OCMClassMock([NSDate class]);
        [OCMStub([mockDate date]) andReturn:[NSDate dateWithTimeIntervalSince1970:1432664760]];
        
        DummyLineDelegate *delegate = [[DummyLineDelegate alloc] init];
        Line *line = [[Line alloc] init];
        line.delegate = delegate;
        line.routes = @[[Route greenB]];
        
        SchedulesByRouteCall *scheduleCall = [[SchedulesByRouteCall alloc] init];
        [scheduleCall configure];
        scheduleCall.route = [Route greenB].mbtaRouteId;
        StopsByRouteCall *stopsCall = [[StopsByRouteCall alloc] init];
        [stopsCall configure];
        stopsCall.route = [Route greenB].mbtaRouteId;
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [stopsCall url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_b_stops.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [scheduleCall url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_b_sched.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        
        waitUntil(^(DoneCallback done) {
            delegate.lineLoadedBlock = ^(Line *line){
                expect(line.stations.count).to.equal(28);
                if (line.stations.count){
                    Station *station = line.stations[4];
                    expect(station.predictions.count).toNot.equal(0);
                    if (station.predictions.count){
                        NSArray *predictionsForB = [station predictionsForRoute:[Route greenB]];
                        expect(predictionsForB.count).toNot.equal(0);
                        if (predictionsForB.count){
                            Prediction *prediction = [Prediction earliestPredictionInArray:predictionsForB];
                            expect(prediction).toNot.beNil();
                        }
                    }
                }
                done();
            };
            [line fetchRoutes];
        });
    });
    
    it(@"gets scheduled stops for multiple routes", ^{
        id mockDate = OCMClassMock([NSDate class]);
        [OCMStub([mockDate date]) andReturn:[NSDate dateWithTimeIntervalSince1970:1432664760]];
        
        DummyLineDelegate *delegate = [[DummyLineDelegate alloc] init];
        Line *line = [[Line alloc] init];
        line.delegate = delegate;
        line.routes = @[[Route greenB], [Route greenC], [Route greenD], [Route greenE]];
        
        SchedulesByRouteCall *scheduleCallB = [[SchedulesByRouteCall alloc] init];
        [scheduleCallB configure];
        scheduleCallB.route = [Route greenB].mbtaRouteId;
        SchedulesByRouteCall *scheduleCallC = [[SchedulesByRouteCall alloc] init];
        [scheduleCallC configure];
        scheduleCallC.route = [Route greenC].mbtaRouteId;
        SchedulesByRouteCall *scheduleCallD = [[SchedulesByRouteCall alloc] init];
        [scheduleCallD configure];
        scheduleCallD.route = [Route greenD].mbtaRouteId;
        SchedulesByRouteCall *scheduleCallE = [[SchedulesByRouteCall alloc] init];
        [scheduleCallE configure];
        scheduleCallE.route = [Route greenE].mbtaRouteId;
        
        StopsByRouteCall *stopsCallB = [[StopsByRouteCall alloc] init];
        [stopsCallB configure];
        stopsCallB.route = [Route greenB].mbtaRouteId;
        StopsByRouteCall *stopsCallC = [[StopsByRouteCall alloc] init];
        [stopsCallC configure];
        stopsCallC.route = [Route greenC].mbtaRouteId;
        StopsByRouteCall *stopsCallD = [[StopsByRouteCall alloc] init];
        [stopsCallD configure];
        stopsCallD.route = [Route greenD].mbtaRouteId;
        StopsByRouteCall *stopsCallE = [[StopsByRouteCall alloc] init];
        [stopsCallE configure];
        stopsCallE.route = [Route greenE].mbtaRouteId;
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [stopsCallB url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_b_stops.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [stopsCallC url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_c_stops.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [stopsCallD url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_d_stops.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [stopsCallE url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_e_stops.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [scheduleCallB url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_b_sched.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [scheduleCallC url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_c_sched.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [scheduleCallD url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_d_sched.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request){
            NSString *urlString = [scheduleCallE url].absoluteString;
            return [request.URL.absoluteString isEqualToString:urlString];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
            NSString *fixture = OHPathForFile(@"green_e_sched.json", self.class);
            return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:nil];
        }];
        
        waitUntil(^(DoneCallback done) {
            delegate.lineLoadedBlock = ^(Line *line){
                expect(line.stations.count).toNot.equal(0);
                if (line.stations.count){
                    Station *station = line.stations[4]; //Park Streed
                    expect(station.stationId).to.equal(@"place-pktrm");
                    expect(station.predictions.count).toNot.equal(0);
                    if (station.predictions.count){
                        NSArray *predictionsForB = [station predictionsForRoute:[Route greenB]];
                        expect(predictionsForB.count).toNot.equal(0);
                        if (predictionsForB.count){
                            Prediction *prediction = [Prediction earliestPredictionInArray:predictionsForB];
                            expect(prediction).toNot.beNil();
                        }
                        NSArray *predictionsForC = [station predictionsForRoute:[Route greenC]];
                        expect(predictionsForC.count).toNot.equal(0);
                        if (predictionsForC.count){
                            Prediction *prediction = [Prediction earliestPredictionInArray:predictionsForC];
                            expect(prediction).toNot.beNil();
                        }
                        NSArray *predictionsForD = [station predictionsForRoute:[Route greenD]];
                        expect(predictionsForD.count).toNot.equal(0);
                        if (predictionsForD.count){
                            Prediction *prediction = [Prediction earliestPredictionInArray:predictionsForD];
                            expect(prediction).toNot.beNil();
                        }
                        NSArray *predictionsForE = [station predictionsForRoute:[Route greenD]];
                        expect(predictionsForE.count).toNot.equal(0);
                        if (predictionsForE.count){
                            Prediction *prediction = [Prediction earliestPredictionInArray:predictionsForE];
                            expect(prediction).toNot.beNil();
                        }
                    }
                }
                done();
            };
            [line fetchRoutes];
        });
    });
});

SpecEnd
