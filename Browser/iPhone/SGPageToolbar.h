//
//  SGPageToolbar.h
//  Foxbrowser
//
//  Created by Asif Seraje on 17.12.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SGToolbarView.h"
#import "SGSearchViewController.h"
#import "SGBottomView.h"
#import "SGBrowserViewController.h"

@class SGSearchField, SGSearchViewController, SGPageViewController,SGBottomView,SGWebViewController;

@interface SGPageToolbar : SGToolbarView
{
    UIView *bottomView1;
//    SGBottomView *bottomView;


}

@property (weak, nonatomic) SGBrowserViewController *brwser;
@property (weak, nonatomic) SGWebViewController *webview;

@property (weak, readonly, nonatomic) UIButton *backButton;
@property (weak, readonly, nonatomic) UIButton *forwardButton;
@property (weak, readonly, nonatomic) UIButton *tabsButton;
@property (weak, readonly, nonatomic) UIButton *cancelButton;


- (instancetype)initWithFrame:(CGRect)frame browserDelegate:(SGBrowserViewController *)browser;
- (void)updateInterface;
- (void)setSubviewsAlpha:(CGFloat)alpha;
-(void)pressTab;
- (void)updateButton;

@end
