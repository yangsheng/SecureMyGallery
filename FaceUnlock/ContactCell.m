//
//  ContactCell.m
//  PhotoVault
//
//  Created by Asif Seraje on 12/20/15.
//
//

#import "ContactCell.h"

@implementation ContactCell

#define CELL_SEL_COLOR [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]

- (void)awakeFromNib {
    // Initialization code
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.backgroundColor = CELL_SEL_COLOR;
    }
    else{
        
        self.backgroundColor = [UIColor clearColor];
    }
    
}


@end
