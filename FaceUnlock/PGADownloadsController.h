//
//  PGADownloadsController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/3/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGWebViewController.h"
#import "RNRWebViewController.h"

@class PGADownloadsController;

@protocol PGADownloadsControllerDelegate <NSObject>

@end

@interface PGADownloadsController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate>

{
    
    NSString *renamestr;
    NSInteger * indexno;
     __weak id<PGADownloadsControllerDelegate> deleGate;
    
}
@property (weak, nonatomic) id<PGADownloadsControllerDelegate> deleGate;
@property (nonatomic, strong) RNRWebViewController *webVC;
@property (weak, nonatomic) IBOutlet UIView *aView;
-(void) switchToConfiguration;
-(void) switchToNormalMode;
-(void) switchToEditMode;



@end
