//
//  DaysViewController.m
//  AlarMock
//
//  Created by Patrick Hogan on 8/23/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "RepeatViewController.h"

static NSString * const kDaysCellIdentifier = @"DaysCell";

NSString * const kRepeatViewControllerIdentifier = @"daysVC";

@interface RepeatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RepeatViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // I see these everywhere.  What for?  Is this to get rid of lines?  Just curious?
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDaysCellIdentifier];
    cell.textLabel.text = [[RepeatViewController days] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Action handlers

-(IBAction)unwindToAddAlarmViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

#pragma mark - Static Accessors

+ (NSArray *)days
{
    static NSArray *days;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        days = [[NSArray alloc] initWithObjects:@"Monday",
                @"Tuesday",
                @"Wednesday",
                @"Thursday",
                @"Friday",
                @"Saturday",
                @"Sunday", nil];
        
    });

    return days;
}

@end
