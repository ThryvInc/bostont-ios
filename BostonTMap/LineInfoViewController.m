//
//  LineInfoViewController.m
//  BostonTMap
//
//  Created by Ellidi Jatgeirsson on 11/12/12.
//
//

#import "LineInfoViewController.h"
#import "Trip.h"
#import "Stop.h"

@interface LineInfoViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *stopArray;
@property (nonatomic, strong) NSArray *redAsh;
@property (nonatomic, strong) NSArray *redBrain;
@property (nonatomic) int line;
@end

@implementation LineInfoViewController
UIAlertView *loadingAlert;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.model.line;
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.trips.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectZero];
    title.text = [NSString stringWithFormat:@"   To %@",((Trip *)[self.model.trips objectAtIndex:section]).destination];
    UIColor *color;
    if ([self.model.line isEqualToString:@"Red"]) {
        color = [UIColor redColor];
    }
    if ([self.model.line isEqualToString:@"Blue"]) {
        color = [UIColor blueColor];
    }
    if ([self.model.line isEqualToString:@"Orange"]) {
        color = [UIColor orangeColor];
    }
    title.backgroundColor = color;
    title.textColor = [UIColor whiteColor];
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((Trip *)[self.model.trips objectAtIndex:section]).stops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Stop Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = ((Stop *)[((Trip *)[self.model.trips objectAtIndex:indexPath.section]).stops objectAtIndex:indexPath.row]).name;
    cell.detailTextLabel.text = [((Trip *)[self.model.trips objectAtIndex:indexPath.section]) minEstimateForStop:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
