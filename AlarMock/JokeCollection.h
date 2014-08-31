//
//  JokeCollection.h
//  AlarMock
//
//  Created by Patrick Hogan on 8/30/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

@interface JokeCollection : NSObject

@property (nonatomic, readonly) NSString *randomAlarmJoke;
@property (nonatomic, readonly) NSString *randomSnoozeJoke;

- (void)queryAlarmJokesWithHandler:(void (^)(NSArray *jokes, NSError *error))handler;
- (void)querySnoozeJokesWithHandler:(void (^)(NSArray *jokes, NSError *error))handler;

@end
