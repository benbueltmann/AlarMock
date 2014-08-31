//
//  AlarmJokes.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/25/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AlarmJoke.h"

@implementation AlarmJoke

@dynamic joke;

#pragma mark - PFSubclass

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    // TODO: Change this to singular
    return @"AlarmJokes";
}

@end
