//
//  IBMainVC.h
//  IconsWebBrowser
//
//  Created by Asif Seraje on 3/27/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBURLSuggestionVC.h"
#import "SGBrowserViewController.h"

@protocol SGMainpageDelegate <NSObject>

- (void)finishSearch:(NSString *)searchString title:(NSString *)title;
- (void)finishPageSearch:(NSString *)searchString;
- (NSString *)text;

@optional

@end

@class IBWebVC,SGPageViewController,SGBrowserViewController;
@interface IBMainVC : SGBrowserViewController <UISearchBarDelegate, UIScrollViewDelegate, UIAlertViewDelegate, IBURLSuggestionDelegate>
{
    BOOL iconEditing;
    BOOL iconMovingDone;
    BOOL iconMoving;
    NSMutableArray *siteOuterViews;
    NSMutableArray *siteIcons;
    NSMutableArray *siteIconBorders;
    NSMutableArray *siteLabels;
    NSMutableArray *siteDeleteButtons;
    UISearchBar *_searchBar;
    UIButton *bgView;
    IBWebVC *webVC;
    CGPoint touchLocation;
    UIImageView *movingSiteIcon;
    UIView *movingOuter;
    NSInteger lastMoveInto;
    UIScrollView *desktop;
    UIPageControl *pageControl;
    IBURLSuggestionVC *suggestionVC;
}

@property (weak, readonly, nonatomic) UIButton *backButton;
@property (weak, nonatomic) SGPageViewController *browserViewController;
@property (nonatomic, weak) id<SGMainpageDelegate> delegate;

- (void)iconTouched:(UIButton *)icon;
- (void)editIcons:(UILongPressGestureRecognizer *)gesture;
- (void)editIconsDone;
- (void)removeIcon:(UIButton *)deleteButton;
- (void)initIcons;
- (void)cancelSearch;
- (void)siteIconAdded:(NSDictionary *)siteInfo;
- (void)resetIconsLocationForSites:(NSArray *)sites fromIndex:(NSInteger)idx;
- (NSInteger)checkMovingIndex;
- (void)pageChanged;
- (void)shakeIcons;
- (void)doShakeIcons:(NSNumber *)ancle;
- (void)viewWillLayoutSubviews;
-(void)selfDismiss;

+ (IBMainVC *)sharedMainVC;
@end
