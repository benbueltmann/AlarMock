//
//  AlarmLogic.h
//  AlarMock
//
//  Created by Patrick Hogan on 8/27/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"

@interface AlarmEngine : NSObject

@property (nonatomic, readonly) NSArray *alarms;
@property (nonatomic, readonly) NSString *randomAlarmJoke;
@property (nonatomic, readonly) NSString *randomSnoozeJoke;

+ (instancetype)loadFromSavedData;

- (void)addAlarm:(Alarm *)alarm;
- (void)removeAlarm:(Alarm *)alarm;

- (Alarm *)alarmWithFireDate:(NSDate *)fireDate;

@end
