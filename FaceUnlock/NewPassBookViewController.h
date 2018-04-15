//
//  NewPassBookViewController.h
//  PhotoVault
//
//  Created by Asif Seraje on 12/21/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface NewPassBookViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UITextView *noteView;
@property  NSInteger pIndexpath;
@property (strong) NSManagedObject *managedObject;
- (IBAction)showMe:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showMeButton;
@property BOOL doNotShow;

@end
