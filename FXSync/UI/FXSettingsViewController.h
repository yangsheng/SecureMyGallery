//
//  FXSettingsViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 02.10.14.
//  Copyright (c) 2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FXSettingsViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *syncButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *bookmarksLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
- (IBAction)startSync:(id)sender;
- (IBAction)clearHistory:(id)sender;

@end
