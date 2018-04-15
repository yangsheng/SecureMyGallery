//
//  SGPageToolbar.m
//  Foxbrowser
//
//  Created by Asif Seraje on 17.12.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import "SGPageBottomToolbar.h"
#import "SGPageViewController.h"
#import "SGSearchField.h"
#import "SGPageViewController.h"

#import "NJKWebViewProgressView.h"
//#import "GAI.h"
#import "SGWebViewController.h"

@implementation SGPageBottomToolbar {
    BOOL _searchMaskVisible;

}

@synthesize forwardButton,backButton;

- (instancetype)initWithFrame:(CGRect)frame browserDelegate:(SGBrowserViewController *)browser; {
    self = [super initWithFrame:frame browserDelegate:browser];
    if (self) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TabBarHidden"];


        self.backgroundColor = [UIColor colorWithRed:(30/256.0) green:(37/256.0) blue:(45/256.0) alpha:(1.0)];
        __strong UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        btn.backgroundColor = [UIColor clearColor];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"browserBottomBarBack"] forState:UIControlStateNormal];
        [btn addTarget:self.webview action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled=self.browser.canGoBack;
        [self addSubview:btn];
        backButton = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        btn.backgroundColor = [UIColor clearColor];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"browserBottomBarNext"] forState:UIControlStateNormal];
        
        [btn addTarget:self.webview action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = self.browser.canGoForward;
        [self addSubview:btn];
        forwardButton = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        btn.backgroundColor = [UIColor clearColor];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"browserBottomBarHome"] forState:UIControlStateNormal];
        [btn addTarget:self.browser action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _homeButton = btn;
        
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        btn.backgroundColor = [UIColor clearColor];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"browserBottomBarHomeRefresh"] forState:UIControlStateNormal];
        btn.enabled = self.browser.canStopOrReload;

        [btn addTarget:self.browser action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _reloadButton = btn;
        
        
//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        btn.backgroundColor = [UIColor clearColor];
//        btn.showsTouchWhenHighlighted = YES;
//        [btn setImage:[UIImage imageNamed:@"browserBottomBarAction"] forState:UIControlStateNormal];
//        btn.enabled = self.browser.canStopOrReload;
//
//        [btn addTarget:self action:@selector(hideTabBarActions) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
//        _actionButton = btn;
        
        [self _layout];
    }
    return self;
}


- (void)hideTabBarActions
{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to start page", /*@"Mail this page", @"Share via Twitter",*/ @"Open in Safari", @"Read as Text", @"Copy URL", nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    actionSheet.tag=101;

//    [actionSheet showInView:self];
    //CGSize test = _bottomtoolbar.frame.bounds.size;

//    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
//    [self.browser hideTabBarController];
//    CGFloat topOffset = 0;
//    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
//        topOffset = [self.browser.bottomLayoutGuide length];
//    }
//    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"TabBarHidden"]) {
//        self.frame = CGRectMake(0,topOffset-150,width, height);
//    }
//    else{
//
//        
//        self.frame = CGRectMake(0,topOffset-150,width, height);
//
//    }
    
    
//    
//    [self.browser setTabBarVisible:![self.browser tabBarIsVisible] animated:YES completion:^(BOOL finished) {
//                NSLog(@"finished");
//
//            }];
//    SGPageViewController *pageVC = [[SGPageViewController alloc]init];
//    
//    
//    [pageVC hideBottomToolBar];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag==101) {

        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if ([title isEqualToString:@"Add to start page"]) {
            [self.browser addhomeicon:title];
        }
        
        else if ([title isEqualToString:@"Open in Safari"]) {

            [self.browser openSafariaction];
        }
        else if ([title isEqualToString:@"Read as Text"]) {
            [self.browser ReadAsText];

        }
        else if ([title isEqualToString:@"Read as Text"]) {
            [self.browser ReadAsText];
            
        }
        else if ([title isEqualToString:@"Copy URL"]) {
            [self.browser copyURLfromWeb];

        }

    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _layout];
}


- (void)_layout {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat topOffset = 0;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        topOffset = [self.browser.bottomLayoutGuide length];
    }

    if (width==568) {
        
        self.actionButton.frame = CGRectMake(width - 60, 0, 36, 36);
        _reloadButton.frame = CGRectMake(width - 140, 0, 36, 36);
        _homeButton.frame = CGRectMake(width - 280, 0, 77, 36);
        forwardButton.frame=CGRectMake(width - 388, 0, 36, 36);
        backButton.frame=CGRectMake(width - 550, 0, 36, 36);
        
    }
    
    
    else
    {
        self.actionButton.frame = CGRectMake(width - 40, 0, 36, 36);
        _reloadButton.frame = CGRectMake(width - 50, 0, 36, 36);
        _homeButton.frame = CGRectMake(width - 130, 0, 36, 36);
        forwardButton.frame=CGRectMake(width - 228, 0, 36, 36);
        backButton.frame=CGRectMake(width - 310, 0, 36, 36);
    }
 
    
    
//    backButton.frame=CGRectMake(10, 0, 44, 44);
//    forwardButton.frame=CGRectMake(backButton.frame.size.width+20, 0, 44, 44);
//    _homeButton.frame=CGRectMake(140, 0, 44, 44);
//    _reloadButton.frame=CGRectMake(200, 0, 44, 44);
//    _actionButton.frame=CGRectMake(270, 0, 44, 44);

    
}

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
    // bail if the current state matches the desired state
//    if ([self tabBarIsVisible] == visible) return completion(YES);
//    
//    // get a frame calculation ready
//    CGFloat height = DELEGATE.tabBarController.tabBar.frame.size.height;
//    CGFloat offsetY = (visible)? -height : height;
//    
//    // zero duration means no animation
//    CGFloat duration = (animated)? 0.3 : 0.0;
//    
//    [UIView animateWithDuration:duration animations:^{
//        DELEGATE.tabBarController.tabBar.frame = CGRectOffset(DELEGATE.tabBarController.tabBar.frame, 0, offsetY);
//    } completion:completion];
}

// know the current state
//- (BOOL)tabBarIsVisible {
//    //return DELEGATE.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.frame);
//}

// illustration of a call to toggle current state
- (void)showHideTabBar{
//    [self setTabBarVisible:![self tabBarIsVisible] animated:YES completion:^(BOOL finished) {
//        NSLog(@"finished");
//    }];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, UIColorFromHEX(0xA9A9A9).CGColor);
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(ctx);
}

- (void)updateInterface {
    [super updateInterface];
    
    if (!([self.searchField isFirstResponder] || _searchMaskVisible)) {
        self.searchField.text = [self.browser URL].absoluteString;
    }
    
    NSString *text = [NSString stringWithFormat:@"%lu", (unsigned long)self.browser.count];
    [_tabsButton1 setTitle:text forState:UIControlStateNormal];
    
    self.backButton.enabled = self.browser.canGoBack;
    if (self.forwardButton.enabled != self.browser.canGoForward) {
        [UIView animateWithDuration:0.2 animations:^{
            self.forwardButton.enabled = self.browser.canGoForward;
            [self _layout];
        }];
    }
    
    self.reloadButton.enabled=self.browser.canStopOrReload;
    
    
    
   //// action button hide when blankpage
    
//    if ([[self.browser selectedViewController] isKindOfClass:[SGWebViewController class]]) {
//        
        self.actionButton.enabled=YES;
//    }
//    else{
//        self.actionButton.enabled=NO;
//
//        
//    }
    
}

- (void)setSubviewsAlpha:(CGFloat)alpha {
    for (UIView *view in self.subviews) {
        if (view != self.progressView) {
            view.alpha = alpha;
        }
    }
}

#pragma mark - IBAction

//- (IBAction)_cancelSearchButton:(id)sender {
//    [self dismissPresented];
//    [self.searchField resignFirstResponder];
//}
//
//- (IBAction)_pressedTabsButton:(id)sender {
//    //[self pressTab];
//    NSLog(@"kfjhsadkf");
//    SGPageViewController *pageVC = (SGPageViewController *)self.browser;
//    [pageVC setExposeMode:YES animated:YES];
//}

//-(void)pressTab{
//    NSLog(@"kfjhsadkf");
//    SGPageViewController *pageVC = (SGPageViewController *)self.browser;
//    [pageVC setExposeMode:YES animated:YES];
//    
//    [self.browser presentViewController:pageVC animated:YES completion:nil];
//
//}

#pragma mark - UITextFieldDelegate
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self presentSearchController];
//    //[textField selectAll:self];
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
//    // When the search string changes, filter the recents list accordingly.
//    if (_searchMaskVisible && searchText.length) // TODO
//        [self.searchController filterResultsUsingString:searchText];
//    
//    return YES;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    // When the search button is tapped, add the search term to recents and conduct the search.
//    NSString *searchString = [textField text];
//    [self finishSearch:searchString title:nil];
//    return YES;
//}

#pragma mark - SGSearchController

//- (void)presentSearchController; {
//    if (!_searchMaskVisible) {
//        _searchMaskVisible = YES;
//        self.searchController.view.frame = CGRectMake(0, self.frame.size.height,
//                                                      self.frame.size.width, self.superview.bounds.size.height - self.frame.size.height);
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             [self _layout];
//                             _cancelButton1.alpha = 1.0;
//                             self.menuButton.alpha = 0;
//                             _tabsButton1.alpha = 0;
//                             [self.superview addSubview:self.searchController.view];
//                         } completion:^(BOOL finished){
//                             self.menuButton.hidden = YES;
//                             _tabsButton1.hidden = YES;
//                             _cancelButton1.hidden = NO;
//                         }];
//    }
//}

- (void)presentMenuController:(UIViewController *)vc completion:(void(^)(void))completion; {
    [self.browser presentViewController:vc animated:YES completion:completion];
}

//- (void)dismissPresented; {
//    [super dismissPresented];
//    if (_searchMaskVisible) {
//        _searchMaskVisible = NO;
//        // If the user finishes editing text in the search bar by, for example:
//        // tapping away rather than selecting from the recents list, then just dismiss the popover
//        self.searchField.text = [self.browser URL].absoluteString;
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             [self _layout];
//                             self.menuButton.alpha = 1.0;
//                             _tabsButton1.alpha = 1.0;
//                             _cancelButton1.alpha = 0;
//                             [self.searchController.view removeFromSuperview];
//                         } completion:^(BOOL finished){
//                             self.menuButton.hidden = NO;
//                             _tabsButton1.hidden = NO;
//                             _cancelButton1.hidden = YES;
//                         }];
//    }
//}
@end
