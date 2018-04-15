//
//  SGToolbarView.h
//  Foxbrowser
//
//  Created by Asif Seraje on 07.10.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SGSearchViewController.h"
#import "SGBottomToolbarView.h"

@class SGBrowserViewController, SGSearchField, NJKWebViewProgressView,SGBlankController,SGBottomToolbarView;

/*! Common superclass for the device specific toolbars */
@interface SGBottomToolbarView : UIView <UITextFieldDelegate, SGSearchDelegate>{


}


@property (weak, nonatomic) SGBrowserViewController *browser;
@property (weak, readonly, nonatomic) UIButton *backButton;
@property (weak, readonly, nonatomic) UIButton *forwardButton;
@property (weak, readonly, nonatomic) UIButton *menuButton;

@property (weak, nonatomic) NJKWebViewProgressView *progressView;

@property (strong, nonatomic, readonly) UINavigationController *bookmarks;

@property (weak, readonly, nonatomic) SGSearchField *searchField;
@property (strong, readonly, nonatomic) SGSearchViewController *searchController;

@property (retain, nonatomic) UIToolbar *toolbar2;


- (instancetype)initWithFrame:(CGRect)frame browserDelegate:(SGBrowserViewController *)browser;
-(void) addBottomView;
- (IBAction)showBrowserMenu:(id)sender;
/*! Update the searchfield and the progress */
- (void)updateInterface;

- (void)presentSearchController;
- (void)presentMenuController:(UIViewController *)vc completion:(void(^)(void))completion;
- (void)dismissPresented;

@end
