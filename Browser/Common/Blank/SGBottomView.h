//
//  SGBlankToolbar.h
//  Foxbrowser
//
//  Created by Asif Seraje on 30.07.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPageViewController.h"


@class SGBlankController,SGBrowserViewController,SGToolbarView,SGPageViewController,FXTabsViewController,SGPageToolbar,SGWebViewController;
@interface SGBottomView : UIView
@property (assign, nonatomic) CGFloat markerPosititon;
@property (weak, nonatomic) SGBlankController *container;
@property (weak, nonatomic) SGToolbarView *container1;
@property (weak, nonatomic) SGPageViewController *container2;
@property (weak, nonatomic) FXTabsViewController *tabsController;
@property (weak, nonatomic) SGPageToolbar *pagetool;
@property (weak, nonatomic) SGWebViewController *webtool;


@property (weak, readonly, nonatomic) UIButton *backButton;
@property (weak, readonly, nonatomic) UIButton *forwardButton;
@property (weak, readonly, nonatomic) UIButton *menuButton;
@property (weak, readonly, nonatomic) UIButton *homeButton;


@property (weak, nonatomic) SGBrowserViewController *browser;


- (id)initWithTitles:(NSArray *)titles images:(NSArray *)images browserDelegate:(SGBrowserViewController *)browser;

-(void) removeview;
@end
