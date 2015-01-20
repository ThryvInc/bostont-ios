//
//  LineInfoViewController.h
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 11/12/12.
//
//

#import <UIKit/UIKit.h>
#import "SubwayModel.h"

#define RED_LINE 1
#define BLUE_LINE 2
#define ORANGE_LINE 3

@interface LineInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SubwayModel *model;

@end
