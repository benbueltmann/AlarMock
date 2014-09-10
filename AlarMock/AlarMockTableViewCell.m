//
//  TableViewCell.m
//  AlarMock
//
//  Created by Patrick Hogan on 8/25/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AlarMockTableViewCell.h"

#import "AMColor.h"
#import "AMFont.h"

@interface AlarMockTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation AlarMockTableViewCell

@synthesize textLabel = _textLabel;

#pragma mark - View setup

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textLabel.textColor = [AMColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.cellSwitch.onTintColor = [AMColor switchTintColor];
    self.cellSwitch.tintColor = [AMColor switchTintColor];
    self.cellSwitch.thumbTintColor = [AMColor switchThumbColor];
}

#pragma mark - Accessors

- (void)setSwitchState:(BOOL)on
{
    self.cellSwitch.on = on;
}

- (void)setText:(NSString *)text
{
    [self setText:text timeFormatted:NO];
}

- (void)setText:(NSString *)text timeFormatted:(BOOL)timeFormatted
{
    if (!timeFormatted) {
        self.textLabel.font = [AMFont book16];
        self.textLabel.text = text;
    } else {
        self.textLabel.font = [AMFont book48];

        NSRange range = NSMakeRange([text stringByReplacingOccurrencesOfString:@" " withString:@""].length - 2, 2);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [attributedString addAttribute:NSFontAttributeName value:[AMFont book28] range:range];
        [[attributedString string] stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.textLabel.attributedText = attributedString;
    }
}

- (NSString *)text
{
    return self.textLabel.text;
}

@end
