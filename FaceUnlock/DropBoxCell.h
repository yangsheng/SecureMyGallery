//
//  DropBoxCell.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/13/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropBoxCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
