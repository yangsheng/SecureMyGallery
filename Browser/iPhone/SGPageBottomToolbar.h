//
//  SGPageToolbar.h
//  Foxbrowser
//
//  Created by Asif Seraje on 17.12.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SGSearchViewController.h"
#import "SGBrowserViewController.h"
#import "SGBottomToolbarView.h"


@class SGSearchField, SGSearchViewController, SGPageViewController,SGWebViewController,SGBottomToolbarView;

@interface SGPageBottomToolbar : SGBottomToolbarView<UIActionSheetDelegate>
{
    UIView *bottomView1;
//    SGBottomView *bottomView;


}

@property (weak, nonatomic) SGBrowserViewController *brwser;
@property (weak, nonatomic) SGWebViewController *webview;

@property (weak, readonly, nonatomic) UIButton *backButton;
@property (weak, readonly, nonatomic) UIButton *forwardButton;
@property (weak, readonly, nonatomic) UIButton *tabsButton1;
@property (weak, readonly, nonatomic) UIButton *cancelButton1;
@property (weak, readonly, nonatomic) UIButton *homeButton;
@property (weak, readonly, nonatomic) UIActivityIndicatorView *waitingView;
@property (weak, readonly, nonatomic) UIButton *reloadButton;
@property (weak, readonly, nonatomic) UIButton *actionButton;


- (instancetype)initWithFrame:(CGRect)frame browserDelegate:(SGBrowserViewController *)browser;
- (void)updateInterface;
- (void)setSubviewsAlpha:(CGFloat)alpha;
-(void)pressTab;
- (void)updateButton;

@end
