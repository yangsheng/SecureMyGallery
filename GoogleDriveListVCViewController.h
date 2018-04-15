//
//  GoogleDriveListVCViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/14/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTableViewCell.h"
//#import "GTMOAuth2ViewControllerTouch.h"
//#import "GoogleDriveSDK.h"


//typedef enum _directoryStatus
//{
//    kDirectoryCreationFailed,
//    kDirectoryCreationSuccess,
//    kDirectoryExists,
//}DirectoryCreationStatus;
//

@interface GoogleDriveListVCViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>



@property (weak, nonatomic) IBOutlet UITableView *googleDriveDataTable;
//@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonForBack;


@end
