//
//  SGLatestViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 13.07.12.
//
//
//  Copyright (c) 2012 Asif Seraje
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGPreviewPanel.h"
#import "SGPageToolbar.h"
#import "SGWebViewController.h"

#define SG_TAB_WIDTH 320.0

@class FXTabsViewController, SGBottomView,SGPageToolbar,SGWebViewController;

@interface SGBlankController : UIViewController <UIScrollViewDelegate, UIViewControllerRestoration, SGPanelDelegate>{

    UIActivityIndicatorView *waitingView;

}
@property (weak, nonatomic) FXTabsViewController *tabsController;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) SGPreviewPanel *previewPanel;
@property (weak, nonatomic) SGBottomView *bottomView;

@property (retain, nonatomic) UIToolbar *toolbar2;
@property (weak, readonly, nonatomic) SGPageToolbar *pagetoolbar;
@property (retain, nonatomic) SGWebViewController *webtoolbar;

@property (weak, nonatomic) SGBrowserViewController *browser;

@end
