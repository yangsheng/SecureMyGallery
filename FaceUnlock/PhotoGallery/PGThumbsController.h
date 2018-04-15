//
//  PGThumbsController.h
//  PhotoGallery
//
//  Created by Asif Seraje on 1/12/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "PGImageButton.h"
#import "PGAlbumPicker.h"
#import "PGDataSource.h"
#import "DownloadManager.h"
#import "PGDLAlbumPicker.h"
//#import "KCHAlbumPickerView.h"

@interface PGThumbsController : UIViewController<MWPhotoBrowserDelegate, PGImageButtonDelegate, PGAlbumPickerDelegate, PGDataSourceAsyncOpsProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,DownloadManagerDelegate,PGDLAlbumPickerDelegate>

@property (nonatomic, strong) NSString *folder;
@property (nonatomic) NSInteger *flag;
@property (nonatomic) NSInteger *dflag;

@property (nonatomic, strong) NSArray *dropBoxSelectedImages;
@property (nonatomic, strong) NSArray *googleDriveSelectedImages;


-(void) refreshSelectionStatus;
-(void) refreshScrollView;


- (void)downloadImageFileFromGoogleDrive;
- (void)downloadImageFileFromDropBox;
- (void)setDrobBoxSelectedImageArray:(NSArray *)imageArray ;
- (void)setGoogleDriveSelectedImageArray:(NSArray *)imageArray ;

@end
