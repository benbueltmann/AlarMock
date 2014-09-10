//
//  TableViewCell.h
//  AlarMock
//
//  Created by Patrick Hogan on 8/25/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

@class AlarMockTableViewCell;

@interface AlarMockTableViewCell : UITableViewCell

@property (nonatomic) NSString *text;
@property (nonatomic, weak) IBOutlet UISwitch *cellSwitch;

- (void)setText:(NSString *)text timeFormatted:(BOOL)timeFormatted;

@end
