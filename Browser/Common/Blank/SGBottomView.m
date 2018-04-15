//
//  SGBlankToolbar.m
//  Foxbrowser
//
//  Created by Asif Seraje on 30.07.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//
#import "SGBottomView.h"
#import "SGBlankController.h"
#import "SGPageViewController.h"
#import "SGPageToolbar.h"
#import "SGTabsToolbar.h"

@implementation SGBottomView{
    UIView *_groupView;
    UIView *_marker;
}
@dynamic markerPosititon;

- (instancetype)initWithFrame:(CGRect)frame browserDelegate:(SGBrowserViewController *)browser; {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = kSGBrowserBarColor;
        _browser = browser;
        
        
//        __strong UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        btn.backgroundColor = [UIColor clearColor];
//        btn.showsTouchWhenHighlighted = YES;
//        //[btn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//        [btn addTarget:_browser action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:btn];
        //_backButton = btn;
       // [_container1 updateInterface];

//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        btn.backgroundColor = [UIColor clearColor];
//        btn.showsTouchWhenHighlighted = YES;
//        //[btn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
//        [btn addTarget:_browser action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
       // btn.enabled = self.browser.canGoForward;
//        [self addSubview:btn];
//        _forwardButton = btn;
 
        
    }
    return self;
}



- (id)initWithTitles:(NSArray *)titles images:(NSArray *)images browserDelegate:(SGBrowserViewController *)browser; {
    
    NSString *fontName = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"HelveticaNeue" : @"HelveticaNeue-Light";
    CGFloat fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 10. : 16.;
    CGFloat height = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 40. : 55.;
    CGFloat margin = height/12;
    
    CGRect frame = CGRectMake(0, 0, 320., height);
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.backgroundColor = kSGBrowserBarColor;
        
        _browser = browser;
        
//        
//        __strong UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        btn.backgroundColor = [UIColor clearColor];
//        btn.showsTouchWhenHighlighted = YES;
//        //[btn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//        [btn addTarget:_browser action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//        
////        if (self.browser.canGoBack) {
////                    btn.enabled = self.browser.canGoBack;
////
////        }
////        else{
////        
////        }
//        //btn.enabled = self.browser.canGoBack;
//        btn.frame = CGRectMake(margin, margin,
//                                            frame.size.height - 2*margin, frame.size.height - 2*margin);
//
//        
////        [self addSubview:btn];
////        _backButton = btn;
//        
//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        btn.backgroundColor = [UIColor clearColor];
//        btn.showsTouchWhenHighlighted = YES;
//        [btn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
//        [btn addTarget:_browser action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
//        btn.frame = CGRectMake(CGRectGetMaxX(_backButton.frame) + margin, (frame.size.height - _backButton.frame.size.height)/2,
//                                                                    _backButton.frame.size.width, _backButton.frame.size.height);
//        
//        //btn.enabled = self.browser.canGoForward;
////        [self addSubview:btn];
////        _forwardButton = btn;
//        
//       // [self presss];
//
//        
//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        btn.backgroundColor = [UIColor clearColor];
//        btn.showsTouchWhenHighlighted = YES;
//        [btn setImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(presss) forControlEvents:UIControlEventTouchUpInside];
//        btn.frame = CGRectMake(CGRectGetMaxX(_forwardButton.frame) + margin+20, (frame.size.height - _forwardButton.frame.size.height)/2,
//                               _forwardButton.frame.size.width, _forwardButton.frame.size.height);
//        
//        
        //btn.enabled = self.browser.canGoForward;
//        [self addSubview:btn];
//        _homeButton=btn;
        
        //[_browser updateInterface];
       // [self addSubview:bottom];
//        UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
//        
//        logoView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
//        logoView.frame = CGRectMake(margin, margin,
//                                    frame.size.height - 2*margin, frame.size.height - 2*margin);
//        [self addSubview:logoView];
        
        
        
////        NSString *text = @"Foxbrowser";
//        UIFont *font = [UIFont fontWithName:fontName size:fontSize+3];
//        CGSize size;
//        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
//            size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
//        } else {
//            size = [text sizeWithFont:font];
//        }
//        UILabel *label = [[UILabel alloc] initWithFrame:
//                          CGRectMake(CGRectGetMaxX(logoView.frame) + margin, (frame.size.height - size.height)/2,
//                                     size.width, size.height)];
//        label.autoresizingMask =  UIViewAutoresizingFlexibleRightMargin;
//        label.backgroundColor = [UIColor clearColor];
//        label.font = font;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = text;
//        [self addSubview:label];
//
        //self.backgroundColor=[UIColor grayColor];
//        if (titles.count == 0)
//            return self;
//        
//        font = [UIFont fontWithName:fontName size:fontSize];
//        NSArray *sortedNames = [titles sortedArrayUsingComparator:^(id a, id b){
//            return [a length] > [b length] ? NSOrderedAscending : NSOrderedDescending;
//        }];
//        
//        // Use the largest string as the size for everything
//        size = [sortedNames[0] sizeWithFont:font];
//        size.width += 10;
//        
//        CGFloat groupWidth = size.width*titles.count;
//        CGRect gRect;
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//            gRect = CGRectMake(frame.size.width - groupWidth, 0, groupWidth, frame.size.height);
//        else
//            gRect = CGRectMake((frame.size.width - groupWidth)/2, 0, groupWidth, frame.size.height);
//        
//        _groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 510, 320, self.frame.size.height)];
//        _groupView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        _groupView.backgroundColor = [UIColor blackColor];
//        //[self addSubview:_groupView];
//        
//        CGFloat posX = 0.;
//        for (NSUInteger i = 0; i < titles.count; i++) {
//            NSString *title = titles[i];
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(posX, gRect.size.height - size.height,
//                                                              size.width, size.height)];
//            label.backgroundColor = [UIColor clearColor];
//            label.font = font;
//            label.text = title;
//            label.textAlignment = NSTextAlignmentCenter;
//            //[_groupView addSubview:label];
//            
//            if (i < images.count) {
//                UIImageView *imageV = [[UIImageView alloc] initWithImage:images[i]];
//                
//                imageV.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
//                CGFloat length = height - size.height;
//                imageV.frame = CGRectMake(posX + (size.width - length)/2, 0,
//                                          length, length);
//                //[_groupView addSubview:imageV];
//            }
//
//            posX += size.width;
//        }
//        
//        CGRect f = CGRectMake(0, 0, size.width, gRect.size.height);
//        _marker = [[UIView alloc] initWithFrame:f];
//        _marker.backgroundColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.9 alpha:0.4];
//        _marker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        
//        
       // [_groupView addSubview:_marker];
        
//        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                               action:@selector(handleTap:)];
//        [_groupView addGestureRecognizer:tapG];
        //[self addSubview:_groupView];
    }
    return self;
}



-(void)presss{
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Updatebtn"];
    //[_tabtool updateInterface];
    //[self updateButton];
    

}

- (void)updateButton {
    //[_container1 updateInterface];
    
    
    NSString *text = [NSString stringWithFormat:@"%lu", (unsigned long)self.browser.count];
    [_pagetool.tabsButton setTitle:text forState:UIControlStateNormal];
    if (self.forwardButton.enabled != self.browser.canGoBack) {
        self.backButton.enabled = self.browser.canGoBack;
    }
    if (self.forwardButton.enabled != self.browser.canGoForward) {
        //[UIView animateWithDuration:0.2 animations:^{
        self.forwardButton.enabled = self.browser.canGoForward;
        //[self _layout];
        //}];
    }
    
    
}

- (void)setMarkerPosititon:(CGFloat)posititon {
    CGFloat width = _marker.bounds.size.width;
    CGRect newF = CGRectMake(width*posititon, 0, width, self.bounds.size.height);
    _marker.frame = newF;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 2.5);
    CGContextSetRGBStrokeColor(contextRef, 0., 0., 0.5, 1.0);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width, 0.);
    CGContextAddPath(contextRef, path);
    CGContextStrokePath(contextRef);
    CGPathRelease(path);
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIView *group = sender.view;
        CGPoint location = [sender locationInView:group];
        if (location.x > group.bounds.size.width/2) {
            [self.container.scrollView setContentOffset:CGPointMake(SG_TAB_WIDTH, 0) animated:YES];
        } else if (location.x > 0) {
            [self.container.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

@end
