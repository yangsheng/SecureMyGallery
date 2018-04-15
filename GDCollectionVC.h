//
//  GDCollectionVC.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGThumbsController.h"

@interface GDCollectionVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

- (IBAction)dismissViewController:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *googleDriveCollectionView;
@property (nonatomic, strong) NSString *folderName;

@end
