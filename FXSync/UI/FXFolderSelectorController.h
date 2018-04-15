//
//  FXFolderSelectorController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 05.10.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXSyncItem;
@interface FXFolderSelectorController : UITableViewController
@property (nonatomic, strong) FXSyncItem *bookmark;
@end

@interface FXFolderSelectorCell : UITableViewCell

@end
