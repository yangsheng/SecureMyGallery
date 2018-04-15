//
//  PGAlbumCell.h
//  Foxbrowser
//
//  Created by Asif Seraje on 2/15/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGAlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pgImageView;
@property (weak, nonatomic) IBOutlet UILabel *pgTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pgDetailTitlelbl;

@end
