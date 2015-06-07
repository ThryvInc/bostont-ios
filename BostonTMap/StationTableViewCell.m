//
//  StationTableViewCell.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/22/15.
//
//

#import "StationTableViewCell.h"
#import "Station.h"
#import "RoutesTimesView.h"

@interface StationTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet RoutesTimesView *routesTimesView;

@end

@implementation StationTableViewCell

- (void)setStation:(Station *)station
{
    _station = station;
    [self setup];
}

- (void)setup
{
    self.nameLabel.text = self.station.stationName;
//    [self.nameLabel sizeToFit];
    self.routesTimesView.station = self.station;
}

@end
