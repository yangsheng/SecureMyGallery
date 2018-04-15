//
//  LockTypeSettingsCell.h
//  Foxbrowser
//
//  Created by Asif Seraje on 2/11/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockTypeSettingsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *reportSwitch;
@property (weak, nonatomic) IBOutlet UILabel *separetorLabel;

@end
