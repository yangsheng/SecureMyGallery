//
//  FXBookmarkTableController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 02.10.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPageViewController.h"

@class FXSyncItem,SGPageViewController;

/*! Works with https://docs.services.mozilla.com/sync/objectformats.html#bookmarks  */
@interface FXBookmarkTableController : UITableViewController
@property (nonatomic, strong) FXSyncItem *parentFolder;
@property (nonatomic, strong) NSArray *bookmarks;
@property (weak, nonatomic) SGPageViewController *browserViewController;

@end
