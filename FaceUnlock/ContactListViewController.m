//
//  ContactListViewController.m
//  PhotoVault
//
//  Created by Asif Seraje on 12/20/15.
//
//

#import "ContactListViewController.h"
#import "ContactViewController.h"
#import "Contact.h"

#define APP_BG_COLOR [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define CELL_SEP_COLOR [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:31.0/255.0 green:37.0/255.0 blue:47.0/255.0 alpha:1.0]
#define CELL_SEL_COLOR [UIColor colorWithRed:14.0/255.0 green:19.0/255.0 blue:23.0/255.0 alpha:1.0]

@interface ContactListViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>{
    
    CoreDataManager *coreDataManager;
    NSMutableArray *contactArray;
    NSMutableArray *deleteListArray;
    NSIndexPath *selectionIndex;
    NSMutableIndexSet *indicesOfItemsToDelete;
    NSMutableArray *searchResults;
    UIBarButtonItem *leftMenuBtn;
    UIBarButtonItem *rightBarBtn;
    NSMutableArray *filteredArray;
    

}
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) NSArray *filteredList;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.contactTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    // Do any additional setup after loading the view from its nib.
    UIImage *customImage = [UIImage imageNamed:@"menu"];
    UIImage *rightBarBtnImg = [UIImage imageNamed:@"plus"];
    self.navigationItem.title = @"Contacts";

    leftMenuBtn = [[UIBarButtonItem alloc]initWithImage:customImage style:UIBarButtonItemStylePlain target:self action:@selector(switchToSideMenu)];
    [self.navigationItem setLeftBarButtonItem:leftMenuBtn];
    rightBarBtn = [[UIBarButtonItem alloc]initWithImage:rightBarBtnImg style:UIBarButtonSystemItemAdd target:self action:@selector(addContact:)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    //[self.contactTable setBackgroundView:nil];
    //self.contactTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableBG"]];


    [self.contactTable setBackgroundColor:[UIColor clearColor]];
    [self.contactTable setSeparatorColor:CELL_SEP_COLOR];
    self.view.backgroundColor = APP_BG_COLOR;
    filteredArray = [[NSMutableArray alloc]init];
     coreDataManager = [[CoreDataManager alloc]init];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initializeSearchController];
    


}


- (void)initializeSearchController {
    
    //instantiate a search results controller for presenting the search/filter results (will be presented on top of the parent table view)
    
    
    //searchResultsController.tableView.dataSource = self;
    
    //searchResultsController.tableView.delegate = self;
    
    //instantiate a UISearchController - passing in the search results controller table
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.hidesNavigationBarDuringPresentation = NO;

  
    
    //
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.navigationController.navigationBar.hidden = NO;
    
    
    
    //define the frame for the UISearchController's search bar and tint
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    //this view controller can be covered by theUISearchController's view (i.e. search/filter table)
    self.definesPresentationContext = YES;
    //self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.tintColor = [UIColor blackColor];
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
   
    for (UIView *subView in self.searchController.searchBar.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                
                //set font color here
                searchBarTextField.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
                
                break;
            }
        }
    }
//    [[UITextField appearanceWhenContainedIn:[UISearchController class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //add the UISearchController's search bar to the header of this table
    self.contactTable.tableHeaderView = self.searchController.searchBar;
    
    
    //this ViewController will be responsible for implementing UISearchResultsDialog protocol method(s) - so handling what happens when user types into the search bar
    self.searchController.searchResultsUpdater = self;
    
    
    //this ViewController will be responsisble for implementing UISearchBarDelegate protocol methods(s)
    self.searchController.searchBar.delegate = self;
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewWillAppear:(BOOL)animated{

    contactArray = [[coreDataManager fetchContactsFromDB]mutableCopy];
    [self.contactTable reloadData];
}

-(void)addContact:(id)sender{

//
//    ContactViewController *contactVC = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:nil];
//    contactVC.tableIndexPath = -1;
//    [self presentViewController:contactVC animated:YES completion:nil];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Create Contact"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* newContactAction = [UIAlertAction actionWithTitle:@"Create New Contact" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self createNewContact];
                                                              
                                                              
                                                              
                                                          }];
    
    UIAlertAction* editContactAction = [UIAlertAction actionWithTitle:@"Edit Contact" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               if (contactArray.count>0) {
                                                                  [self editContact];
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
    
    //[alertController setShouldGroupAccessibilityChildren:YES];
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

-(void)createNewContact{

    dispatch_async(dispatch_get_main_queue(), ^{
       
        ContactViewController *contactVC = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:nil];
        [self.navigationController pushViewController:contactVC animated:YES];

    });
    
}

-(void)editContact{


    //UIImage* customImg = [UIImage imageNamed:@"site_btn.png"];
    
    UIBarButtonItem *_customButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(switchToNormalMode)];
    
    [self.navigationItem setLeftBarButtonItem:_customButton];
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemTrash target:self action: @selector(deleteItemFromCoreData)] animated: TRUE];
    [self.contactTable setEditing:YES animated:YES];
    
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
    
    NSArray *selectedRows = [self.contactTable indexPathsForSelectedRows];
    
    BOOL deleteSpecificRows = selectedRows.count > 0;
    if (deleteSpecificRows)
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
        contactArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
        // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
        indicesOfItemsToDelete = [NSMutableIndexSet new];
        for (selectionIndex in selectedRows)
        {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
            NSLog(@"===integer %li",(long)selectionIndex.row);
            
            
            [context deleteObject:[contactArray objectAtIndex:selectionIndex.row]];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
            
        }
        [contactArray removeObjectsAtIndexes:indicesOfItemsToDelete];
        [self.contactTable deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.contactTable reloadData];
    // Delete the objects from our data model.
    
    
    // Tell the tableView that we deleted the objects
    if (!deleteSpecificRows) {
        [self switchToNormalMode];
    }
    if (contactArray.count == 0) {
        [self switchToNormalMode];
    }
    
}

-(void)switchToSideMenu{
    
    [DELEGATE.slideContainer toggleLeftSideMenuCompletion:nil];
}

-(void) switchToNormalMode {
    UIImage *customImage = [UIImage imageNamed:@"menu"];
    UIImage *rightBarBtnImg = [UIImage imageNamed:@"plus"];
  
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithImage:rightBarBtnImg style:UIBarButtonSystemItemAdd target:self action:@selector(addContact:)];
    UIBarButtonItem *customBtn = [[UIBarButtonItem alloc]initWithImage:customImage style:UIBarButtonItemStyleDone target:self action:@selector(switchToSideMenu)];
    [self.navigationItem setLeftBarButtonItem:customBtn];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    [self.contactTable setEditing:NO animated:YES];
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
    {
        return contactArray.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"cell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIImage *indicatorImage = [UIImage imageNamed:@"arrow.png"];
    cell.accessoryView =[[UIImageView alloc]initWithImage:indicatorImage];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.nameLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];


    if (self.searchController.active) {
//
        Contact *ContactObject = [searchResults objectAtIndex:indexPath.row];
        
        cell.nameLabel.text =ContactObject.firstName;
        //cell.detaillbl.text = [NSString stringWithFormat:@"%lu songs",[[song valueForKey:@"songID"] count]];
        
        //        cell.detaillbl.hidden = YES;
        //        cell.detaillbl.text = [NSString stringWithFormat:@"%lu songs",[[song valueForKey:@"songID"] count]];
        return  cell;

    }
    else{
        Contact* info=[contactArray objectAtIndex:indexPath.row];
    
        
        cell.nameLabel.text = info.firstName;
        return cell;

    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.contactTable isEditing]) {
        NSLog(@"editing is on");
    }
    
    else{
    
         ContactViewController *contactVC = [[ContactViewController alloc]initWithNibName:@"ContactViewController" bundle:nil];
    
        if (self.searchController.active) {
            
            contactVC.tableIndexPath = indexPath.row;
            NSManagedObject *selectedRow = [filteredArray objectAtIndex:[[self.contactTable indexPathForSelectedRow] row] ];
            contactVC.selectedObject = selectedRow;
            
        }
       
        else{
        
            contactVC.tableIndexPath = indexPath.row;
            
            NSManagedObject *selectedRow = [contactArray objectAtIndex:[[self.contactTable indexPathForSelectedRow] row] ];
            
            contactVC.selectedObject = selectedRow;
        }
        [self.navigationController pushViewController:contactVC animated:YES];
    }
    

    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRUE;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 3;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSString *stringToMove = contactArray[sourceIndexPath.row];
    [contactArray removeObjectAtIndex:sourceIndexPath.row];
    [contactArray insertObject:stringToMove atIndex:destinationIndexPath.row];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[contactArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        [contactArray removeObjectAtIndex:indexPath.row];
        [self.contactTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    
    
    NSString *searchText = searchController.searchBar.text;
    searchResults = [contactArray mutableCopy];
    //NSLog(@"Object : %@",searchResults[0]);
    
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
        searchResults = [contactArray mutableCopy];
        [self.contactTable reloadData];
    }
    else{
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstName contains[c] %@",searchText];
        
        // match up the fields of the Product object
        NSMutableArray *tempArray = [[searchResults filteredArrayUsingPredicate:predicate] mutableCopy];
        searchResults = [NSMutableArray arrayWithArray:tempArray];
        
        filteredArray = [tempArray mutableCopy];
        [self.contactTable reloadData];
        
        
    }
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    leftMenuBtn.enabled = NO;
    rightBarBtn.enabled = NO;
    searchResults = [contactArray mutableCopy];
    [self.contactTable reloadData];
    
}

//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
//{
//    [self updateSearchResultsForSearchController:self.searchController];
//}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"%@", [searchBar text]);
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0 || !searchText) {
        searchResults = [contactArray mutableCopy];
        [self.contactTable reloadData];
    }
  

}




#pragma mark - UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    leftMenuBtn.enabled = YES;
    rightBarBtn.enabled = YES;
    self.searchController.active = NO;
    self.navigationController.navigationBar.hidden = NO;

    [self.contactTable reloadData];

}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
