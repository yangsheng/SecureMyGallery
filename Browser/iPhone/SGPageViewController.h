//
//  SGPageViewController.h
//  SGPageController
//
//  Created by Asif Seraje on 13.12.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SGBrowserViewController.h"
#import "SGWebViewController.h"
#import "SGPageBottomToolbar.h"


@class SGPageToolbar,SGBottomView,SGWebViewController,SGPageBottomToolbar;


@interface SGPageViewController : SGBrowserViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    SGBottomView *bottomView;


}
@property (weak, nonatomic) SGBrowserViewController *browser;
@property (weak, readonly, nonatomic) SGPageToolbar *toolbar;
@property (strong, nonatomic) SGPageBottomToolbar *bottomtoolbar;
@property (nonatomic) BOOL hidebottomV;
@property (weak, readonly, nonatomic) SGWebViewController *webView;

@property (weak, readonly, nonatomic) UIScrollView *scrollView;
@property (weak, readonly, nonatomic) UIPageControl *pageControl;
@property (weak, readonly, nonatomic) UIButton *closeButton;
@property (weak, readonly, nonatomic) UIButton *addTabButton;
@property (weak, readonly, nonatomic) UIButton *removeTabButton;

@property (weak, readonly, nonatomic) UIButton *menuButton;
@property (weak, readonly, nonatomic) UIButton *tabsButton;
@property (weak, readonly, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UIToolbar *toolbar2;

@property (assign, nonatomic) BOOL exposeMode;
- (void)_enableInteractions;
- (void)setExposeMode:(BOOL)exposeMode animated:(BOOL)animated;
- (void)addTab;
- (void)hideBottomToolBar;

@end
