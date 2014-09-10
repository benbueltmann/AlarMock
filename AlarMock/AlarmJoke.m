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
@dynamic wav;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];

    if (self) {
        self.joke = [decoder decodeObjectForKey:@"joke"];
        self.wav = [decoder decodeObjectForKey:@"audio"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.joke forKey:@"joke"];
    [encoder encodeObject:self.wav forKey:@"audio"];
}

#pragma mark - PFSubclass

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"AlarmJoke";
}

@end
