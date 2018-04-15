//
//  ContactViewController.m
//  QRcode
//
//  Created by  Limited on 11/26/15.
//
//

#import "ContactViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/ABPerson.h>

@interface ContactViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>{
    
    __weak IBOutlet UITextField *fastNameF;
    __weak IBOutlet UITextField *lastNameF;
    __weak IBOutlet UITextField *emailF;
    __weak IBOutlet UITextField *phoneF;
    __weak IBOutlet UITextField *urlF;
    __weak IBOutlet UIButton *fastbtn;
    
    NSMutableDictionary *contactDictionary;

    NSString* qrStr;
    NSString *firstNameStr;
    NSString *lastNameStr;
    NSString *emailStr;
    NSString *phoneNumberStr;
    NSString *urlStr;
    int btnTag;
    UIActivityIndicatorView *activity;
    CoreDataManager *coreDataManager;
}
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UIImage *customImage = [UIImage imageNamed:@"site_btn.png"];
//    UIBarButtonItem *leftMenuBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(switchToSideMenu)];
//    [self.navigationItem setLeftBarButtonItem:leftMenuBtn];
    
    //NSLog(@"Contact Object == ==  %@",self.selectedObject);
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    

    if (self.selectedObject) {
        [fastNameF setText:[self.selectedObject valueForKey:@"firstName"]];
        [lastNameF setText:[self.selectedObject valueForKey:@"lastName"]];
        [emailF setText:[self.selectedObject valueForKey:@"email"]];
        [phoneF setText:[self.selectedObject valueForKey:@"phone"]];
        [urlF setText:[self.selectedObject valueForKey:@"url"]];
        
        self.rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editContact:)];
        [self.navigationItem setRightBarButtonItem:self.rightBarButton];
        //self.navigationItem.rightBarButtonItem.enabled = NO;
        fastNameF.userInteractionEnabled = NO;
        lastNameF.userInteractionEnabled = NO;
        emailF.userInteractionEnabled = NO;
        phoneF.userInteractionEnabled = NO;
        urlF.userInteractionEnabled = NO;
        fastbtn.userInteractionEnabled = NO;
        
    }
    else{
        self.rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveContact:)];
        [self.navigationItem setRightBarButtonItem:self.rightBarButton];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    
    fastNameF.delegate=self;
    fastNameF.tag = 0;
    fastNameF.returnKeyType = UIReturnKeyNext;

    lastNameF.delegate=self;
    lastNameF.tag = 1;
    lastNameF.returnKeyType = UIReturnKeyNext;

    emailF.delegate=self;
    emailF.tag = 2;
    emailF.returnKeyType = UIReturnKeyNext;

    phoneF.delegate=self;
    phoneF.tag = 3;
    phoneF.returnKeyType = UIReturnKeyNext;

    urlF.delegate=self;
    urlF.tag = 4;
    urlF.returnKeyType = UIReturnKeyDone;

    
    activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.frame=CGRectMake(self.view.center.x-20, self.view.center.y+30, 40, 40);
    // Update UI
    [fastNameF becomeFirstResponder];
    
    contactDictionary = [[NSMutableDictionary alloc]init];
    coreDataManager = [[CoreDataManager alloc]init];


}

-(void)saveContact:(id) sender{

    NSManagedObjectContext *context = [self managedObjectContext];

    if ([fastNameF.text length]==0 && [phoneF.text length]==0) {
        
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
        
        if (self.selectedObject) {
            
            // Update existing Note
            
            [self.selectedObject setValue:fastNameF.text forKey:@"firstName"];
            [self.selectedObject setValue:lastNameF.text forKey:@"lastName"];
            [self.selectedObject setValue:emailF.text forKey:@"email"];
            [self.selectedObject setValue:phoneF.text forKey:@"phone"];
            [self.selectedObject setValue:urlF.text forKey:@"url"];
            
            
            
        }
        else{
            NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
            [newContact setValue:fastNameF.text forKey:@"firstName"];
            [newContact setValue:lastNameF.text forKey:@"lastName"];
            [newContact setValue:emailF.text forKey:@"email"];
            [newContact setValue:phoneF.text forKey:@"phone"];
            [newContact setValue:urlF.text forKey:@"url"];
        }
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            
            
            
        }
    }
    
    
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//- (void)saveContactToAddressBook : (NSDictionary *) dict{
//    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    
//    if (self.selectedObject) {
//        
//    }
//    NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
//    
//    [newContact setValue:[dict valueForKey:@"fastN"] forKey:@"firstName"];
//    [newContact setValue:[dict valueForKey:@"lastN"] forKey:@"lastName"];
//    [newContact setValue:[dict valueForKey:@"emailN"] forKey:@"email"];
//    [newContact setValue:[dict valueForKey:@"phoneN"] forKey:@"phone"];
//    [newContact setValue:[dict valueForKey:@"url"] forKey:@"url"];
//    
//    NSError *error = nil;
//    if (![context save:&error]) {
//        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//        
//    }
//    
//    NSLog(@"data saved");
//    
//    //    [self fetchContactsFromDB];
//    
//    
//    
//}

-(void)editContact:(id)sender{

    fastNameF.userInteractionEnabled = YES;
    lastNameF.userInteractionEnabled = YES;
    emailF.userInteractionEnabled = YES;
    phoneF.userInteractionEnabled = YES;
    urlF.userInteractionEnabled = YES;
    fastbtn.userInteractionEnabled = YES;
    
    self.rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveContact:)];
    [self.navigationItem setRightBarButtonItem:self.rightBarButton];
    

}

-(void)switchToSideMenu{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[DELEGATE.slideContainer toggleLeftSideMenuCompletion:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"editExisting"]) {
    
        NSMutableArray* arr=[[NSMutableArray alloc] init];
//        NSLog(@"%@",self.placeText);
        NSRange fullRange = NSMakeRange(0, [self.placeText length]);
        [self.placeText enumerateSubstringsInRange:fullRange
                              options:NSStringEnumerationByLines
                           usingBlock:^(NSString *substring, NSRange substringRange,
                                        NSRange enclosingRange, BOOL *stop)
        {
            if (substring.length) {
                [arr addObject:substring];
            }
//            NSLog(@"%@ %@", substring, NSStringFromRange(substringRange));
        }];
        
        NSString *str=[arr objectAtIndex:0];
        NSArray* nameA= [str componentsSeparatedByString:@" "];
        
        fastNameF.text=[nameA objectAtIndex:0];
        lastNameF.text=[nameA objectAtIndex:1];
        emailF.text = [arr objectAtIndex:1];
        phoneF.text = [arr objectAtIndex:2];
        urlF.text = [arr objectAtIndex:3];
        

    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"editExisting"];

}


#pragma mark Actions
- (IBAction)dismissV:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)contactbtnAct:(UIButton*)sender {
//    
//    [activity removeFromSuperview];
//    [self.view addSubview:activity];
//    [activity startAnimating];
   
    // Present Address Picker
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (_addressBookController) {
            _addressBookController=nil;
        }

    _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
        
    }];
    
    
}



- (IBAction)createbtnAct:(id)sender {
    [contactDictionary setValue:fastNameF.text forKey:@"fastN"];
    [contactDictionary setValue:lastNameF.text forKey:@"lastN"];
    [contactDictionary setValue:emailF.text forKey:@"emailN"];
    [contactDictionary setValue:phoneF.text forKey:@"phoneN"];
    [contactDictionary setValue:urlF.text forKey:@"url"];

    [coreDataManager saveContactToAddressBook:contactDictionary];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Touch Event
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}



#pragma mark - textfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.tag == 0) {
        [textField resignFirstResponder];
        [lastNameF becomeFirstResponder];
    }
    if (textField.tag==1) {
        [textField resignFirstResponder];
        [emailF becomeFirstResponder];
    }
    if (textField.tag==2) {
        [textField resignFirstResponder];
        [phoneF becomeFirstResponder];
    }
    if (textField.tag==3) {
        [textField resignFirstResponder];
        [urlF becomeFirstResponder];
    }
    if (textField.tag==4) {
        [textField resignFirstResponder];
//        [urlF becomeFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        if (textField.tag==2 || textField.tag==3 || textField.tag==4) {
            
            [self animateTextField:textField up:YES];
            
        };
    }
    NSString *str = fastNameF.text;
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
        
        NSString *str = fastNameF.text;
        if ([str length]>0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
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


#pragma mark - ABPeoplePickerNavigationController Delegate method implementation

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"", @"", @"", @"", @"", @"", @"", @"",@""]
                                            forKeys:@[@"firstName", @"lastName", @"mobileNumber", @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city",@"URL"]];
    
    NSString *firstName;
    NSString *lastName;
    
    // get the first name
    firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    [contactInfoDict setObject:firstName forKey:@"firstName"];
    
    // get the last name
    lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    [contactInfoDict setObject:lastName forKey:@"lastName"];
    
    // Get the phone numbers as a multi-value property.
    ABMultiValueRef phonesRef =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty));
    
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
        CFRelease(phonesRef);

    }
    // Get Email
    ABMultiValueRef emailsRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    for (int i=0; i<ABMultiValueGetCount(emailsRef); i++) {
        CFStringRef currentEmailLabel = ABMultiValueCopyLabelAtIndex(emailsRef, i);
        CFStringRef currentEmailValue = ABMultiValueCopyValueAtIndex(emailsRef, i);
        
        if (CFStringCompare(currentEmailLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"homeEmail"];
        }
        
        if (CFStringCompare(currentEmailLabel, kABWorkLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"homeEmail"];
        }
        
        CFRelease(currentEmailLabel);
        CFRelease(currentEmailValue);
        CFRelease(emailsRef);

    }
    
    // Get the URL addresses as a multi-value property.
    ABMultiValueRef urlRef = ABRecordCopyValue(person, kABPersonURLProperty);
    for (int i=0; i<ABMultiValueGetCount(urlRef); i++) {
        CFStringRef currentEmailLabel = ABMultiValueCopyLabelAtIndex(urlRef, i);
        CFStringRef currentEmailValue = ABMultiValueCopyValueAtIndex(urlRef, i);
        
        if (CFStringCompare(currentEmailLabel, kABPersonHomePageLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"URL"];
        }
        if (CFStringCompare(currentEmailLabel, kABWorkLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentEmailValue forKey:@"URL"];
        }
        
        CFRelease(currentEmailLabel);
        CFRelease(currentEmailValue);
        CFRelease(urlRef);

    }

    fastNameF.text=[contactInfoDict valueForKey:@"firstName"];
    lastNameF.text=[contactInfoDict valueForKey:@"lastName"];
    emailF.text=[contactInfoDict valueForKey:@"homeEmail"];
    phoneF.text=[contactInfoDict valueForKey:@"homeNumber"];
    urlF.text=[contactInfoDict valueForKey:@"URL"];
    
    [self dismissViewControllerAnimated:YES completion:^(){}];
    [activity stopAnimating];
}

-(NSManagedObjectContext *) managedObjectContext{
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate respondsToSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [_addressBookController dismissViewControllerAnimated:YES completion:nil];
    [activity stopAnimating];
}

@end
