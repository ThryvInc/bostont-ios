//
//  StationTableViewCell.h
//  BostonTMap
//
//  Created by Elliot Schrock on 5/22/15.
//
//

#import <UIKit/UIKit.h>
@class Station;

@interface StationTableViewCell : UITableViewCell
@property (nonatomic, strong) Station *station;
@end
