//
//  WizardPatternController.m
//  FaceUnlock
//
//  Created by Asif Seraje on 12/28/11.
//  Copyright (c) 2011 Asif Seraje. All rights reserved.
//

#import "WizardPatternController.h"
#import "EHFAuthenticator.h"


@interface WizardPatternController()

@property (strong, nonatomic) IBOutlet UIImageView *patternBackground;
@property (strong, nonatomic) IBOutlet UILabel *helpLabel;
@property (strong, nonatomic) IBOutlet PatternView *patternView;

@property (nonatomic, strong) NSString *definedPattern;

-(void) resetUserInterface;
-(void) close;

-(void) switchToUnlock;
-(void) switchToErrorUnlock;
-(void) switchToDefine;
-(void) switchToErrorDefine;
-(void) switchToVerify;
-(void) switchToErrorVerify;
-(void) switchToFinish;

@end

@implementation WizardPatternController

#pragma mark - Properties

@synthesize patternBackground = _patternBackground;
@synthesize helpLabel = _helpLabel;
@synthesize patternView = _patternView;

@synthesize definedPattern = _definedPattern;
@synthesize currentState = _currentState;

#pragma mark - View Methods

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    //Reset user interface
    [self resetUserInterface];
    
    //Reset state
    if (self.currentState == PATTERN_STATE_LOGIN)
        [self switchToUnlock];
    else if (self.currentState == PATTERN_STATE_DEFINE)
        [self switchToDefine];
    else if (self.currentState == PATTERN_STATE_VERIFY)
        [self switchToVerify];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    [self.patternView setCenter:CGPointMake(384, 512)];
    [self.patternBackground setCenter:CGPointMake(384, 512)];

    }
    
    
    NSError * error = nil;
    
    [[EHFAuthenticator sharedInstance] setReason:@"Because i can"];
    // [[EHFAuthenticator sharedInstance] setFallbackButtonTitle:@"Enter Password"];
    [[EHFAuthenticator sharedInstance] setUseDefaultFallbackTitle:YES];
    
    if (![EHFAuthenticator canAuthenticateWithError:&error]) {
       [authenticationButton setEnabled:NO];
        NSString * authErrorString = @"Check your Touch ID Settings.";
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case LAErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case LAErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
    }

    bool wizard = [[NSUserDefaults standardUserDefaults] boolForKey: @"touch_btn"];
    if (wizard)
    {
        [authenticationButton setHidden:NO];
    }
    else
        [authenticationButton setHidden:YES];

    
    
}




- (IBAction)authenticate:(id)sender {
    
    
    [[EHFAuthenticator sharedInstance] authenticateWithSuccess:^(){
        
        self.helpLabel.text = @"Pattern accepted";
        [self performSelector: @selector(switchToFinish) withObject:nil afterDelay:1];
    } andFailure:^(LAError errorCode){
        NSString * authErrorString;
        switch (errorCode) {
            case LAErrorSystemCancel:
                authErrorString = @"System canceled auth request due to app coming to foreground or background.";
                break;
            case LAErrorAuthenticationFailed:
                authErrorString = @"User failed after a few attempts.";
                break;
            case LAErrorUserCancel:
                authErrorString = @"User cancelled.";
                break;
                
            case LAErrorUserFallback:
                authErrorString = @"Fallback auth method should be implemented here.";
                break;
            case LAErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case LAErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case LAErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
        [self presentAlertControllerWithMessage:authErrorString];
    }];
}

-(void) presentAlertControllerWithMessage:(NSString *) message{
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ROFL"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
  //  [alert show];
}


#pragma mark - Methods

-(void) resetUserInterface {
    if (self.currentState == PATTERN_STATE_LOGIN) {        
        //Custom title
        self.navigationItem.title = @"Pattern Login";
        
        //Left and right button
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        //Custom left button
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Close" style: UIBarButtonItemStylePlain target:self action:@selector(close)];
        
        //Customer next button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Finish" style: UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
        
        //Custom title
        self.navigationItem.title = @"Pattern Login";
    
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(20/255.0) green:(20/255.0) blue:(20/255.0) alpha:1] ;
        
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
       // self.navigationController.navigationBar.translucent = YES;
        
    
    
    }
}

-(void) close {
    //Wizard
    [[NSUserDefaults standardUserDefaults] setBool: FALSE forKey: @"wizardInProgress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Dismiss modal view controller
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) dismiss {
    //Save pattern to preferences
    [[NSUserDefaults standardUserDefaults] setObject: self.definedPattern forKey: @"definedPattern"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Wizard
    [[NSUserDefaults standardUserDefaults] setBool: FALSE forKey: @"wizardInProgress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Dismiss modal view controller
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Login Stage

-(void) switchToUnlock {
    //Update label
    self.helpLabel.text = @"Draw the login pattern";
    
    //Turn pattern to green
    [self.patternView setCurrentDrawMode: PATTERN_DRAW_GREEN];
    
    //Reset pattern view
    [self.patternView resetPattern];
    
    //Pattern view can be used
    self.patternView.userInteractionEnabled = TRUE;
    
    //Set current state
    self.currentState = PATTERN_STATE_LOGIN;    
}

-(void) switchToErrorUnlock {
    //Help label
    self.helpLabel.text = @"Your pattern did not match";
    
    //Turn pattern to red
    [self.patternView setCurrentDrawMode: PATTERN_DRAW_RED];
    
    //Disable use
    self.patternView.userInteractionEnabled = FALSE;
    
    //Schedule reset
    [self performSelector: @selector(switchToUnlock) withObject:nil afterDelay:1.5];      
}

#pragma mark - Define stage

-(void) switchToDefine {
    //Update label
    self.helpLabel.text = @"Draw new login pattern";
    
    //Turn pattern to green
    [self.patternView setCurrentDrawMode: PATTERN_DRAW_GREEN];
    
    //Reset pattern view
    [self.patternView resetPattern];
    
    //Pattern view can be used
    self.patternView.userInteractionEnabled = TRUE;
    
    //Set current state
    self.currentState = PATTERN_STATE_DEFINE;
}

-(void) switchToErrorDefine {
    //Help label
    self.helpLabel.text = @"Connect at least 4 dots";
    
    //Turn pattern to red
    [self.patternView setCurrentDrawMode: PATTERN_DRAW_RED];
    
    //Disable use
    self.patternView.userInteractionEnabled = FALSE;
    
    //Schedule reset
    [self performSelector: @selector(switchToDefine) withObject:nil afterDelay:1.5];    
}

#pragma mark - Verify Stage

-(void) switchToVerify {
    //Update label
    self.helpLabel.text = @"Draw login pattern again";
    
    //Turn pattern to green
    [self.patternView setCurrentDrawMode: PATTERN_DRAW_GREEN];
    
    //Reset pattern view
    [self.patternView resetPattern];
    
    //Pattern view can be used
    self.patternView.userInteractionEnabled = TRUE;
    
    //Set current state
    self.currentState = PATTERN_STATE_VERIFY;
}

-(void) switchToErrorVerify {
    //Help label
    self.helpLabel.text = @"Try again";
    
    //Turn pattern to red
    [self.patternView setCurrentDrawMode: PATTERN_DRAW_RED];
    
    //Disable pattern
    self.patternView.userInteractionEnabled = FALSE;
    
    //Schedule reset
    [self performSelector: @selector(switchToVerify) withObject:nil afterDelay:1.5];   
}

#pragma mark - Finish Stage

-(void) switchToFinish {
    if (self.currentState == PATTERN_STATE_LOGIN) {        
        //Present photo gallery
        SGAppDelegate *delegate = (SGAppDelegate *) [[UIApplication sharedApplication] delegate];
        [delegate showPhotoGallery];     
    } else if (self.currentState == PATTERN_STATE_VERIFY) {
        //Help label
        self.helpLabel.text = @"Tap \"Finish\" to save configuration.";
        
        //Disable pattern
        self.patternView.userInteractionEnabled = FALSE;    
        
        //Enable next button
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
    } 
}

#pragma mark - PatternDelegate

-(void) patternView: (PatternView *) patternView startedWithPattern: (NSString *) pattern {
    self.helpLabel.text = @"Release finger when done";
}

-(void) patternView: (PatternView *) patternView continuedWithPattern: (NSString *) pattern {
    self.helpLabel.text = @"Release finger when done";    
}

-(void) patternView: (PatternView *) patternView finishedWithPattern: (NSString *) pattern {
    if (self.currentState == PATTERN_STATE_LOGIN) {
        //Read stored pattern
        self.definedPattern = [[NSUserDefaults standardUserDefaults] stringForKey: @"definedPattern"];
        if ([pattern isEqualToString: self.definedPattern])
        {
            self.helpLabel.text = @"Pattern accepted";
            [self performSelector: @selector(switchToFinish) withObject:nil afterDelay:1];
        
        }
        else {
            [self switchToErrorUnlock];
        }
    } else if (self.currentState == PATTERN_STATE_DEFINE) {
        if ([pattern length] >= 4) {
            self.helpLabel.text = @"Pattern recorded";
            self.definedPattern = pattern;
            [self performSelector: @selector(switchToVerify) withObject:nil afterDelay:1];
        } else {
            [self switchToErrorDefine];
        }
    } else if (self.currentState == PATTERN_STATE_VERIFY) {
        if ([pattern isEqualToString: self.definedPattern]) {
            self.helpLabel.text = @"Pattern recorded";
            [self performSelector: @selector(switchToFinish) withObject:nil afterDelay:1];
        } else {
            [self switchToErrorVerify];
        }
    }
}

#pragma mark - OS Events

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory

- (void)viewDidUnload{
    [self setPatternBackground:nil];
    [self setHelpLabel:nil];
    [self setPatternView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    //Release
    
    //Debug
    NSLog(@"[WizardPatternController dealloc]");
    
    //Super
}

@end
