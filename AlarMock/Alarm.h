//
//  Alarm.h
//  AlarMock
//
//  Created by Patrick Hogan on 8/29/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class JokeCollection;

FOUNDATION_EXTERN NSString * const kAlarmValueChangedNotification;

@interface Alarm : NSObject <NSCoding>

@property (nonatomic) NSTimeInterval snoozeInterval;
@property (nonatomic) MPMediaItem *alarmSong;
@property (nonatomic) BOOL on;
@property (nonatomic) NSDate *fireDate;
@property (nonatomic) NSString *notificationSoundText;
@property (nonatomic) NSArray *daysChecked;
@property (nonatomic, readonly) NSString *joke;
@property (nonatomic) UILocalNotification *notification;

- (id)initWithJokeCollection:(JokeCollection *)jokeCollection;

- (void)snooze;
- (void)stop;

@end
