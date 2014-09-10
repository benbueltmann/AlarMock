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
#import "NSArray+AMRandomElement.h"
#import "SnoozeJoke.h"

@interface JokeCollection ()

@property (nonatomic) NSArray *alarmJokes;
@property (nonatomic) NSArray *snoozeJokes;

@end

@implementation JokeCollection

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self) {
        _alarmJokes = [decoder decodeObjectForKey:@"alarmJokes"];
        _snoozeJokes = [decoder decodeObjectForKey:@"snoozeJokes"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_alarmJokes forKey:@"alarmJokes"];
    [encoder encodeObject:_snoozeJokes forKey:@"snoozeJokes"];
}

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
        self.snoozeJokes = objects;
        if (handler) {
            handler(objects, error);
        }
    }];
}

#pragma mark - Accessors

- (NSString *)randomAlarmJoke
{
    return [self.alarmJokes.am_randomElement joke];
}

- (NSString *)randomSnoozeJoke
{
    return [self.snoozeJokes.am_randomElement joke];
}

@end
