//
//  JokeCollection.m
//  AlarMock
//
//  Created by Patrick Hogan on 8/30/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import <Parse/Parse.h>

#import "JokeCollection.h"

#import "AlarmJoke.h"
#import "SnoozeJoke.h"

@interface JokeCollection ()

// TODO: Add keyed archiver stuff
@property (nonatomic) NSArray *alarmJokes;
@property (nonatomic) NSArray *snoozeJokes;

@end

@implementation JokeCollection

#pragma mark - Query Jokes

- (void)queryAlarmJokesWithHandler:(void (^)(NSArray *jokes, NSError *error))handler
{
    PFQuery *query = [PFQuery queryWithClassName:[AlarmJoke parseClassName]];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.alarmJokes = objects;
        if (handler)    {
            handler(objects, error);
        }
    }];
}

- (void)querySnoozeJokesWithHandler:(void (^)(NSArray *jokes, NSError *error))handler
{
    PFQuery *query = [PFQuery queryWithClassName:[SnoozeJoke parseClassName]];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.alarmJokes = objects;
        if (handler) {
            handler(objects, error);
        }
    }];
}

@end
