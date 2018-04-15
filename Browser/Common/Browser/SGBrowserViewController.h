//
//  SGBrowserViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 15.12.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomHTTPProtocol.h"
#import "JGActionSheet.h"


@class SGBottomView,JGActionSheet;

// Container for SGWebViewController & SGBlankViewController
@interface SGBrowserViewController : UIViewController <CustomHTTPProtocolDelegate, UIAlertViewDelegate>

// =========== Abstract =============

/// Adds a tab, don't add the same instance twice!
- (void)addViewController:(UIViewController *)childController;

/// Bring a tab to the frontpage
- (void)showViewController:(UIViewController *)viewController;

// Remove a tap
- (void)removeViewController:(UIViewController *)childController;
- (void)removeIndex:(NSUInteger)index;

// Swap the current view controller. Used to replace the blankView with the webView
- (void)swapCurrentViewControllerWith:(UIViewController *)viewController;

- (void)updateInterface;

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;

- (UIViewController *)selectedViewController;
@property (assign, nonatomic) NSUInteger selectedIndex;
@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) NSUInteger maxCount;
@property (weak, nonatomic) SGBottomView *bottomView;


// ========== Implemented =================

@property (strong, atomic) UIAlertView *credentialsPrompt;

// Add and show a SGBlankViewController
- (void)addTab;

// Add a new SGWebViewController, title can be nil
- (void)addTabWithURLRequest:(NSURLRequest *)request title:(NSString *)title;

- (void)reload;
- (void)stop;

- (BOOL)isLoading;
- (float)progress;

- (void)goBack;
- (void)goForward;

- (BOOL)canGoBack;
- (BOOL)canGoForward;
- (BOOL)canStopOrReload;
-(void)hideTabBarController;


- (NSURL *)URL;
- (NSURLRequest *)request;
// Open a webPage in the current tab, title can be nil
- (void)openURLRequest:(NSMutableURLRequest *)request title:(NSString *)title;
- (void)handleURLString:(NSString*)input title:(NSString *)title;
- (void)findInPage:(NSString *)searchPage;
- (void)loadSavedTabs;
- (void)saveCurrentTabs;
-(void) addhomeicon: (NSString* ) title;
-(void) openSafariaction;
-(void) ReadAsText;
- (void)copyURLfromWeb;

- (UIViewController *)createNewTabViewController;

- (BOOL)tabBarIsVisible;
- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion;

@end
