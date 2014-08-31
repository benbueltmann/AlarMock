//
//  TableViewCell.m
//  AlarMock
//
//  Created by Patrick Hogan on 8/25/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AlarMockTableViewCell.h"

@interface AlarMockTableViewCell ()

@property (nonatomic, weak) IBOutlet UISwitch *switcheroo;

@end

@implementation AlarMockTableViewCell

- (IBAction)switchDidChangeValue:(UISwitch *)sender
{
    [self.delegate alarMockTableViewCell:self switchDidChangeValue:sender];
}

- ( void)setSwitchState:(BOOL)on
{
    self.switcheroo.on = on;
}

@end
