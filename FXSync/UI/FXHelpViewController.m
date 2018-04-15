//
//  FXHelpViewController.m
//  Foxbrowser
//
//  Created by Asif Seraje on 09.10.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import "FXHelpViewController.h"
#import "UIWebView+WebViewAdditions.h"


@implementation FXHelpViewController

- (void)loadView {
    __strong UIWebView *webView = [[UIWebView alloc] initWithFrame:
                                   [UIScreen mainScreen].applicationFrame];
    self.view = webView;
    self.webView = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"Instructions", @"FXSync", @"Instructions title");
    
    __strong UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                                   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectOffset(indicator.frame, (self.view.bounds.size.width - indicator.frame.size.width)/2, 80);
    indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];
    self.activityIndicator = indicator;
    
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:
                               [NSURL URLWithString:@"http://support.mozilla.org/kb/how-do-i-set-up-firefox-sync"]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:kGAIScreenName value:@"AccountHelp"];
//    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code == NSURLErrorCancelled || [error.domain isEqualToString:@"WebKitErrorDomain"])
        return;
    
    NSString *title = NSLocalizedStringFromTable(@"Error Loading Page", @"FXSync", @"error loading page");
    if ([self.webView isEmpty]) {
        [self.webView showPlaceholder:error.localizedDescription title:title];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"FXSync", @"ok")
                                              otherButtonTitles: nil];
        [alert show];
    }
}

@end
