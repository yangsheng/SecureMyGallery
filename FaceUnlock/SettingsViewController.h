//
//  SettingsViewController.h
//  PhotoVault
//
//  Created by Asif Seraje on 12/13/15.
//
//

#import <UIKit/UIKit.h>
#import "KKPasscodeViewController.h"

@interface SettingsViewController : UIViewController<KKPasscodeViewControllerDelegate>

- (IBAction)uploadImageToDropBox:(id)sender;
- (IBAction)uploadImageToGDrive:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end
