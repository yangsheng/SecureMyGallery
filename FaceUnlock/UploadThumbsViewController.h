//
//  UploadThumbsViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/7/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "PGImageButton.h"
#import "PGAlbumPicker.h"
#import "PGDataSource.h"
#import "UploadListViewController.h"

@interface UploadThumbsViewController : UIViewController<MWPhotoBrowserDelegate, PGImageButtonDelegate, PGAlbumPickerDelegate, PGDataSourceAsyncOpsProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSString *folder;

- (IBAction)doneUploading:(id)sender;
-(void) refreshSelectionStatus;
-(void) refreshScrollView;
@end
