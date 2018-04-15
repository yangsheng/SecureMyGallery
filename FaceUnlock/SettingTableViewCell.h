//
//  SettingTableViewCell.h
//  Foxbrowser
//
//  Created by Asif Seraje on 2/8/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *lockSwitch;
@property (weak, nonatomic) IBOutlet UILabel *separetorLabelFull;
@property (weak, nonatomic) IBOutlet UILabel *separetorLabelSemi;

@end
