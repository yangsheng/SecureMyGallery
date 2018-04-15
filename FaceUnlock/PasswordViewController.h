//
//  PasswordViewController.h
//  PhotoVault
//
//  Created by Asif Seraje on 12/14/15.
//
//

#import <UIKit/UIKit.h>
#import "SGAppDelegate.h"

@interface PasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *passTable;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UISearchController *searchController;


@end
