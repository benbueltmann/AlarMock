//
//  ViewController.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/22/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AlarMockViewController.h"

#import "AddAlarmViewController.h"

static NSString * const kAlarMockCellIdentifier = @"Cell";

@interface AlarMockViewController() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AlarMockViewController

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.localNotifications = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kLocalNotificationsArrayPersistenceKey]];
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.localNotifications.count;
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlarMockCellIdentifier];
    
    // What is this line doing?
    [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    NSData *data = [self.localNotifications objectAtIndex:indexPath.row];
    UILocalNotification *localNotification = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *timeString = [[AlarMockViewController cellDateFormatter] stringFromDate:localNotification.fireDate];
    cell.textLabel.text = timeString;

    // This is bad, you are adding this subview everytime this cell is dequeued.  Try subclassing UITableViewCell and adding this there, making it a property and using delegate.  If you do take this path I would consider making the VC a delegate of the cell and tell it when the value of the switch changed with a custom protocol.  Something like cell:switchDidChangeValue:
    UISwitch *switcheroo = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    [switcheroo removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged]; // Safe to remove actions before adding if this method is going to be called multiple times, so that changeSwitch: won't be called multiple times on one click.  The way you have this written it won't be an issue, but if you implement what I said above without delegation it will be.
    [switcheroo addTarget:self
                   action:@selector(changeSwitch:)
         forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:switcheroo];
    
    cell.accessoryView  = switcheroo;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLocalNotificationsArrayPersistenceKey];
    [self.localNotifications removeObjectAtIndex:indexPath.row];

    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Action handlers

- (void)changeSwitch:(id)sender
{
    if([sender isOn]) {
        //local notification
    } else{
        //no local notification
    }
}
- (IBAction)enterEditMode:(id)sender {
    
    if ([self.tableView isEditing]) {
        [self.editButton setTitle:@"Edit"];
        self.addButton.enabled = YES;
    }
    else {
        [self.editButton setTitle:@"Done"];
        self.addButton.enabled = NO;
    }
    
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

-(IBAction)unwindToAlarmMockViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (IBAction)onSubmitJoke:(id)sender
{
    PFObject *joke = [PFObject objectWithClassName:@"Joke"];
    joke[@"joke"] = self.textField.text;
    [joke saveInBackground];
    self.textField.text = @"";
    self.textField.placeholder = self.textField.placeholder;
}

#pragma mark - Static Accessors

+ (NSDateFormatter *)cellDateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        [dateFormatter setDateFormat:@"h:mm a"];
    });
    
    return dateFormatter;
}

@end
