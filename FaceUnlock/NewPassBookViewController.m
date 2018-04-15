//
//  NewPassBookViewController.m
//  PhotoVault
//
//  Created by Asif Seraje on 12/21/15.
//
//

#import "NewPassBookViewController.h"

#define APP_BG_COLOR [UIColor colorWithRed:20.0/255.0 green:26.0/255.0 blue:32.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:30.0/255.0 green:37.0/255.0 blue:45.0/255.0 alpha:1.0]

@interface NewPassBookViewController ()<UITextFieldDelegate,UITextViewDelegate>



@end

@implementation NewPassBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.showMeButton setImage:[UIImage imageNamed:@"show_me_btn"] forState:UIControlStateNormal];

    self.doNotShow = YES;
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = APP_BG_COLOR;
    //self.noteView.backgroundColor = NAV_BAR_TINT_COLOR;
    self.titleField.delegate=self;
    self.titleField.tag = 0;
    self.titleField.returnKeyType = UIReturnKeyNext;
    
    self.userNameField.delegate=self;
    self.userNameField.tag = 1;
    self.userNameField.returnKeyType = UIReturnKeyNext;
    
    self.passwordField.delegate=self;
    self.passwordField.tag = 2;
    self.passwordField.returnKeyType = UIReturnKeyNext;
    
    self.urlField.delegate=self;
    self.urlField.tag = 3;
    self.urlField.returnKeyType = UIReturnKeyNext;
    
    
    self.noteView.tag = 4;
    self.noteView.returnKeyType = UIReturnKeyDone;
    
    self.navigationController.navigationBar.translucent = NO;

    
    if (self.managedObject) {
        
        self.titleField.userInteractionEnabled = NO;
        self.userNameField.userInteractionEnabled = NO;
        self.passwordField.userInteractionEnabled = NO;
        self.urlField.userInteractionEnabled = NO;
        self.noteView.userInteractionEnabled = NO;
        self.showMeButton.userInteractionEnabled = NO;
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(updatePassBook)];
        [self.navigationItem setRightBarButtonItem:editButton];
        
        //[self.testLabel setText:self.noteString];
       // [self.noteView setText:self.noteString];
        if (self.managedObject) {
            [self.titleField setText:[self.managedObject valueForKey:@"title"]];
            [self.userNameField setText:[self.managedObject valueForKey:@"username"]];
            [self.passwordField setText:[self.managedObject valueForKey:@"password"]];
            [self.urlField setText:[self.managedObject valueForKey:@"website"]];
            [self.noteView setText:[self.managedObject valueForKey:@"note"]];
            
        
        }
        
    }
    else{
        
        
        self.passwordField.secureTextEntry = self.doNotShow;
        self.noteView.text = @"";
        [self.titleField becomeFirstResponder];
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePassBook)];
        [self.navigationItem setRightBarButtonItem:saveButton];
        self.navigationItem.rightBarButtonItem.enabled = NO;

    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.view endEditing:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Mark--Saving Note
-(NSManagedObjectContext *) managedObjectContext{
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate respondsToSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)savePassBook{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    
    
    
    if ([self.titleField.text length]==0 && [self.userNameField.text length]==0) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Empty "
                                              message:@"Write  Plz"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else{
        
        if (self.managedObject) {
            
            // Update existing Note
            
            [self.managedObject setValue:self.titleField.text forKey:@"title"];
            [self.managedObject setValue:self.userNameField.text forKey:@"username"];
            [self.managedObject setValue:self.passwordField.text forKey:@"password"];
            [self.managedObject setValue:self.urlField.text forKey:@"website"];
            [self.managedObject setValue:self.noteView.text forKey:@"note"];
           
            
            
        }
        else{
            NSManagedObject *newPassBook = [NSEntityDescription insertNewObjectForEntityForName:@"Password" inManagedObjectContext:context];
            [newPassBook setValue:self.titleField.text forKey:@"title"];
            [newPassBook setValue:self.userNameField.text forKey:@"username"];
            [newPassBook setValue:self.passwordField.text forKey:@"password"];
            [newPassBook setValue:self.urlField.text forKey:@"website"];
            [newPassBook setValue:self.noteView.text forKey:@"note"];
        }
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            
            
            
        }
    }
    
    
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark--updating notes

-(void)updatePassBook{
    
    self.titleField.userInteractionEnabled = YES;
    self.userNameField.userInteractionEnabled = YES;
    self.passwordField.userInteractionEnabled = YES;
    self.urlField.userInteractionEnabled = YES;
    self.noteView.userInteractionEnabled = YES;
    self.showMeButton.userInteractionEnabled = YES;
    [self.titleField becomeFirstResponder];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePassBook)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark-



#pragma mark - textfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    if(textField.tag == 0) {
//        [textField resignFirstResponder];
//        [lastNameF becomeFirstResponder];
//    }
//    if (textField.tag==1) {
//        [textField resignFirstResponder];
//        [emailF becomeFirstResponder];
//    }
//    if (textField.tag==2) {
//        [textField resignFirstResponder];
//        [phoneF becomeFirstResponder];
//    }
//    if (textField.tag==3) {
//        [textField resignFirstResponder];
//        [urlF becomeFirstResponder];
//    }
//    if (textField.tag==4) {
//        [textField resignFirstResponder];
//        //        [urlF becomeFirstResponder];
//    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        if (textField.tag==2 || textField.tag==3 || textField.tag==4) {
            
            [self animateTextField:textField up:YES];
            
        };
    }
    NSString *str = _titleField.text;
    if ([str length]>0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        if (textField.tag==2 || textField.tag==3 || textField.tag==4) {
            [self animateTextField:textField up:NO];
        }
        
        
    }
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark-

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
//        if (textField.tag==2 || textField.tag==3 ) {
//            
//            [self animateTextView: YES];
//            
//        };
//    }
//    NSString *str = self.userNameField.text;
//    if ([str length]>0) {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }
//    
//}

//-(void)animateTextField:(UITextField*)textField up:(BOOL)up
//{
//    const int movementDistance = -130; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement = (up ? movementDistance : -movementDistance);
//    
//    [UIView beginAnimations: @"animateTextField" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//}

- (IBAction)showMe:(id)sender {
    
    
    if (self.doNotShow) {
        self.passwordField.secureTextEntry = NO;
        //[self.showMeButton setTitle:@"Hide Me" forState:UIControlStateNormal];
        [self.showMeButton setImage:[UIImage imageNamed:@"hide_me_btn"] forState:UIControlStateNormal];

        self.doNotShow = NO;
    }
    else {
        self.passwordField.secureTextEntry = YES;
       // [self.showMeButton setTitle:@"Show Me" forState:UIControlStateNormal];
        [self.showMeButton setImage:[UIImage imageNamed:@"show_me_btn"] forState:UIControlStateNormal];

        self.doNotShow = YES;
    }
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //NSLog(@"Started");
    
        [self animateTextView: YES];

    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:NO];
}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
