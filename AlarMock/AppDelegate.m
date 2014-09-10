//
//  AppDelegate.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/22/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>

#import "AppDelegate.h"

#import "AddAlarmViewController.h"
#import "Alarm.h"
#import "AlarmEngine.h"
#import "AlarmJoke.h"
#import "AlarMockViewController.h"
#import "AMColor.h"
#import "AMFont.h"
#import "AMNavigationAppearance.h"
#import "SnoozeJoke.h"

@interface AppDelegate ()

@property (nonatomic) AlarmEngine *alarmEngine;
@property (nonatomic, readonly) AlarMockViewController *rootViewController;
@property (nonatomic) AVPlayer *aVPlayer;

@property (nonatomic) NSMutableOrderedSet *alarmQueue;

@end

@implementation AppDelegate

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //TODO:App icon and splash screen
    [Parse setApplicationId:@"I62Vun47l0d1KLv218eijHMxPG9dK6nxy54DtqQl" clientKey:@"rLVtvCOQVMqLrb5qijsmuC2y0MZAHVyZubSrFYqC"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [[AMNavigationAppearance sharedInstance] setStyle:AMNavigationAppearanceStyleDark];
    [[UIBarButtonItem appearance] setTitleTextAttributes: @{ NSFontAttributeName : [AMFont book14], NSForegroundColorAttributeName: [AMColor whiteColor] } forState:UIControlStateNormal];
    [[UITableViewCell appearance] setTintColor:[AMColor whiteColor]];
    
    self.alarmEngine = [AlarmEngine loadFromSavedData];
    self.rootViewController.alarmEngine = self.alarmEngine;
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback
                                           error:&setCategoryErr];
    
    [[AVAudioSession sharedInstance] setActive:YES
                                         error:&activationErr];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //Hack to fix iOS7 bug, notification sound does not stop when user responds to notification
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    Alarm *alarm = [self.alarmEngine alarmWithFireDate:notification.fireDate];
    if (alarm) {
        [self.alarmQueue addObject:alarm];
        [self updateAlarmQueue];
    } else {
        NSLog(@"WARNING: Alarm fired, but was not saved in alarm engine persistence layer.");
    }
}

#pragma mark - Alarm Queue

- (void)updateAlarmQueue
{
    Alarm *firstFiredAlarm = self.alarmQueue.firstObject;
    if (firstFiredAlarm.notification.soundName) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"0" ofType:@".wav"];
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        
        self.aVPlayer = [[AVPlayer alloc] initWithURL:soundURL];
        [self.aVPlayer play];
    } else if (firstFiredAlarm.alarmSong) {
        NSURL *songUrl = [firstFiredAlarm.alarmSong valueForProperty:MPMediaItemPropertyAssetURL];
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
        self.aVPlayer = [[AVPlayer alloc] initWithURL:songUrl];
        [self.aVPlayer play];
    }
    
    [[[UIAlertView alloc] initWithTitle:firstFiredAlarm.joke
                                message:nil
                               delegate:self
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Snooze", @"Dismiss",nil] show];
}

#pragma mark - UIAlertViewDelegate



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Alarm *firstFiredAlarm = self.alarmQueue.firstObject;
    if (buttonIndex == 0) {
        [firstFiredAlarm snooze];
        [self.aVPlayer pause];
    } else {
        [firstFiredAlarm stop];
        [self.alarmQueue removeObject:firstFiredAlarm];
        [self.aVPlayer pause];
    }
}

#pragma mark - Accessors

- (AlarMockViewController *)rootViewController
{
    return ((UINavigationController *)self.window.rootViewController).viewControllers.firstObject;
}

- (NSMutableOrderedSet *)alarmQueue
{
    if (!_alarmQueue) {
        self.alarmQueue = [NSMutableOrderedSet new];
    }
    
    return _alarmQueue;
}

@end
