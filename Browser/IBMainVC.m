//
//  IBMainVC.m
//  IconsWebBrowser
//
//  Created by Asif Seraje on 3/27/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IBMainVC.h"
#import "IBIconHandler.h"
#import "Helper.h"
#import "IBURLSuggestionVC.h"
#import "IBSiteIconButton.h"
#import "IBDesktopScrollView.h"
#import "IBDetachLayoutView.h"
#import "UIView+FrameUtils.h"
#import "SGPageViewController.h"
#import "SGAddiconViewController.h"

#import "FXSyncStock.h"

#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:30.0/255.0 green:37.0/255.0 blue:45.0/255.0 alpha:1.0]
#define APP_BG_COLOR [UIColor colorWithRed:20.0/255.0 green:26.0/255.0 blue:32.0/255.0 alpha:1.0]


BOOL isIPAD()
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType hasPrefix:@"iPhone"]) {
        return NO;
    } else if([deviceType hasPrefix:@"iPod touch"]) {
        return NO;
    } else {
        return YES;
    }
}

#define BG_VIEW_TAG 1001
#define DESKTOP_BG_TAG 1002
#define SITE_BG_TAG 1003
#define SITE_ICON_TAG 1004
#define SITE_NAME_TAG 1005
#define DELETE_BUTTON_TAG 1006
//#define APP_SEARCH_BAR_COLOR
#define SEARCH_BAR_HEIGHT 44
#define TOOLBAR_HEIGHT 44
#define SITE_NAME_LABEL_HEIGHT 20
#define PAGE_CONTROL_HEIGHT 30
#define ICON_HEIGHT_SUB 46


static NSInteger VERTICAL_ICON_NUMBER;
static NSInteger HORIZONTAL_ICON_NUMBER;
static CGFloat ICON_WIDTH;
static CGFloat ICON_HEIGHT;
static CGFloat ICON_MARGIN_X;
static CGFloat ICON_MARGIN_Y;
static NSInteger PAGE_ICON_NUMBER;

static CGSize bsize;

static IBMainVC *mainVC;

BOOL validateUrl(NSString *candidate) {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

struct IconsPosition {
    NSInteger x;
    NSInteger y;
};
typedef struct IconsPosition IconsPosition;

IconsPosition iconPosition(NSInteger idx) {
    IconsPosition pos;
    pos.x = idx / PAGE_ICON_NUMBER;
    pos.y = idx % PAGE_ICON_NUMBER;
    return pos;
}

CGRect iconOuterFrame(NSInteger idx) {
    NSInteger pageId = idx / PAGE_ICON_NUMBER;
    NSInteger index = idx % PAGE_ICON_NUMBER;
    return CGRectMake(ICON_MARGIN_X+(index%HORIZONTAL_ICON_NUMBER)*(ICON_WIDTH+ICON_MARGIN_X)+pageId*bsize.width-ICON_MARGIN_X/2, 
                      ICON_MARGIN_Y+(index/HORIZONTAL_ICON_NUMBER)*(ICON_HEIGHT+SITE_NAME_LABEL_HEIGHT+ICON_MARGIN_Y), 
                      ICON_WIDTH+ICON_MARGIN_X, 
                      ICON_HEIGHT+ICON_MARGIN_Y);
}

CGRect iconOuterBounds() {
    return CGRectMake(0, 0, ICON_WIDTH+ICON_MARGIN_X, ICON_HEIGHT+ICON_MARGIN_X);
}

CGRect iconFrame() {
    return CGRectMake(ICON_MARGIN_X/2, ICON_MARGIN_X/2, ICON_WIDTH, ICON_HEIGHT);
}

CGRect labelFrame() {
    return CGRectMake(0, ICON_MARGIN_X/2 + ICON_HEIGHT, ICON_WIDTH+ICON_MARGIN_X, SITE_NAME_LABEL_HEIGHT);
}

CGRect deleteFrame() {
    return CGRectMake(0, 0, 25, 25);
}

@interface IBMainVC()
{
    NSDate *lastFlipTime;
    UIView *outerView2;
}

@end

@implementation IBMainVC

- (id)init
{
    if (isIPAD()) {
        ICON_WIDTH = 70;
        ICON_HEIGHT = 70;
    } else {
        ICON_WIDTH = 57;
        ICON_HEIGHT = 57;
    }
    self = [super init];
    if (self) {
        IBDetachLayoutView *detachLayoutView = [[IBDetachLayoutView alloc] initWithViewController:self];
        self.view = detachLayoutView;
        
        self.view.backgroundColor = APP_BG_COLOR;
        
        iconMovingDone = YES;
        desktop = [[IBDesktopScrollView alloc] init];
        desktop.canCancelContentTouches = YES;
        desktop.delaysContentTouches = NO;
        desktop.pagingEnabled = YES;
        desktop.showsHorizontalScrollIndicator = NO;
        desktop.decelerationRate = 1.1;
        desktop.delegate = self;
        desktop.backgroundColor = APP_BG_COLOR;
        [self.view addSubview:desktop];
        
        pageControl = [[UIPageControl alloc] init];
        [pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:pageControl];
        
        UIButton *bodyBackgroundButton = [[UIButton alloc] init];
        bodyBackgroundButton.tag = DESKTOP_BG_TAG;
        bodyBackgroundButton.backgroundColor = APP_BG_COLOR;
        [bodyBackgroundButton addTarget:self action:@selector(editIconsDone) forControlEvents:UIControlEventTouchUpInside];
        [desktop addSubview:bodyBackgroundButton];
        
        siteOuterViews = [[NSMutableArray alloc] init];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

        button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        button.backgroundColor  = NAV_BAR_TINT_COLOR;
        button.enabled = YES;
        //button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
        button.showsTouchWhenHighlighted = YES;
        //[button setTitle:@"Back" forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor colorWithRed:(20/256.0) green:(26/256.0) blue:(32/256.0) alpha:1.0] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.tintColor = NAV_BAR_TINT_COLOR;
        [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        _backButton = button;
        _backButton.frame = CGRectMake(0,20,40,SEARCH_BAR_HEIGHT);
        
        
        
        _searchBar = [[UISearchBar alloc] init];
         _searchBar.frame = CGRectMake(40, 20, 280, SEARCH_BAR_HEIGHT);
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.placeholder = @"Address or Keywords";
        //_searchBar.barTintColor = [UIColor clearColor];//colorWithRed:(189/256.0) green:(189/256.0) blue:(195/256.0) alpha:1.0
        //_searchBar.backgroundColor = [UIColor clearColor];//colorWithRed:(189/256.0) green:(189/256.0) blue:(195/256.0) alpha:1.0
        UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
        txfSearchField.backgroundColor = APP_BG_COLOR;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.delegate = self;
        [_searchBar setBackgroundImage:[self imageFromColor:NAV_BAR_TINT_COLOR]
                            forBarPosition:0
                                barMetrics:UIBarMetricsDefault];
        //_searchBar.showsCancelButton = YES;
        [self.view addSubview:_searchBar];
        
        outerView2 = [[UIView alloc] init];
       // [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"addIcon"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(siteIconAdded:) name:@"SiteIconAdded" object:nil];
    }
    mainVC = self;
    return self;
}



- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 280, SEARCH_BAR_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - life style

-(void)viewDidLoad{

    //self.view.backgroundColor = [UIColor colorWithRed:(20/256.0) green:(20/256.0) blue:(20/256.0) alpha:(1.0)];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
    
    // For a bug: do not show new icon on the desktop after added
    UIView *v = [UIView new];
    [self.view addSubview:v];
    [v removeFromSuperview];
    
    [self initIcons];
    [self cancelSearch];


}

- (void)viewWillLayoutSubviews
{
    bsize = self.view.bounds.size;
    BOOL isPortait = bsize.width < bsize.height;
    
    if (isIPAD()) {
        if (isPortait) {
            HORIZONTAL_ICON_NUMBER = 6;
            VERTICAL_ICON_NUMBER = 8;
        } else {
            HORIZONTAL_ICON_NUMBER = 8;
            VERTICAL_ICON_NUMBER = 6;
        }
    } else {
        if (isPortait) {
            HORIZONTAL_ICON_NUMBER = 4;
            VERTICAL_ICON_NUMBER = 4;
        } else {
            HORIZONTAL_ICON_NUMBER = 6;
            VERTICAL_ICON_NUMBER = 2;
        }
    }
    
    ICON_MARGIN_X = (bsize.width-ICON_WIDTH*HORIZONTAL_ICON_NUMBER)/(HORIZONTAL_ICON_NUMBER+1);
    ICON_MARGIN_Y = (bsize.height-ICON_HEIGHT_SUB-(ICON_HEIGHT+SITE_NAME_LABEL_HEIGHT)*VERTICAL_ICON_NUMBER-PAGE_CONTROL_HEIGHT)/(VERTICAL_ICON_NUMBER+1);
    PAGE_ICON_NUMBER = VERTICAL_ICON_NUMBER * HORIZONTAL_ICON_NUMBER;
    
    NSInteger iconCount = [IBIconHandler sites].count;
    NSInteger pageCount = iconCount / PAGE_ICON_NUMBER + ((iconCount % PAGE_ICON_NUMBER) ? 1 : 0);
    pageControl.frame = CGRectMake(0, 0, MIN(30*pageCount, bsize.width), 20);
    pageControl.numberOfPages = pageCount;
    
    desktop.frame = CGRectMake(0, 64, bsize.width, bsize.height-SEARCH_BAR_HEIGHT);
    desktop.contentSize = CGSizeMake(desktop.frame.size.width*pageControl.numberOfPages, desktop.frame.size.height);
    pageControl.center = CGPointMake(bsize.width/2, bsize.height-PAGE_CONTROL_HEIGHT/2);
    [desktop viewWithTag:DESKTOP_BG_TAG].frame = desktop.bounds;
    self.view.backgroundColor = [UIColor colorWithRed:(20/256.0) green:(26/256.0) blue:(32/256.0) alpha:1.0];
//    _searchBar.frame = CGRectMake(40, 20, 280, SEARCH_BAR_HEIGHT);
    for (NSInteger i=0; i<siteOuterViews.count; i++) {
        UIView *outerView = [siteOuterViews objectAtIndex:i];
        outerView.frame = iconOuterFrame(i);
        [outerView viewWithTag:SITE_BG_TAG].frame = iconOuterBounds();
        [outerView viewWithTag:SITE_ICON_TAG].frame = iconFrame();
        [outerView viewWithTag:SITE_NAME_TAG].frame = labelFrame();
    }
    
    [desktop viewWithTag:DESKTOP_BG_TAG].frame = CGRectMake(0, 0, desktop.contentSize.width, desktop.contentSize.height);
}



-(void)viewDidAppear:(BOOL)animated{
//    UIButton *button2=[[UIButton alloc] initWithFrame:CGRectMake(0, 200, 44, 44)];
//    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    //button2.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
//    // button2.backgroundColor  = [UIColor whiteColor];
//    //        button.enabled = NO;
//    button2.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
//    button2.showsTouchWhenHighlighted = YES;
//    [button2 setTitle:@"New Tab" forState:UIControlStateNormal];
//    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //[button2 setImage:[UIImage imageNamed:@"plus-white"] forState:UIControlStateNormal];
//    //button2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    [button2 addTarget:self action:@selector(addTab) forControlEvents:UIControlEventTouchUpInside];
//    [desktop addSubview:button2];
//    [self.view bringSubviewToFront:button2];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - icons
- (void)initIcons
{

    
    NSArray *sites = [IBIconHandler sites];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"addIcon"]==YES) {
        [siteOuterViews removeLastObject];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"addIcon"];
        
    }
    
    for (NSInteger i=siteOuterViews.count; i<[sites count]; i++) {
        NSDictionary *site = [sites objectAtIndex:i];
        UIView *outerView = [[UIView alloc] init];

        //outerView.backgroundColor = APP_BG_COLOR;
        //outerView.backgroundColor = [UIColor whiteColor];
        [siteOuterViews addObject:outerView];
        
        UIButton *siteBGButton = [UIButton buttonWithType:UIButtonTypeCustom];
        siteBGButton.tag = SITE_BG_TAG;
        [siteBGButton addTarget:self action:@selector(editIconsDone) forControlEvents:UIControlEventTouchUpInside];
        [outerView addSubview:siteBGButton];
        
        UIButton *siteIconButton = [IBSiteIconButton buttonWithType:UIButtonTypeCustom];
        siteIconButton.tag = SITE_ICON_TAG;
        NSString *iconFile = [site objectForKey:@"icon"];
        
        NSString* iconpath=iconFile;
        if (![iconFile hasPrefix:@"/"]) {
            iconFile = [[NSBundle mainBundle] pathForResource:iconFile ofType:@"png"];
        }
        UIImage *img = [UIImage imageWithContentsOfFile:iconFile];
        if (img == nil) {
            
            NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [docpaths objectAtIndex:0];
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",iconpath]];
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
            img = [[UIImage alloc] initWithData:imgData];
        }
        img = [Helper createRoundedRectImage:img size:CGSizeMake(ICON_WIDTH*2, ICON_HEIGHT*2) radius:20];
        [siteIconButton setImage:img forState:UIControlStateNormal];
        [siteIconButton addTarget:self action:@selector(iconTouched:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(editIcons:)];
        [siteIconButton addGestureRecognizer:gesture];
        [outerView addSubview:siteIconButton];
        
        UILabel *siteNameLabel = [[UILabel alloc] init];
        siteNameLabel.tag = SITE_NAME_TAG;
        siteNameLabel.text = [site objectForKey:@"name"];
        siteNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
        siteNameLabel.textColor = [UIColor colorWithRed:(156/256.0) green:(156/256.0) blue:(156/256.0) alpha:1.0];
        siteNameLabel.textAlignment = UITextAlignmentCenter;
        siteNameLabel.backgroundColor = [UIColor clearColor];
        [outerView addSubview:siteNameLabel];
        [desktop addSubview:outerView];
        outerView.tag = i;
        //outerView2.tag=i;
        
    }
    
    [siteOuterViews addObject:outerView2];
    
    UIButton *siteaddIconButton = [IBSiteIconButton buttonWithType:UIButtonTypeCustom];
    siteaddIconButton.tag = SITE_ICON_TAG;
    [siteaddIconButton setImage:[UIImage imageNamed:@"add_more"] forState:UIControlStateNormal];
    [siteaddIconButton setBackgroundColor:[UIColor whiteColor]];
    [siteaddIconButton addTarget:self action:@selector(addiconTouched:) forControlEvents:UIControlEventTouchUpInside];
    siteaddIconButton.backgroundColor = APP_BG_COLOR;
    [outerView2 addSubview:siteaddIconButton];
    
    UILabel *siteNameLabel = [[UILabel alloc] init];
    siteNameLabel.tag = SITE_NAME_TAG;
    siteNameLabel.text = @"Add";
    siteNameLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    siteNameLabel.textColor = [UIColor whiteColor];
    siteNameLabel.textAlignment = UITextAlignmentCenter;
    siteNameLabel.backgroundColor = [UIColor clearColor];
    outerView2.tag=149;
    //outerView2.backgroundColor = [UIColor whiteColor];
    [outerView2 addSubview:siteNameLabel];
    desktop.backgroundColor = [UIColor colorWithRed:(255/256.0) green:(255/256.0) blue:(255/256.0) alpha:1.0];
    [desktop addSubview:outerView2];
    
    
}

- (void)doShakeIcons:(NSNumber *)ancle
{
    for (NSInteger i=0; i<[siteOuterViews count]; i++) {
        UIView *siteOuterView = [siteOuterViews objectAtIndex:i];
        IconsPosition pos = iconPosition(i);
        NSInteger dir = (pos.x + pos.y) % 2 ? 1 : -1;
        
        if (iconMoving && siteOuterView == movingOuter) {
            continue;
        }
        
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:ancle.floatValue*dir];
        rotationAnimation.duration = 0.1;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [siteOuterView.layer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
    }
}

- (void)shakeIcons
{
    NSInteger pole = 1;
    while (iconEditing) {
        
        for (UIView *i in siteOuterViews){
            if([i isKindOfClass:[UIView class]]){
                UIView *newLbl = (UIView *)i;
                if(newLbl.tag == 149){
                    NSLog(@"hjdsa");
                    [siteOuterViews removeLastObject];
                    
                    /// Write your code
                }
            }
        }

        NSNumber *ancle = [NSNumber numberWithFloat:3.0/180*M_PI*pole];
        NSThread *doShakeThread = [[NSThread alloc] initWithTarget:self selector:@selector(doShakeIcons:) object:ancle];
        [doShakeThread start];
        pole *= -1;
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)editIcons:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (!iconEditing) {
            iconEditing = YES;
            iconMovingDone = NO;
            
            NSInteger idx = gesture.view.superview.tag;
            UIView *siteOuterView = [siteOuterViews objectAtIndex:idx];
            
            UIGraphicsBeginImageContextWithOptions(siteOuterView.bounds.size, NO, 2);
            [siteOuterView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            movingSiteIcon = [[UIImageView alloc] initWithImage:iconImage];
            CGRect frame = siteOuterView.frame;
            frame.origin = CGPointZero;
            movingSiteIcon.frame = frame;
            [siteOuterView addSubview:movingSiteIcon];
            [desktop bringSubviewToFront:siteOuterView];
            movingOuter = siteOuterView;
            
            [UIView animateWithDuration:.3 animations:^{
                movingOuter.transform = CGAffineTransformScale(movingOuter.transform, 1.2, 1.2);
            }];
            
            NSArray *sites = [IBIconHandler sites];
            for (NSInteger i=0; i<[sites count]; i++) {
                UIButton *deleteButton = [[UIButton alloc] initWithFrame:deleteFrame()];
                [deleteButton setImage:[UIImage imageNamed:@"icon-delete.png"] forState:UIControlStateNormal];
                deleteButton.tag = DELETE_BUTTON_TAG;
                [deleteButton addTarget:self action:@selector(removeIcon:) forControlEvents:UIControlEventTouchUpInside];
                UIView *siteOuterView = [siteOuterViews objectAtIndex:i];
                [siteOuterView addSubview:deleteButton];
            }
            lastMoveInto = idx;
            NSThread *shakeThread = [[NSThread alloc] initWithTarget:self selector:@selector(shakeIcons) object:nil];
            [shakeThread start];
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (iconMovingDone) {
            return;
        }
        CGPoint location = [gesture locationInView:desktop];
        CGPoint moved = CGPointMake(location.x-touchLocation.x, location.y-touchLocation.y);
        NSInteger idx = gesture.view.superview.tag;
        UIView *siteOuterView = [siteOuterViews objectAtIndex:idx];
        
        CGRect frame = siteOuterView.frame;
        frame.origin = CGPointMake(frame.origin.x+moved.x, frame.origin.y+moved.y);
        siteOuterView.frame = frame;
        
        NSInteger movedInto = [self checkMovingIndex];
        if (movedInto >= 0 && movedInto < siteOuterViews.count && movedInto != lastMoveInto) {
            [UIView animateWithDuration:.3 animations:^{
                for (NSInteger i=0; i<siteOuterViews.count; i++) {
                    if (i == idx) {
                        continue;
                    }
                    NSInteger curIdx = i;
                    if (movedInto > idx) {
                        if (i > idx && i <= movedInto) {
                            curIdx --;
                        }
                    } else {
                        if (i >= movedInto && i < idx) {
                            curIdx ++;
                        }
                    }
                    [[siteOuterViews objectAtIndex:i] setFrame:iconOuterFrame(curIdx)];
                }
            }];
            lastMoveInto = movedInto;
            iconMoving = YES;
        } else if (movedInto < 0) {
            iconMoving = YES;
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if (iconMovingDone) {
            return;
        }
        iconMovingDone = YES;
        if (iconMoving) {
            iconEditing = NO;
        }
        
        [UIView animateWithDuration:.3 animations:^{
            NSInteger idx = gesture.view.superview.tag;
            UIView *siteOuterView;
            NSMutableArray *newSiteOuterViews = [[NSMutableArray alloc] initWithCapacity:siteOuterViews.count];
            NSMutableArray *newSites = [[NSMutableArray alloc] initWithCapacity:siteOuterViews.count];
            for (NSInteger i=0; i<siteOuterViews.count; i++) {
                NSInteger curIdx;
                if (lastMoveInto > idx) {
                    if (i < idx) {
                        curIdx = i;
                    } else if (i < lastMoveInto) {
                        curIdx = i + 1;
                    } else if (i == lastMoveInto) {
                        curIdx = idx;
                    } else {
                        curIdx = i;
                    }
                } else {
                    if (i < lastMoveInto) {
                        curIdx = i;
                    } else if (i == lastMoveInto) {
                        curIdx = idx;
                    } else if (i <= idx) {
                        curIdx = i - 1;
                    } else {
                        curIdx = i;
                    }
                }
                siteOuterView = [siteOuterViews objectAtIndex:curIdx];
                if (iconMoving) {
                    [[siteOuterView viewWithTag:DELETE_BUTTON_TAG] removeFromSuperview];
                }
                [siteOuterView setFrame:iconOuterFrame(i)];
                siteOuterView.tag = i;
                [newSiteOuterViews addObject:siteOuterView];
                
                id site = [[IBIconHandler sites] objectAtIndex:curIdx];
                [newSites addObject:site];
            }
            siteOuterViews = newSiteOuterViews;
            [IBIconHandler saveNewSites:newSites];
            
            [UIView animateWithDuration:.3 animations:^{
                movingOuter.transform = CGAffineTransformScale(movingOuter.transform, 1.0/1.2, 1.0/1.2);
                [movingOuter frameMoveByDelta:CGPointMake(-movingOuter.bounds.size.width*.1, -movingOuter.bounds.size.height*.1)];
            }];
        }];
        
        [movingSiteIcon removeFromSuperview];
        movingSiteIcon = nil;
        iconMoving = NO;
    }
    touchLocation = [gesture locationInView:desktop];
}

- (NSInteger)checkMovingIndex
{
    CGSize wbs = self.view.bounds.size;
    
    for (NSInteger i=0; i<siteOuterViews.count; i++) {
        CGRect outerFrame = iconOuterFrame(i);
        CGRect movingFrame = movingSiteIcon.superview.frame;
        if ((lastFlipTime == nil || [lastFlipTime timeIntervalSinceNow] < -1.5) && 
            movingFrame.origin.x + ICON_MARGIN_X/2 - pageControl.currentPage * wbs.width < 0 && 
            pageControl.currentPage > 0) {
            CGPoint prevPageOffset = CGPointMake(desktop.contentOffset.x-wbs.width, desktop.contentOffset.y);
            [desktop setContentOffset:prevPageOffset animated:YES];
            pageControl.currentPage -= 1;
            lastFlipTime = [NSDate dateWithTimeIntervalSinceNow:0];
        } else if ((lastFlipTime == nil || [lastFlipTime timeIntervalSinceNow] < -1.5) && 
            movingFrame.origin.x + movingFrame.size.width - ICON_MARGIN_X/2 > (pageControl.currentPage + 1) * wbs.width && 
            movingFrame.origin.x + ICON_MARGIN_X/2 > 0 && 
            pageControl.currentPage < pageControl.numberOfPages - 1) {
            CGPoint nextPageOffset = CGPointMake(desktop.contentOffset.x+wbs.width, desktop.contentOffset.y);
            [desktop setContentOffset:nextPageOffset animated:YES];
            pageControl.currentPage += 1;
            lastFlipTime = [NSDate dateWithTimeIntervalSinceNow:0];
        }
        if (movingFrame.origin.x > outerFrame.origin.x - ICON_MARGIN_X - ICON_WIDTH/2 && 
            movingFrame.origin.y > outerFrame.origin.y - ICON_MARGIN_Y &&
            movingFrame.origin.x < outerFrame.origin.x + ICON_WIDTH/2 &&
            movingFrame.origin.y < outerFrame.origin.y + ICON_MARGIN_Y) {
            return i;
        }
    }
    return -1;
}

- (void)editIconsDone
{
//    [siteOuterViews addObject:outerView2];

    if (iconEditing) {
        iconEditing = NO;
        for (UIView *siteOuterView in siteOuterViews) {
            [[siteOuterView viewWithTag:DELETE_BUTTON_TAG] removeFromSuperview];
        }
        [movingSiteIcon removeFromSuperview];
        movingSiteIcon = nil;
    }
}

- (void)addiconTouched:(UIButton *)icon{

    NSLog(@"Add icon touched");
    UIInterfaceOrientation toInterfaceOrientation = self.interfaceOrientation;
    if ( UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        
        SGAddiconViewController* addIcon=[[SGAddiconViewController alloc] initWithNibName:@"SGAddiconViewControllerland" bundle:nil];
        //    [self dismissViewControllerAnimated:YES completion:nil];
        
        [self presentViewController:addIcon animated:YES completion:nil];

    }
    else{
    SGAddiconViewController* addIcon=[[SGAddiconViewController alloc] initWithNibName:@"SGAddiconViewController" bundle:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];

    [self presentViewController:addIcon animated:YES completion:nil];
    }
}

//-(void)selfDismiss{
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)iconTouched:(UIButton *)icon
{
    if (iconEditing) {
        [self editIconsDone];
        return;
    }
    NSArray *sites = [IBIconHandler sites];
    NSInteger idx = icon.superview.tag;
    NSDictionary *site = [sites objectAtIndex:idx];
    NSURL *url = [NSURL URLWithString:[site objectForKey:@"url"]];
    NSString *string=[site objectForKey:@"name"];
    
    NSDictionary* urlDict=[[NSDictionary alloc]initWithObjectsAndKeys:url,@"uri",string,@"title", nil];
    
   // NSURLRequest* req=[NSURLRequest requestWithURL:url];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"siteINFO"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"flag"];

    if (webVC == nil) {
        //webVC = [[IBWebVC alloc] initWithURL:url];
    } else {
        //[webVC renewWithURL:url];
    }
    
//    [self.delegate finishPageSearch:[site objectForKey:@"url"]];
    [[NSNotificationCenter defaultCenter]
     addObserver:_browserViewController
     selector:@selector(_openURLWithArgs:)
     name:nil
     object:urlDict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFXOpenURLNotification object:urlDict];

    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

- (void)resetIconsLocationForSites:(NSArray *)sites fromIndex:(NSInteger)idx
{
    if (sites == nil) {
        sites = [IBIconHandler sites];
    }
}

- (void)removeIcon:(UIButton *)deleteButton
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete site" message:@"Make sure to delete this site?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
    alertView.tag = deleteButton.superview.tag;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSInteger idx = alertView.tag;
        
        NSArray *sites = [IBIconHandler sites];
        NSMutableArray *newSites = [NSMutableArray arrayWithArray:sites];
        
        UIView* view=[siteOuterViews objectAtIndex:[newSites count]-1];

        
        [newSites removeObjectAtIndex:idx];
        [IBIconHandler saveNewSites:newSites];
        
        
        
        [[siteOuterViews objectAtIndex:idx] removeFromSuperview];
        [siteOuterViews removeObjectAtIndex:idx];
       
        
        NSLog(@"%f %f",view.frame.origin.x,view.frame.origin.y);
        [UIView animateWithDuration:.3 animations:^{
            [outerView2 setFrame:view.frame];

        }];
        
        [UIView animateWithDuration:.3 animations:^{
            for (NSInteger i=idx; i<newSites.count; i++) {
                [[siteOuterViews objectAtIndex:i] setFrame:iconOuterFrame(i)];               
                [[siteOuterViews objectAtIndex:i] setTag:i];
            }
            
            if (newSites.count % PAGE_ICON_NUMBER == 0 && newSites.count) {
                desktop.contentSize = CGSizeMake(desktop.contentSize.width-self.view.bounds.size.width, desktop.contentSize.height);
                pageControl.numberOfPages = pageControl.numberOfPages - 1;
            }
        }];
    }
}

- (void)siteIconAdded:(NSDictionary *)siteInfo
{
    if (![IBIconHandler sites].count ) {
        desktop.contentSize = CGSizeMake(desktop.contentSize.width+self.view.bounds.size.width, desktop.contentSize.height);
        pageControl.numberOfPages = pageControl.numberOfPages + 1;
    }
    NSDictionary *site = [siteInfo mutableCopy];
    [IBIconHandler addNewSite:site];
    
    for (NSInteger i=0; i<siteOuterViews.count; i++) {
        [[siteOuterViews objectAtIndex:i] setTag:i];
    }
}

#pragma mark - search bar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self cancelSearch];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_backButton removeFromSuperview];
    _backButton.hidden = YES;
    _backButton = nil;

    [UIView animateWithDuration:0.3 animations:^{

        _searchBar.frame = CGRectMake(0, 20, 320, SEARCH_BAR_HEIGHT);
        _searchBar.showsCancelButton=YES;

    }];
    

    
    if (bgView) {
        [bgView removeFromSuperview];
        [self.view addSubview:bgView];
        _backButton.hidden = YES;
        bgView.hidden = NO;
    } else {
//        _searchBar.frame = CGRectMake(0, 20, 320, 44);

        bgView = [[UIButton alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y+searchBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-ICON_HEIGHT_SUB)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        bgView.tag = BG_VIEW_TAG;
        [self.view addSubview:bgView];
        [bgView addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    }
    [self suggest];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self suggest];
}

- (void)suggest
{
    if (suggestionVC == nil) {
        suggestionVC = [[IBURLSuggestionVC alloc] initWithFrame:CGRectMake(_searchBar.frame.origin.x, _searchBar.frame.origin.y+_searchBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-ICON_HEIGHT_SUB)];
        suggestionVC.delegate = self;
    }
    [suggestionVC loadWithQuery:_searchBar.text];
    if (suggestionVC.suggestions.count) {
        [self.view addSubview:suggestionVC.view];
    } else {
        [suggestionVC.view removeFromSuperview];
    }
}

- (void)suggestionDidSelectedURL:(NSString *)url withTitle:(NSString *)title
{
    [suggestionVC.view removeFromSuperview];
    NSURL *_url;
    if ([url hasPrefix:@"http"]) {
        _url = [NSURL URLWithString:url];
    } else {
        _url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", url]];
    }
//    if (webVC == nil) {
//        webVC = [[IBWebVC alloc] initWithURL:_url];
//    } else {
//        [webVC renewWithURL:_url];
//    }
//    [self presentModalViewController:webVC animated:YES];
    
    
    NSDictionary* urlDict=[[NSDictionary alloc]initWithObjectsAndKeys:url,@"uri",@"",@"title", nil];
    
    // NSURLRequest* req=[NSURLRequest requestWithURL:url];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"siteINFO"];
    if (webVC == nil) {
        //webVC = [[IBWebVC alloc] initWithURL:url];
    } else {
        //[webVC renewWithURL:url];
    }
    
    //    [self.delegate finishPageSearch:[site objectForKey:@"url"]];
    [[NSNotificationCenter defaultCenter]
     addObserver:_browserViewController
     selector:@selector(_openURLWithArgs:)
     name:nil
     object:urlDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFXOpenURLNotification object:urlDict];
    //    __strong SGBrowserViewController *browser;
    //    [_browserViewController addTab];
    //
    //
    //    browser = [SGPageViewController new];
    //
    //
    //    //[browser openRequest:req];
    //    //[page setExposeMode:YES];
    //   // [browser addTabWithURLRequest:req title:string ];
    //
    //    _browserViewController=browser;
    //    [self presentModalViewController:_browserViewController animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelSearch
{
    [_searchBar resignFirstResponder];
    bgView.hidden = YES;
    _searchBar.showsCancelButton = NO;
    [suggestionVC.view removeFromSuperview];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    button.backgroundColor  = NAV_BAR_TINT_COLOR;
    button.enabled = YES;
    //button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    button.showsTouchWhenHighlighted = YES;
    //[button setTitle:@"Back" forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor colorWithRed:(20/256.0) green:(26/256.0) blue:(32/256.0) alpha:1.0] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.tintColor = NAV_BAR_TINT_COLOR;
    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _backButton = button;
    _backButton.frame = CGRectMake(0,20,40,SEARCH_BAR_HEIGHT);

    [UIView animateWithDuration:0.3 animations:^{

        _searchBar.frame = CGRectMake(40, 20, 280, SEARCH_BAR_HEIGHT);


//        _searchBar.showsCancelButton=YES;
        
    }completion:^(BOOL finished) {


        _backButton.frame = CGRectMake(0,20,40,SEARCH_BAR_HEIGHT);

    }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSURL *url;
    if ([searchBar.text hasPrefix:@"http://"] || [searchBar.text hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:searchBar.text];
    } else {
        if (validateUrl([NSString stringWithFormat:@"http://%@", searchBar.text])) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", searchBar.text]];
        } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/search?q=%@", [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
            NSLog(@"%@",url);
        }
    }
    
    
    NSDictionary* urlDict=[[NSDictionary alloc]initWithObjectsAndKeys:url,@"uri",@"",@"title", nil];
    
    // NSURLRequest* req=[NSURLRequest requestWithURL:url];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"siteINFO"];
    if (webVC == nil) {
        //webVC = [[IBWebVC alloc] initWithURL:url];
    } else {
        //[webVC renewWithURL:url];
    }
    
    //    [self.delegate finishPageSearch:[site objectForKey:@"url"]];
    [[NSNotificationCenter defaultCenter]
     addObserver:_browserViewController
     selector:@selector(_openURLWithArgs:)
     name:nil
     object:urlDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFXOpenURLNotification object:urlDict];
    //    __strong SGBrowserViewController *browser;
    //    [_browserViewController addTab];
    //
    //
    //    browser = [SGPageViewController new];
    //
    //
    //    //[browser openRequest:req];
    //    //[page setExposeMode:YES];
    //   // [browser addTabWithURLRequest:req title:string ];
    //
    //    _browserViewController=browser;
    //    [self presentModalViewController:_browserViewController animated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
//    if (webVC == nil) {
//        webVC = [[IBWebVC alloc] initWithURL:url];
//    } else {
//        [webVC renewWithURL:url];
//    }
//    [self presentModalViewController:webVC animated:YES];
    
    
    [self resignFirstResponder];
    _searchBar.frame = CGRectMake(40, 20, 280, 44);
    _backButton.hidden = NO;
    
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
}

- (void)suggestionViewDidWillBeginDragging
{
    [_searchBar resignFirstResponder];
}

+ (IBMainVC *)sharedMainVC
{
    return mainVC;
}



- (void)pageChanged
{
    [UIView animateWithDuration:0.25 animations:^{
        [desktop setContentOffset:CGPointMake(pageControl.currentPage*desktop.bounds.size.width, 0)];
    }];
}

- (void)backButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
