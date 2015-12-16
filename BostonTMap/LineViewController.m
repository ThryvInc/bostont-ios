//
//  LineViewController.m
//  BostonTMap
//
//  Created by Elliot Schrock on 5/10/15.
//
//

#import "LineViewController.h"
#import "Line.h"
#import "StationTableViewCell.h"

@interface LineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) StationTableViewCell *prototypeCell;

@end

static NSString * const CellIdentifier = @"Stop Cell";

@implementation LineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StationTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.line.stations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.prototypeCell.station = self.line.stations[indexPath.row];
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.station = self.line.stations[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - lazy loading

- (StationTableViewCell *)prototypeCell
{
    if (!_prototypeCell) _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return _prototypeCell;
}

@end
