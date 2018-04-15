//
//  SlideViewController.h
//  You tube app
//
//  Created by Asif Seraje on 6/8/15.
//  Copyright (c) 2015 Dhiman Das. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PGAlbumsController.h"
#import "PasswordViewController.h"
#import "NotesViewController.h"
#import "ContactListViewController.h"
#import "PasswordViewController.h"

@interface SlideViewController : UIViewController<MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sliderTableView;

+ (SlideViewController *)instance;


@property (strong, nonatomic) IBOutlet UILabel *downloadlabel;

@property (strong, nonatomic) IBOutlet UIView *downlodpopuoview;

@property (nonatomic, strong) UINavigationController *noteNav;
@property (nonatomic, strong) UINavigationController *albumNav;
@property (nonatomic, strong) UINavigationController *contactNav;
@property (nonatomic, strong) UINavigationController *passNav;
@property (nonatomic, strong) UINavigationController *downloadNav;
@property (nonatomic, strong) UINavigationController *passCodeNav;




@end
