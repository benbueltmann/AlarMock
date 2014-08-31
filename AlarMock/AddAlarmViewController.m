//
//  TimePickerViewController.m
//  AlarMock
//
//  Created by Rick Wolchuk on 8/22/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AddAlarmViewController.h"
#import "AlarMockViewController.h"
#import "RepeatViewController.h"
#import "AlarmJoke.h"
#import "AlarmEngine.h"
#import "Alarm.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface AddAlarmViewController () <UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *snoozeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *snoozeMockLabel;
@property float sliderVal;


@property (nonatomic) MPMediaItem *alarmSong;
@property (nonatomic) Alarm *alarm;

@end

@implementation AddAlarmViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.datePicker.date = [NSDate date];

    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.slider.hidden = YES;    
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    NSArray *settings = [[NSArray alloc] initWithObjects:@"Repeat", @"Sound", @"Snooze", nil];
    cell.textLabel.text = [settings objectAtIndex:indexPath.row];
    
    UISwitch *switcheroo = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switcheroo addTarget:self
                   action:@selector(changeSnoozeSwitch:)
         forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:switcheroo];
    if ([cell.textLabel.text isEqualToString:@"Snooze"]) {
        cell.accessoryView  = switcheroo;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        RepeatViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"daysVC"];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    if (indexPath.row == 1) {
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = NO;
        mediaPicker.prompt = @"Choose a song that might wake your bitch ass up";
        [self presentViewController:mediaPicker animated:YES completion:nil];
        
//        NSURL *songUrl = [[mediaItems objectAtIndex: 0] valueForProperty:MPMediaItemPropertyAssetURL];
//        self.audioPlayerMusic = [[[AVPlayer alloc] initWithURL:songUrl] retain];
//        [self.audioPlayerMusic play];
    }
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    self.alarmSong =[mediaItemCollection.items objectAtIndex:0];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:^{
     
    }];
}

#pragma mark - Action handlers

- (void)changeSnoozeSwitch:(id)sender
{
    if([sender isOn]) {
        self.slider.hidden = NO;
        self.snoozeTimeLabel.hidden = NO;
        self.snoozeMockLabel.hidden = NO;
    } else {
        self.slider.hidden = YES;
        self.snoozeTimeLabel.hidden = YES;
        self.snoozeMockLabel.hidden = YES;
    }
}

- (IBAction)onSavePressed:(id)sender
{
    self.alarm = [Alarm new];
    self.alarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:4];
    //self.alarm.fireDate = self.datePicker.date;
    //notification fires in 4 seconds while testing
    self.alarm.snoozeInterval = self.sliderVal;
    self.alarm.alarmSong = self.alarmSong;

    [self.alarmEngine addAlarm:self.alarm];

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
        self.snoozeMockLabel.text = @"I suppose this is a reasonable snooze interval";
    } else if (val >= 21 && val <= 58) {
        self.snoozeMockLabel.text = @"Seriously, who snoozes for more than 20 minutes?";
    } else if (val == 59) {
        self.snoozeMockLabel.text = @"If you think you will need to snooze this long just call in sick";
    }
}

- (IBAction)unwindToAddAlarmViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

@end

