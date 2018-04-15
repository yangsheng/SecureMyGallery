//
//  LockTypeSettingsCell.m
//  Foxbrowser
//
//  Created by Asif Seraje on 2/11/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "LockTypeSettingsCell.h"

@implementation LockTypeSettingsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)newAccessoryType
{
    [super setAccessoryType:newAccessoryType];
    // Check for the checkmark
    switch(newAccessoryType)
    {
        case UITableViewCellAccessoryCheckmark:
            self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkMark"]];
            break;
        case UITableViewCellAccessoryNone:
            self.accessoryView = nil;
            break;
        default:
            break;
    }
    
}
@end
