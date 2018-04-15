//
//  ContactListViewController.h
//  PhotoVault
//
//  Created by Asif Seraje on 12/20/15.
//
//

#import <UIKit/UIKit.h>
#import "ContactCell.h"
#import "CoreDataManager.h"

@interface ContactListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contactTable;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *tableSections;

@property (nonatomic, strong) NSMutableArray *tableSectionsAndItems;




@end
