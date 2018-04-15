//
//  PasswordViewController.m
//  PhotoVault
//
//  Created by Asif Seraje on 12/14/15.
//
//

#import "PasswordViewController.h"
#import "CoreDataManager.h"
#import "PasswordCell.h"
#import "NewPassBookViewController.h"
#import "Password.h"
#import "SearchResultsTableController.h"

#define APP_BG_COLOR [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define CELL_SEP_COLOR [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:31.0/255.0 green:37.0/255.0 blue:47.0/255.0 alpha:1.0]
#define CELL_SEL_COLOR [UIColor colorWithRed:14.0/255.0 green:19.0/255.0 blue:23.0/255.0 alpha:1.0]



@interface PasswordViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    
CoreDataManager *coreDataManager;
NSMutableArray *passwordListArray;
NSMutableArray *deleteListArray;
NSIndexPath *selectionIndex;
NSMutableIndexSet *indicesOfItemsToDelete;
NSMutableArray *searchResults;
    UIBarButtonItem *rightBarBtn;
    UIBarButtonItem *leftMenuBtn;
    NSMutableArray *filteredArray;

}
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) NSArray *filteredList;


@end

@implementation PasswordViewController

//
//  ContactListViewController.m
//  PhotoVault
//
//  Created by Asif Seraje on 12/20/15.
//
//


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *customImage = [UIImage imageNamed:@"menu"];
    UIImage *rightBarBtnImg = [UIImage imageNamed:@"plus"];
    self.navigationItem.title = @"Password";
    
    self.navigationController.navigationBar.translucent = NO;

    self.extendedLayoutIncludesOpaqueBars = YES;


    leftMenuBtn = [[UIBarButtonItem alloc]initWithImage:customImage style:UIBarButtonItemStylePlain target:self action:@selector(switchToSideMenu)];
    [self.navigationItem setLeftBarButtonItem:leftMenuBtn];
    rightBarBtn = [[UIBarButtonItem alloc]initWithImage:rightBarBtnImg style:UIBarButtonSystemItemAdd target:self action:@selector(createPassBook:)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    coreDataManager = [[CoreDataManager alloc]init];
    
    //[self.passTable setBackgroundView:nil];

    //self.passTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableBG"]];

    [self.passTable setBackgroundColor:[UIColor clearColor]];
//    self.passTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.passTable setSeparatorColor:CELL_SEP_COLOR];
    self.view.backgroundColor = APP_BG_COLOR;
    
    self.passTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    filteredArray = [[NSMutableArray alloc]init];
    [self initializeSearchController];
    
    self.passTable.delegate=self;
    self.passTable.dataSource=self;
}




- (void)initializeSearchController {
    
    
    //instantiate a UISearchController - passing in the search results controller table
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.hidesNavigationBarDuringPresentation = NO;

    //this view controller can be covered by theUISearchController's view (i.e. search/filter table)
    self.definesPresentationContext = YES;
    
    //
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.navigationController.navigationBar.hidden = NO;

    
    //define the frame for the UISearchController's search bar and tint
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.searchController.searchBar.tintColor = [UIColor blackColor];
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    
    for (UIView *subView in self.searchController.searchBar.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                searchBarTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                //set font color here
                searchBarTextField.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
                
                
                break;
            }
        }
    }
    
//    [[UITextField appearanceWhenContainedIn:[UISearchController class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    //add the UISearchController's search bar to the header of this table
    self.passTable.tableHeaderView = self.searchController.searchBar;
    
    
    //this ViewController will be responsible for implementing UISearchResultsDialog protocol method(s) - so handling what happens when user types into the search bar
    self.searchController.searchResultsUpdater = self;
    
    
    //this ViewController will be responsisble for implementing UISearchBarDelegate protocol methods(s)
    self.searchController.searchBar.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    passwordListArray = [[coreDataManager fetchPassBookFromDB]mutableCopy];
    [self.passTable reloadData];
}

-(void)createPassBook:(id)sender{
    
    //
    //    ContactViewController *contactVC = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:nil];
    //    contactVC.tableIndexPath = -1;
    //    [self presentViewController:contactVC animated:YES completion:nil];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Create PassBook"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* newContactAction = [UIAlertAction actionWithTitle:@"New PassBook" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self createNewPassBook];
                                                                 
                                                                 
                                                                 
                                                             }];
    
    UIAlertAction* editContactAction = [UIAlertAction
                                        actionWithTitle:@"Edit PassBook" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  if (passwordListArray.count>0) {
                                                                      [self editPassBook];
                                                                  }
                                                                  else{
                                                                  
                                                                  
                                                                      UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Please add First"
                                                                                                                                               message:nil
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
                                                                  
                                                                  
                                                              }];
    
    
    UIAlertAction * defaultAct = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * action) {
                                                            //                                                            NSLog(@"Cancel is clicked");
                                                        }];
    
    [alertController addAction:newContactAction];
    [alertController addAction:editContactAction];
    [alertController addAction:defaultAct];
    alertController.view.tintColor = [UIColor colorWithRed:(20/255.0) green:(26/255.0) blue:(32/255.0) alpha:1.0];
    
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [alertController
                                                     popoverPresentationController];
    if (popPresenter)
    {
        popPresenter.sourceView = self.view;
        popPresenter.sourceRect = self.view.bounds;
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
        [alertController.popoverPresentationController setPermittedArrowDirections:0];
    }
    [self presentViewController:alertController animated:YES completion:nil];
    alertController.view.tintColor = [UIColor colorWithRed:(20/255.0) green:(26/255.0) blue:(32/255.0) alpha:1.0];

    
}

-(void)createNewPassBook{
    
    NewPassBookViewController *newPassVC = [[NewPassBookViewController alloc]initWithNibName:@"NewPassBookViewController" bundle:nil];
    [self.navigationController pushViewController:newPassVC animated:YES];
    newPassVC.pIndexpath = -1;
   // [self presentViewController:newPassVC animated:YES completion:nil];
}

-(void)editPassBook{
    
    
    //UIImage* customImg = [UIImage imageNamed:@"site_btn.png"];
    
    UIBarButtonItem *_customButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(switchToNormalMode)];
    
    [self.navigationItem setLeftBarButtonItem:_customButton];
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemTrash target:self action: @selector(deleteItemFromCoreData)] animated: TRUE];
    [self.passTable setEditing:YES animated:YES];
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)deleteItemFromCoreData{
    
    NSArray *selectedRows = [self.passTable indexPathsForSelectedRows];
    
    BOOL deleteSpecificRows = selectedRows.count > 0;
    if (deleteSpecificRows)
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Password"];
        passwordListArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
        // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
        indicesOfItemsToDelete = [NSMutableIndexSet new];
        for (selectionIndex in selectedRows)
        {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
            NSLog(@"===integer %li",(long)selectionIndex.row);
            
            
            [context deleteObject:[passwordListArray objectAtIndex:selectionIndex.row]];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
            
        }
        [passwordListArray removeObjectsAtIndexes:indicesOfItemsToDelete];
        [self.passTable deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.passTable reloadData];
    // Delete the objects from our data model.
    
    
    // Tell the tableView that we deleted the objects
    if (!deleteSpecificRows) {
        [self switchToNormalMode];
    }
    
    if (passwordListArray.count==0) {
        [self switchToNormalMode];
    }
    
}

-(void)switchToSideMenu{
    
    [DELEGATE.slideContainer toggleLeftSideMenuCompletion:nil];
}

-(void) switchToNormalMode {
    UIImage *customImage = [UIImage imageNamed:@"menu"];
    UIImage *rightBarBtnImg = [UIImage imageNamed:@"plus"];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithImage:rightBarBtnImg style:UIBarButtonSystemItemAdd target:self action:@selector(createPassBook:)];
    UIBarButtonItem *customBtn = [[UIBarButtonItem alloc]initWithImage:customImage style:UIBarButtonItemStyleDone target:self action:@selector(switchToSideMenu)];
    [self.navigationItem setLeftBarButtonItem:customBtn];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    [self.passTable setEditing:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return searchResults.count;
    }
    else
    return passwordListArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    PasswordCell *cell = (PasswordCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PasswordCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIImage *indicatorImage = [UIImage imageNamed:@"arrow.png"];
    cell.accessoryView =[[UIImageView alloc]initWithImage:indicatorImage];
    
    cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (self.searchController.active) {
        
        NSLog(@"worked %@",[searchResults objectAtIndex:indexPath.row]);
            //_filteredList = [passwordListArray mutableCopy];
        Password *passObject = [searchResults objectAtIndex:indexPath.row];
        
        NSLog(@"worked %@",passObject.title);

        cell.titleLabel.text =passObject.title;
        //cell.detaillbl.text = [NSString stringWithFormat:@"%lu songs",[[song valueForKey:@"songID"] count]];
        
        //        cell.detaillbl.hidden = YES;
        //        cell.detaillbl.text = [NSString stringWithFormat:@"%lu songs",[[song valueForKey:@"songID"] count]];
        return  cell;
        
    }
    else{
        Password* info=[passwordListArray objectAtIndex:indexPath.row];
        
        
        cell.titleLabel.text = info.title;
        
    
    return cell;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.passTable isEditing]) {
        NSLog(@"Editing is On");
    }
    else{
    
    
        
        NewPassBookViewController *newPassVC = [[NewPassBookViewController alloc]initWithNibName:@"NewPassBookViewController" bundle:nil];
        if (self.searchController.active) {
            newPassVC.pIndexpath = indexPath.row;
            
            NSManagedObject *selectedRow = [filteredArray objectAtIndex:[[self.passTable indexPathForSelectedRow] row]];
            
            newPassVC.managedObject = selectedRow;

        }
        
        else{
        
            newPassVC.pIndexpath = indexPath.row;
            
            NSManagedObject *selectedRow = [passwordListArray objectAtIndex:[[self.passTable indexPathForSelectedRow] row]];
            
            newPassVC.managedObject = selectedRow;
        
        }
        
        
        [self.navigationController pushViewController:newPassVC animated:YES];
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRUE;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 3;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSString *stringToMove = passwordListArray[sourceIndexPath.row];
    [passwordListArray removeObjectAtIndex:sourceIndexPath.row];
    [passwordListArray insertObject:stringToMove atIndex:destinationIndexPath.row];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[passwordListArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        [passwordListArray removeObjectAtIndex:indexPath.row];
        [self.passTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    
    
    NSString *searchText = searchController.searchBar.text;
    
    if (passwordListArray.count>0) {
        searchResults = [passwordListArray mutableCopy];
        NSLog(@"Object : %@",searchResults[0]);
        
        // strip out all the leading and trailing spaces
        NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // break up the search terms (separated by spaces)
        NSArray *searchItems = nil;
        if (strippedString.length > 0) {
            searchItems = [strippedString componentsSeparatedByString:@" "];
        }
        
        // build all the "AND" expressions for each value in the searchString
        //
        if (searchText == nil) {
            searchResults = [passwordListArray mutableCopy];
            [self.passTable reloadData];
        }
        else{
            
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
            
            // match up the fields of the Product object
            NSMutableArray *tempArray = [[searchResults filteredArrayUsingPredicate:predicate] mutableCopy];
            searchResults = [NSMutableArray arrayWithArray:tempArray];
            
            filteredArray = [tempArray mutableCopy];
            [self.passTable reloadData];

    }
    
    }
    
}




#pragma mark - UISearchBarDelegate

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [searchBar resignFirstResponder];
//}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    leftMenuBtn.enabled = YES;
    rightBarBtn.enabled = YES;
    self.searchController.active = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.passTable reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    leftMenuBtn.enabled = NO;
    rightBarBtn.enabled = NO;
    searchResults = [passwordListArray mutableCopy];
    [self.passTable reloadData];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0 || !searchText) {
        searchResults = [passwordListArray mutableCopy];
        [self.passTable reloadData];
    }
   
        
}




#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
//- (void)presentSearchController:(UISearchController *)searchController {
//    
//}
//
//- (void)willPresentSearchController:(UISearchController *)searchController {
//    // do something before the search controller is presented
//}
//
//- (void)didPresentSearchController:(UISearchController *)searchController {
//    // do something after the search controller is presented
//}
//
//- (void)willDismissSearchController:(UISearchController *)searchController {
//    // do something before the search controller is dismissed
//}
//
//- (void)didDismissSearchController:(UISearchController *)searchController {
//    // do something after the search controller is dismissed
//}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




@end
