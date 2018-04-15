//
//  DropBoxDownLoadListVC.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/12/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropBoxDownLoadListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,DBRestClientDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dropBoxDataTable;
//@property (nonatomic, readonly) DBRestClient *restClient;
@property (nonatomic, strong) NSString *loadData;
@property (nonatomic, strong) NSString *folderName;


@end
