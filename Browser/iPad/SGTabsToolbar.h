//
//  SGTabTopView.h
//  SGTabs
//
//  Created by Asif Seraje on 07.06.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "SGToolbarView.h"

@interface SGTabsToolbar : SGToolbarView <UIPopoverControllerDelegate>


@property (strong, nonatomic, readonly) UIPopoverController *popoverController;
@property (weak, readonly, nonatomic) UIButton *backButton;
@property (weak, readonly, nonatomic) UIButton *forwardButton;
- (instancetype)initWithFrame:(CGRect)frame browserDelegate:(SGBrowserViewController *)browser;
- (void)updateInterface;
@end
