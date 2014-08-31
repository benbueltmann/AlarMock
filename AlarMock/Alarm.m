//
//  Alarm.m
//  AlarMock
//
//  Created by Patrick Hogan on 8/29/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "Alarm.h"
#import "JokeCollection.h"

@interface Alarm ()

@property (nonatomic) UILocalNotification *notification;
@property (nonatomic, getter = hasSnoozed) BOOL snoozed;

@end

@implementation Alarm

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    //Encode Jokes at some point
    self = [super init];
    
    if (self) {
        _notification = [decoder decodeObjectForKey:@"notification"];
        _snoozeInterval = [[decoder decodeObjectForKey:@"snoozeInterval"] floatValue];
        _alarmSong = [decoder decodeObjectForKey:@"alarmSong"];
        _on = [[decoder decodeObjectForKey:@"on"] boolValue];
        _snoozed = [[decoder decodeObjectForKey:@"hasSnoozed"] boolValue];
        _fireDate = [decoder decodeObjectForKey:@"fireDate"];
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
}

#pragma mark - Snooze

- (void)snooze
{
    self.snoozed = YES;
    self.fireDate = [NSDate dateWithTimeInterval:self.snoozeInterval sinceDate:[NSDate date]];
}

- (void)stop
{
    self.snoozed = NO;
    // Schedule this for next requested run day
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

#pragma mark - Accesors

- (void)setSnoozed:(BOOL)snoozed
{
    if (self.snoozed == snoozed) {
        return;
    }
    
    _snoozed = snoozed;
    [self updateAlertBody];
}

- (void)setFireDate:(NSDate *)fireDate
{
    _fireDate = fireDate;
    self.notification.fireDate = fireDate;

    [[UIApplication sharedApplication] scheduleLocalNotification:self.notification];
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

@end