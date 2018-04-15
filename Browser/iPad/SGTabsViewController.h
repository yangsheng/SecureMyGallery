//
//  SGTabsViewController.h
//  SGTabs
//
//  Created by Asif Seraje on 07.06.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SGBrowserViewController.h"

@class SGTabsToolbar, SGTabsView;

@interface SGTabsViewController : SGBrowserViewController

/*! Tells the view controller to update it's chrome */
- (BOOL)canRemoveTab:(UIViewController *)viewController;

@end
