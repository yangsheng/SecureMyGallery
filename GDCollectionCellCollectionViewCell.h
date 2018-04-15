//
//  GDCollectionCellCollectionViewCell.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTableViewCell.h"

@interface GDCollectionCellCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *googleDriveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end
