//
//  JokeCollection.h
//  AlarMock
//
//  Created by Patrick Hogan on 8/30/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

@class AlarmJoke;
@class SnoozeJoke;

@interface JokeCollection : NSObject <NSCoding>

@property (nonatomic, readonly) AlarmJoke *randomAlarmJoke;
// changed from NSString
@property (nonatomic, readonly) SnoozeJoke *randomSnoozeJoke;

- (void)queryAlarmJokesWithHandler:(void (^)(NSArray *jokes, NSError *error))handler;
- (void)querySnoozeJokesWithHandler:(void (^)(NSArray *jokes, NSError *error))handler;

@end
