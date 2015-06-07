//
//  MBTAPredictionObjectSpec.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/26/15.
//
//

#import "MBTAPredictionObject.h"
#import "DummyLineDelegate.h"
#import "OCMock.h"

#import <Mantle/Mantle.h>

@import ObjectiveC;

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(MBTAPredictionObjectSpec)

describe(@"The Prediction Object", ^{
    
    it(@"can be created from json", ^{
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"mbta_prediction_object" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *jsonError;
        NSDictionary *stopDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        expect(jsonError).to.beNil();
        NSError *mantleError;
        MBTAPredictionObject *stop = [MTLJSONAdapter modelOfClass:[MBTAPredictionObject class] fromJSONDictionary:stopDict error:&mantleError];
        expect(stop).toNot.beNil();
    });
    
    it(@"can get prediction from dep time", ^{
        NSError *jsonError;
        NSDictionary *stopDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"mbta_prediction_object" ofType:@"json"]]
                                                                 options:NSJSONReadingAllowFragments error:&jsonError];
        expect(jsonError).to.beNil();
        
        id mockDate = OCMClassMock([NSDate class]);
        [OCMStub([mockDate date]) andReturn:[NSDate dateWithTimeIntervalSince1970:1432664760]];
        
        NSError *mantleError;
        MBTAPredictionObject *stop = [MTLJSONAdapter modelOfClass:[MBTAPredictionObject class] fromJSONDictionary:stopDict error:&mantleError];
        expect([stop.prediction intValue] > 0).to.beTruthy();
    });
});

SpecEnd
