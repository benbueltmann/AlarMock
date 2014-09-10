//
//  Alarm.m
//  AlarMock
//
//  Created by Patrick Hogan on 8/29/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "Alarm.h"

#import "JokeCollection.h"

NSString * const kAlarmValueChangedNotification = @"AlarmValueChangedNotification";

@interface Alarm ()

@property (nonatomic) JokeCollection *jokeCollection;

@property (nonatomic, getter = hasSnoozed) BOOL snoozed;

@end

@implementation Alarm

@synthesize notificationSoundText = _notificationSoundText;

#pragma mark - Initialization

- (id)initWithJokeCollection:(JokeCollection *)jokeCollection
{
    self = [super init];
    
    if (self) {
        self.jokeCollection = jokeCollection;
    }
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self) {
        _notification = [decoder decodeObjectForKey:@"notification"];
        _snoozeInterval = [[decoder decodeObjectForKey:@"snoozeInterval"] floatValue];
        _alarmSong = [decoder decodeObjectForKey:@"alarmSong"];
        _on = [[decoder decodeObjectForKey:@"on"] boolValue];
        _snoozed = [[decoder decodeObjectForKey:@"hasSnoozed"] boolValue];
        _fireDate = [decoder decodeObjectForKey:@"fireDate"];
        _daysChecked = [decoder decodeObjectForKey:@"daysChecked"];
        _jokeCollection = [decoder decodeObjectForKey:@"jokeCollection"];
        _notificationSoundText = [decoder decodeObjectForKey:@"notificationSoundText"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_notification forKey:@"notification"];
    [encoder encodeObject:@(_snoozeInterval) forKey:@"snoozeInterval"];
    [encoder encodeObject:_alarmSong forKey:@"alarmSong"];
    [encoder encodeObject:@(_on) forKey:@"on"];
    [encoder encodeObject:@(_snoozed) forKey:@"hasSnoozed"];
    [encoder encodeObject:_fireDate forKey:@"fireDate"];
    [encoder encodeObject:_daysChecked forKey:@"daysChecked"];
    [encoder encodeObject:_jokeCollection forKey:@"jokeCollection"];
    [encoder encodeObject:_notificationSoundText forKey:@"notificationSoundText"];
}

#pragma mark - Snooze

- (void)snooze
{
    self.snoozed = YES;
    if (self.snoozeInterval) {
        [self setFireDate:[NSDate dateWithTimeInterval:self.snoozeInterval sinceDate:[NSDate date]]];
    }
}

- (void)stop
{
    self.snoozed = NO;
    self.on = NO;
}

#pragma mark - Jokes

- (void)updateAlertBody
{
    if (self.hasSnoozed) {
        self.notification.alertBody = self.jokeCollection.randomSnoozeJoke;
    } else {
        self.notification.alertBody = self.jokeCollection.randomAlarmJoke;
    }
}

#pragma mark - Fire Date

- (void)scheduleLocalNotification
{
    while ([_fireDate timeIntervalSinceNow] <= 0.0) {
        _fireDate = [_fireDate dateByAddingTimeInterval:60.0 * 60.0 * 24.0];
    }

    self.notification.fireDate = _fireDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];
}

#pragma mark - Accesors

- (void)setOn:(BOOL)on
{
    _on = on;
    
    if (on) {
        [self scheduleLocalNotification];
    } else if ([_fireDate timeIntervalSinceNow] > 0.0) {
        [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlarmValueChangedNotification object:self];
}

- (void)setSnoozed:(BOOL)snoozed
{    
    _snoozed = snoozed;
    [self updateAlertBody];
}

- (void)setFireDate:(NSDate *)fireDate
{
    _fireDate = fireDate;
    
    if (self.on) {
        [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
        [self scheduleLocalNotification];
    }
}

- (void)setJokeCollection:(JokeCollection *)jokeCollection
{
    _jokeCollection = jokeCollection;
    [self updateAlertBody];
}

- (UILocalNotification *)notification
{
    if (!_notification) {
        self.notification = [UILocalNotification new];
        _notification.timeZone = [NSTimeZone defaultTimeZone];
    }
    
    return _notification;
}

#pragma mark - Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - Fire Date: %@", [super description], self.fireDate];
}

- (NSString *)joke
{
    return self.notification.alertBody;
}

- (NSString *)notificationSoundText
{
    if (!_notificationSoundText) {
        self.notificationSoundText = @"0";
    }
    
    return _notificationSoundText;
}

//notificationSound nil
- (void)setNotificationSoundText:(NSString *)notificationSoundText
{
    _notificationSoundText = notificationSoundText;
    self.notification.soundName = [self soundNameForNotificationSoundText:notificationSoundText];
}

- (NSString *)soundNameForNotificationSoundText:(NSString *)notificationSoundText
{
    NSString *string = [self.notificationSoundText stringByAppendingString:@".wav"];
    return string;
}

@end