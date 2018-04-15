//
//  ContentViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/19/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController
@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic) int vcIndex;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *urlString;
@end
