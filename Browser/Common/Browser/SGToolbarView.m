//
//  SGToolbarView.m
//  Foxbrowser
//
//  Created by Asif Seraje on 07.10.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import "SGToolbarView.h"
#import "FXSyncStock.h"

#import "FXLoginViewController.h"
#import "FXSettingsViewController.h"
#import "FXBookmarkTableController.h"
#import "FXBookmarkEditController.h"

#import "SGBrowserViewController.h"
#import "SGSearchViewController.h"
#import "SGSearchField.h"
#import "SGBottomView.h"
#import "SGBlankController.h"
#import "SGPageViewController.h"

#import "KxMenu.h"
#import "TUSafariActivity.h"
#import "NJKWebViewProgressView.h"

@implementation SGToolbarView

- (instancetype)initWithFrame:(CGRect)frame browserDelegate:(SGBrowserViewController *)browser; {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:(30.0/255.0) green:(37.0/255.0) blue:(45.0/255.0) alpha:(1.0)];
        _browser = browser;
        
        [KxMenu setTintColor:[UIColor colorWithRed:(20.0/255.0) green:(26.0/255.0) blue:(32.0/255.0) alpha:(1.0)]];
        
        __strong UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        btn.backgroundColor = [UIColor clearColor];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(switchToSideMenu) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _backButton = btn;
        _backButton.enabled = YES;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        btn.backgroundColor = [UIColor clearColor];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [btn addTarget:_browser action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = self.browser.canGoForward;
        [self addSubview:btn];
        _forwardButton = btn;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        btn.backgroundColor = [UIColor clearColor];
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"grip"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"grip-pressed"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(showBrowserMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _menuButton = btn;
        
        __strong SGSearchField *field = [[SGSearchField alloc] initWithFrame:CGRectMake(0, 0, 200., 30.)];
        field.delegate = self;
        [field.stopItem addTarget:self.browser action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
        [field.reloadItem addTarget:self.browser action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:field];
        _searchField = field;
        
        __strong SGSearchViewController *searchC = [[SGSearchViewController alloc] initWithStyle:UITableViewStylePlain];
        searchC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        searchC.delegate = self;
        _searchController = searchC;
        
        __strong NJKWebViewProgressView *pV = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 2)];
        pV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:pV];
        _progressView = pV;
        
        _bookmarks = [[UINavigationController alloc] initWithRootViewController:[FXBookmarkTableController new]];
    }
    return self;
}

-(void)switchToSideMenu{

    [DELEGATE.slideContainer toggleLeftSideMenuCompletion:nil];
}

-(void) addBottomView{


}

- (IBAction)showBrowserMenu:(id)sender; {
    UIView *sv = sender;
    
    
    NSMutableArray *menuItems = [NSMutableArray arrayWithCapacity:5];
    [menuItems addObject:[KxMenuItem menuItem:NSLocalizedString(@"Bookmarks", @"Bookmarks")
                                        image:[UIImage imageNamed:@"bookmark"]
                                       target:self
                                       action:@selector(_showBookmarks)]];
    NSURL *url = [_browser URL];
    if (url) {
        [menuItems addObject:[KxMenuItem menuItem:NSLocalizedString(@"Share Page",
                                                                    @"Share url of page")
                                            image:[UIImage imageNamed:@"system"]
                                           target:self
                                           action:@selector(_showSharingUI)]];
        
        FXSyncItem *item = [[FXSyncStock sharedInstance] bookmarkForUrl:url];
        if (item == nil) {
            [menuItems addObject:[KxMenuItem menuItem:NSLocalizedString(@"Bookmark This Page",
                                                                        @"add a new bookmark")
                                                image:[UIImage imageNamed:@"favourite"]
                                               target:self
                                               action:@selector(_addRemoveBookmark)]];
        } else {
            [menuItems addObject:[KxMenuItem menuItem:NSLocalizedString(@"Remove This Bookmark",
                                                                        @"remove a bookmarked page")
                                                image:[UIImage imageNamed:@"un_favourite"]
                                               target:self
                                               action:@selector(_addRemoveBookmark)]];
        }
    }
    [menuItems addObject:[KxMenuItem menuItem:NSLocalizedString(@"Settings", @"Settings")
                                        image:[UIImage imageNamed:@"browserSettings"]
                                       target:self
                                       action:@selector(_showSyncSettings)]];

    
    CGRect rect = [_browser.view convertRect:sv.bounds fromView:sv];
    rect.size.height -= 10;
    [KxMenu showMenuInView:_browser.view
                  fromRect:rect
                 menuItems:menuItems];
}

- (void)_showBookmarks {
    [self presentMenuController:_bookmarks completion:NULL];
}

- (void)_addRemoveBookmark {
    NSURL *url = [_browser URL];
    FXSyncItem *item = [[FXSyncStock sharedInstance] bookmarkForUrl:url];
    if (item == nil && url != nil) {
        NSString *title = [[_browser selectedViewController] title];
        if (!title) {
            title = NSLocalizedString(@"Untitled", @"Title string");
        }
        [self presentMenuController:_bookmarks completion:^{
            FXBookmarkEditController *edit = [FXBookmarkEditController new];
            edit.bookmark = [[FXSyncStock sharedInstance] newBookmarkWithTitle:title url:url];
            [_bookmarks pushViewController:edit animated:YES];
        }];
        
    } else if (item != nil) {
        [[FXSyncStock sharedInstance] deleteBookmark:item];
    }
}

- (void)_showSharingUI {
    NSURL *url = [self.browser URL];
    
    if (url != nil) {
        TUSafariActivity *safari = [[TUSafariActivity alloc] init];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url]
                                                                                 applicationActivities:@[safari]];
        activityVC.completionHandler = ^(NSString *activityType, BOOL completed) {
            if (completed) {
//                [appDelegate.tracker send:[[GAIDictionaryBuilder createSocialWithNetwork:activityType
//                                                                                  action:@"Share URL"
//                                                                                  target:url.absoluteString] build]];
            }
        };
        [self presentMenuController:activityVC completion:NULL];
        
    }
}

- (void)_showSyncSettings {
    BOOL syncReady = [[FXSyncStock sharedInstance] hasUserCredentials];
    if (!syncReady) {
        FXLoginViewController* login = [FXLoginViewController new];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:login];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [_browser presentViewController:navController animated:YES completion:NULL];
    } else {
        FXSettingsViewController *settings = [FXSettingsViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settings];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [_browser presentViewController:nav animated:YES completion:NULL];
    }
}

- (void)updateInterface {
    if ([_browser canStopOrReload]) {
         _progressView.hidden = NO;
        [_progressView setProgress:[_browser progress] animated:YES];
        BOOL loading = [_browser isLoading];
        if (loading) {
            _searchField.state = SGSearchFieldStateStop;
        } else {
            _searchField.state = SGSearchFieldStateReload;
        }
    } else {
        _progressView.hidden = YES;
        _searchField.state = SGSearchFieldStateDisabled;
        
    }
}

- (void)presentSearchController; {}
- (void)presentMenuController:(UIViewController *)vc completion:(void(^)(void))completion;{}
- (void)dismissPresented; {
    [KxMenu dismissMenu];
}

#pragma mark - SGURLBarDelegate

- (NSString *)text {
    return _searchField.text;
}

- (void)finishSearch:(NSString *)searchString title:(NSString *)title {
    [self.browser handleURLString:searchString title:title];
    
    // Conduct the search. In this case, simply report the search term used.
    [self dismissPresented];
    [_searchField resignFirstResponder];
}

- (void)finishPageSearch:(NSString *)searchString {
    [self dismissPresented];
    [_searchField resignFirstResponder];
    [_browser findInPage:searchString];
}

- (void)userScrolledSuggestions {
    if ([_searchField isFirstResponder]
        && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [_searchField resignFirstResponder];
    }
}

@end
