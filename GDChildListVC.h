//
//  GDChildListVC.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/21/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDChildListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *gdChildDataTable;

@property (nonatomic, strong) NSMutableArray *childListArray;
@property (nonatomic, strong) NSString *folderIdentifier;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
