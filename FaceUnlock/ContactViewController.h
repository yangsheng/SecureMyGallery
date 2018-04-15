//
//  ContactViewController.h
//  QRcode
//
//  Created by  Limited on 11/26/15.
//
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <CoreData/CoreData.h>
#import "SGAppDelegate.h"
#import "CoreDataManager.h"

@interface ContactViewController : UIViewController{
    
    __weak IBOutlet UILabel *label1;
    __weak IBOutlet UILabel *label2;
    __weak IBOutlet UILabel *label3;
    __weak IBOutlet UILabel *label4;
    __weak IBOutlet UILabel *label5;
    __weak IBOutlet UIButton *cancelbtn;
    __weak IBOutlet UIButton *createbtn;
}
@property (nonatomic, strong) NSString *placeText;
@property (nonatomic, strong) UIBarButtonItem *rightBarButton;
@property NSInteger tableIndexPath;

@property (strong) NSManagedObject *selectedObject;
@end
