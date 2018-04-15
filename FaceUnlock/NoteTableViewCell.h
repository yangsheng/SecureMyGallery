//
//  NoteTableViewCell.h
//  PhotoVault
//
//  Created by Asif Seraje on 12/15/15.
//
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
