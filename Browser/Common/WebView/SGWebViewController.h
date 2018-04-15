//
//  SGViewController.h
//  SGTabs
//
//  Created by Asif Seraje on 07.06.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <AVFoundation/AVFoundation.h>

#import "NJKWebViewProgress.h"
#import "SGBottomView.h"
#import "SGPageViewController.h"
#import "SGPageBottomToolbar.h"
#import "PGDataSource.h"

@class SGBottomView,SGBrowserViewController,SGPageViewController,SGPageBottomToolbar;

@interface SGWebViewController : SGBrowserViewController <UIWebViewDelegate, UIGestureRecognizerDelegate,
UIActionSheetDelegate, UIViewControllerRestoration, NJKWebViewProgressDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) UIToolbar *searchToolbar;
@property (retain, nonatomic) UIToolbar *toolbar2;
@property (weak, nonatomic) SGBrowserViewController *browser;
//@property (weak, readonly, nonatomic) SGPageToolbar *pagetoolbar;
@property (retain, nonatomic) SGPageBottomToolbar *pagecontroller;
@property (nonatomic, strong) PGDataSource *pgDataSource;


@property (strong, nonatomic) NSURLRequest *request;
@property (nonatomic, readonly, assign) BOOL canGoBack;
@property (nonatomic, readonly, assign) BOOL canGoForward;
@property (assign, nonatomic, readonly, getter = isLoading) BOOL loading;
@property (assign, nonatomic, readonly) float progress;
@property (nonatomic,strong)     NSURL *currentURL;

-(void) addhomeicon: (NSString* ) title;
-(void) openSafariaction;
-(void) ReadAsText;
-(void) ShareViaTwitter;
- (void)copyURL;

/// Loads a request
/// If parameter request is nil, the last loaded request will be reloaded
- (void)openRequest:(NSURLRequest *)request;
- (NSInteger)search:(NSString *)searchString;
- (NSURLRequest *)_nextRequestForURL:(NSURL *)url;
-(void)saveImageFromWeb:(UIImage *)image toFilePath:(NSString *)folderName;

@end
