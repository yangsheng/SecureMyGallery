//
//  DBCollectionVC.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "PGThumbsController.h"

@interface DBCollectionVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *dropBoxCollectionView;
@property (nonatomic, strong) NSString *loadData;
@property (nonatomic, strong) NSString *folderName;


- (IBAction)dismissViewController:(id)sender;

@end
