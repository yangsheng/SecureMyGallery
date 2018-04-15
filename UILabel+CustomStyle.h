//
//  UILabel+CustomStyle.h
//  UIAlertController-Custom-Style
//
//  Created by Asif Seraje on 12/16/14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UILabel (CustomStyle)

@property (nonatomic, copy) UIFont *appearanceFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *customBackgroundColour;
@property (nonatomic, strong) UIColor *customButtonTextColour;
@property (nonatomic, strong) UIColor *customTextColour;

@end
