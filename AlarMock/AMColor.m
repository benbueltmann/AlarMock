//
//  AMColor.m
//  AlarMock
//
//  Created by Patrick Hogan on 9/8/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AMColor.h"

@implementation AMColor

#pragma mark - Background

+ (NSArray *)backgroundGradientColors
{
    return @[(id)[[AMColor darkBlueColor] CGColor], (id)[[AMColor lightBlueColor] CGColor]];
}

#pragma mark - Switch

+ (UIColor *)switchTintColor
{
    return [UIColor colorWithRed:0.5f green:0.5f blue:0.65f alpha:1.0f];
}

+ (UIColor *)switchThumbColor
{
    return [self whiteColor];
}

#pragma mark -

+ (UIColor *)lightBlueColor
{
    return [UIColor colorWithRed:38.0f/255.0f green:33.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
}

+ (UIColor *)darkBlueColor
{
    return [UIColor colorWithRed:0.0f/255.0f green:110.0f/255.0f blue:155.0f/255.0f alpha:1.0f];
}

+ (UIColor *)lightGrayColor
{
    return [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1];
}

+ (UIColor *)whiteColor
{
    return [UIColor colorWithRed:0.95f green:0.95f blue:1.0f alpha:1];
}

+ (UIColor *)blackColor
{
    return [UIColor colorWithWhite:0.2f alpha:1.0f];
}

@end
