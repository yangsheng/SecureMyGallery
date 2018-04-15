//
//  GDTableViewCell.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/14/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *gdCellImgView;
@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
