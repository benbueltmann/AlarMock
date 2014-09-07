//
//  SoundView.m
//  AlarMock
//
//  Created by Patrick Hogan on 9/7/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "SoundView.h"
#import "AMRadialGradientLayer.h"
#import "UIColor+AMTheme.h"
#import "UIScreen+AMScale.h"

#import <FXBlurView.h>
#import <Masonry.h>

@interface SoundView ()

@property (nonatomic) AMRadialGradientLayer *gradientLayer;

@end

@implementation SoundView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.gradientLayer = ({
        AMRadialGradientLayer *gradientLayer = [AMRadialGradientLayer layer];
        
        gradientLayer.colors = [UIColor am_backgroundGradientColors];
        
        gradientLayer.locations = @[@0.0f, @1.0f];
        
        [gradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
        [gradientLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
        
        gradientLayer;
    });
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gradientLayer.frame = (CGRect) { CGPointZero, self.frame.size };
    self.gradientLayer.gradientOrigin = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    self.gradientLayer.gradientRadius = CGRectGetMaxY(self.frame) * 0.9f;
}

@end