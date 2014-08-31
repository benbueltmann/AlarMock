//
//  ViewController.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/22/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AlarMockViewController.h"
#import "AlarMockTableViewCell.h"
#import "SnoozeJoke.h"
#import "AddAlarmViewController.h"
#import "Alarm.h"
#import "AlarmEngine.h"

@interface AlarMockViewController() <UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AlarMockViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alarmEngine.alarms.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Alarm *alarm = self.alarmEngine.alarms[indexPath.row];
    AlarMockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell setSwitchState:YES];
    //subclass nsobject and compose of 2 properties localnotification and isOn
    cell.delegate = self;
        
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *timeString = [dateFormatter stringFromDate:alarm.fireDate];
    cell.textLabel.text = timeString;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.alarmEngine removeAlarm:self.alarmEngine.alarms[indexPath.row]];
    [self.tableView reloadData];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Table View Cell Delegate Method

- (void)alarMockTableViewCell:(AlarMockTableViewCell *)tableViewCell switchDidChangeValue:(UISwitch *)switcheroo
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tableViewCell];
    Alarm *alarm = self.alarmEngine.alarms[indexPath.row];
    alarm.on = switcheroo.isEnabled;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editAlarm"]) {
        ((AddAlarmViewController *)[segue destinationViewController]).title = @"Edit Alarm";
    } else if ([segue.identifier isEqualToString:@"addAlarm"]) {
        ((AddAlarmViewController *)[segue destinationViewController]).alarmEngine = self.alarmEngine;
    }
}

#pragma mark - Snooze methods

- (void)saveSnoozeDefault:(UILocalNotification *)localNotification
{
    // TODO: Encapsulate in AlarmEngine
    NSData *localNotificationData = [NSKeyedArchiver archivedDataWithRootObject:localNotification];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    id encodedNotes = [prefs objectForKey:@"snoozeNotificationsData"];

    NSMutableArray *datas = [[NSMutableArray alloc] initWithArray:encodedNotes];
    [datas addObject:localNotificationData];
    [prefs setObject:datas forKey:@"snoozeNotificationsData"];
    [prefs synchronize];
}

#pragma mark - Action Handlers

- (IBAction)enterEditMode:(id)sender
{
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        
        [self.editButton setTitle:@"Edit"];
        self.addButton.enabled = YES;
    }
    else {
        [self.editButton setTitle:@"Done"];
        self.addButton.enabled = NO;
        
        [self.tableView setEditing:YES animated:YES];
    }
}

- (IBAction)unwindToAlarmMockViewController:(UIStoryboardSegue *)unwindSegue
{

}

- (IBAction)onSubmitJoke:(id)sender
{
    PFObject *joke = [PFObject objectWithClassName:@"UserJokes"];
    joke[@"joke"] = self.textField.text;
    [joke saveInBackground];
    self.textField.text = @"";
    self.textField.placeholder = self.textField.placeholder;
}

@end
