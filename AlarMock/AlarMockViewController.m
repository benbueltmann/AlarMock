//
//  ViewController.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/22/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AlarMockViewController.h"

#import "AddAlarmViewController.h"
#import "Alarm.h"
#import "AlarmEngine.h"
#import "AlarMockTableViewCell.h"
#import "AlarMockView.h"
#import "AMColor.h"
#import "AMFont.h"
#import "SnoozeJoke.h"

@interface AlarMockViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Alarm *currentAlarm;

@property (nonatomic) AlarMockView *view;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AlarMockViewController

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tableView setEditing:NO animated:YES];
    
    [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

#pragma mark - UITableViewDelegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.alarmEngine.alarms.count == 0) {
        [self.navigationItem.leftBarButtonItem setTitle:@""];
    } else {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    return self.alarmEngine.alarms.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Alarm *alarm = self.alarmEngine.alarms[indexPath.row];
    AlarMockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.cellSwitch.on = alarm.on;
    cell.cellSwitch.tag = indexPath.row;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *timeString = [dateFormatter stringFromDate:alarm.fireDate];
    [cell setText:timeString timeFormatted:YES];
    self.currentAlarm = self.alarmEngine.alarms[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.alarmEngine removeAlarm:self.alarmEngine.alarms[indexPath.row]];
    [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addAlarm"]) {
        ((AddAlarmViewController *)[segue destinationViewController]).alarmEngine = self.alarmEngine;
    }
}

#pragma mark - Action Handlers

- (IBAction)leftButtonClicked:(id)sender
{
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
    } else {
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (IBAction)rightButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"addAlarm" sender:sender];
}

- (IBAction)switchDidChangeValue:(UISwitch *)aSwitch
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:aSwitch.tag inSection:0];
    Alarm *alarm = self.alarmEngine.alarms[indexPath.row];
    alarm.on = aSwitch.isOn;
}

@end
