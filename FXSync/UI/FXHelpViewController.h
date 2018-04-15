//
//  FXHelpViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 09.10.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface FXHelpViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

@end
