//
//  SoundViewController.m
//  AlarMock
//
//  Created by Patrick Hogan on 9/3/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "SoundViewController.h"

#import "AddAlarmViewController.h"
#import "AMColor.h"
#import "AMFont.h"
#import "AMNavigationAppearance.h"
#import "AMRadialGradientLayer.h"
#import "UIScreen+AMScale.h"

@interface SoundViewController () <UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) MPMediaItem *alarmSong;
@property (nonatomic) NSString *notificationSoundText;
@property (nonatomic) NSString *checkedSound;
@property (nonatomic) AMRadialGradientLayer *gradientLayer;
@property (nonatomic) NSArray *sounds;
@property (nonatomic) NSIndexPath *lastIndexPath;
@property (nonatomic) AVPlayer *aVPlayer;
@end

@implementation SoundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.notificationSoundText = [NSString new];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.sounds = @[@"Alert 1", @"Alert 2", @"Alert 3", @"Alert 4"];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    evaluates to b if a is true and evaluates to c if a is false.
     return (section == 0 ? 4 : 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-  (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];

    [view addSubview:label];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.lastIndexPath = indexPath;
    
    if (indexPath.section == 1) {
        [[AMNavigationAppearance sharedInstance] setStyle:AMNavigationAppearanceStyleLight];

        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
        
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = NO;
        mediaPicker.prompt = @"What song would you like stuck in your head?";
        [self presentViewController:mediaPicker animated:YES completion:nil];
    } else {
        self.notificationSoundText = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:self.notificationSoundText ofType:@".wav"];
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        
        self.aVPlayer = [[AVPlayer alloc] initWithURL:soundURL];
        [self.aVPlayer play];
        [tableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundCell" forIndexPath:indexPath];

    cell.textLabel.textColor = [AMColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.font = [AMFont book22];
        cell.textLabel.text = [self.sounds objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.font = [AMFont book16];
        cell.textLabel.text = @"Choose a song from your Library";
    }
    
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Action Handlers

- (IBAction)handleBackButton:(id)sender
{
    [self.delegate soundViewController:self didChooseNotificationSoundText:self.notificationSoundText didChooseSong:self.alarmSong];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [[AMNavigationAppearance sharedInstance] setStyle:AMNavigationAppearanceStyleDark];

    [self dismissViewControllerAnimated:YES completion:^{
        self.alarmSong = [mediaItemCollection.items objectAtIndex:0];
        [[[UIAlertView alloc] initWithTitle:@"If you choose a song as your alarm tone, the phone must be locked with Alarm Mock open in the background"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Ok",nil] show];
    }];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [[AMNavigationAppearance sharedInstance] setStyle:AMNavigationAppearanceStyleDark];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
