//
//  SnoozeJokes.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/25/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "SnoozeJoke.h"

@implementation SnoozeJoke

@dynamic joke;

+ (NSString *)parseClassName
{
    // TODO: Change this to singular
    return @"SnoozeJokes";
}

+ (void)load
{
    [self registerSubclass];
}

@end
