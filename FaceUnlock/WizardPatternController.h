//
//  WizardPatternController.h
//  FaceUnlock
//
//  Created by Asif Seraje on 12/28/11.
//  Copyright (c) 2011 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternView.h"

typedef enum {
    PATTERN_STATE_DEFINE = 0,
    PATTERN_STATE_VERIFY = 1,
    PATTERN_STATE_LOGIN = 2
} PatternState;

@interface WizardPatternController : UIViewController<PatternDelegate>

{
    IBOutlet UIButton *authenticationButton;

}
@property (nonatomic, assign) PatternState currentState;

@end
