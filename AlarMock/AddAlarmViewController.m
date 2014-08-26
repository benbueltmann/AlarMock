//
//  TimePickerViewController.m
//  AlarMock
//
//  Created by Rick Wolchuk on 8/22/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AddAlarmViewController.h"
#import "RepeatViewController.h"
#import "Jokes.h"
#import "AlarmJokes.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SnoozeJokes.h"


@interface AddAlarmViewController () <UITableViewDataSource, UITableViewDelegate, JokesManager, MPMediaPickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *snoozeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *snoozeMockLabel;
@property float sliderVal;
@property Jokes *jokes;
@property NSMutableArray *alarmJokes;
@property NSMutableArray *snoozeJokes;

@end

@implementation AddAlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.localNotifications = [NSMutableArray new];
    self.datePicker.date = [NSDate date];

    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.slider.hidden = YES;
    
    self.jokes = [[Jokes alloc] init];

    self.jokes.delegate =self;
    [self.jokes queryAlarmJokes];
    [self.jokes querySnoozeJokes];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    NSArray *settings = [[NSArray alloc] initWithObjects:@"Repeat", @"Sound", @"Snooze", nil];
    cell.textLabel.text = [settings objectAtIndex:indexPath.row];
    
    UISwitch *switcheroo = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switcheroo addTarget:self
                   action:@selector(changeSwitch:)
         forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:switcheroo];
    if ([cell.textLabel.text isEqualToString:@"Snooze"]) {
        cell.accessoryView  = switcheroo;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        RepeatViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"daysVC"];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (void)changeSwitch:(id)sender
{
    if([sender isOn]) {
        self.slider.hidden = NO;
        self.snoozeTimeLabel.hidden = NO;
    } else {
        self.slider.hidden = YES;
        self.snoozeTimeLabel.hidden = YES;
    }
}

- (IBAction)onSavePressed:(id)sender
{
    UILocalNotification* localNotification = [UILocalNotification new];
   
    //localNotification.fireDate = self.datePicker.date;
    //notification fires in 4 seconds while testing
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:4];
    localNotification.alertBody = [NSString stringWithFormat:@"%@", [self.alarmJokes objectAtIndex:arc4random_uniform(self.alarmJokes.count)]];
    //localNotification.alertAction = @"Snooze";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [self saveDefault:localNotification];
    
    for (int i = 1; i < 5; i++) {
        UILocalNotification * snoozeNotification = [UILocalNotification new];
        snoozeNotification.alertBody = [NSString stringWithFormat:@"%@", [self.snoozeJokes objectAtIndex:arc4random_uniform(self.snoozeJokes.count)]];
        //snoozeNotification.fireDate = [NSDate dateWithTimeInterval:60 * i * self.sliderVal sinceDate:self.datePicker.date];
        
        snoozeNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10 * i];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];

        
        [[UIApplication sharedApplication] scheduleLocalNotification:snoozeNotification];
        [self saveSnoozeDefault:snoozeNotification];
    }
        
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onMoveSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float val = 1 + slider.value * 58.0f;
    self.sliderVal = val;
    
    if (val == 1) {
        self.snoozeTimeLabel.text =[NSString stringWithFormat:@"Snooze for %ld minute", (long)val];
    } else {
        self.snoozeTimeLabel.text = [NSString stringWithFormat:@"Snooze for %ld minutes", (long)val];
    }
    
    if (val >=1 && val < 21) {
        self.snoozeMockLabel.text = @"We suppose this is a reasonable snooze interval";
    } else if (val >= 21 && val <= 58) {
        self.snoozeMockLabel.text = @"Seriously, who snoozes for more than 20 minutes?";
    } else if (val == 59) {
        self.snoozeMockLabel.text = @"If you think you will need to snooze this long just call in sick";
    }
}

-(void)saveDefault:(UILocalNotification *)localNotification
{
    NSData *localNotificationData = [NSKeyedArchiver archivedDataWithRootObject:localNotification];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *localNotificationsData = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"localNotificationsData"]];
    [localNotificationsData addObject:localNotificationData];
    [prefs setObject:localNotificationsData forKey:@"localNotificationsData"];
    self.localNotifications = localNotificationsData;
    [prefs synchronize];
}

-(void)saveSnoozeDefault:(UILocalNotification *)localNotification
{
    NSData *localNotificationData = [NSKeyedArchiver archivedDataWithRootObject:localNotification];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    id encodedNotes = [prefs objectForKey:@"snoozeNotificationsData"];
    
    NSMutableArray *datas = [[NSMutableArray alloc] initWithArray:encodedNotes];
    [datas addObject:localNotificationData];
    [prefs setObject:datas forKey:@"snoozeNotificationsData"];
    [prefs synchronize];
}

-(void)alarmJokesReturned:(NSArray *)jokes
{
    self.alarmJokes = [NSMutableArray array];

    for (AlarmJokes *joke in jokes)
    {
        [self.alarmJokes addObject:joke.joke];
    }
//    NSLog(@"%@", jokes);
}

-(void)snoozeJokesReturned:(NSArray *)jokes
{
    self.snoozeJokes = [NSMutableArray array];
    
    for (SnoozeJokes *joke in jokes)
    {
        [self.snoozeJokes addObject:joke.joke];
    }
}
//onRowTapped is not real…
- (void)onRowTapped:(BOOL)animated {
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
	picker.delegate = self;
	picker.allowsPickingMultipleItems = YES;
	picker.prompt = @"Choose a song that might wake your bitch ass up";
	[self presentViewController:picker animated:YES completion:nil];

}

//- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
//
//	[self dismissViewControllerAnimated:YES completion:^{
//        [self updatePlayerQueueWithMediaCollection: mediaItemCollection];
//        [AddAlarmViewController reloadData];
//    }];
//}
//
//// Responds to the user tapping done having chosen no music.
//- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
//
//	[self dismissViewControllerAnimated:YES completion:^{
//
//    }];}


@end

