//
//  NotesViewController.m
//  PhotoVault
//
//  Created by Asif Seraje on 12/14/15.
//
//

#import "NotesViewController.h"
#import "NoteTableViewCell.h"
#import "Note.h"

#define APP_BG_COLOR [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define CELL_SEP_COLOR [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:31.0/255.0 green:37.0/255.0 blue:47.0/255.0 alpha:1.0]
#define CELL_SEL_COLOR [UIColor colorWithRed:14.0/255.0 green:19.0/255.0 blue:23.0/255.0 alpha:1.0]

@interface NotesViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>{


    NSDate *creationDate;
    NSMutableArray *searchResults;
    NSMutableIndexSet *indicesOfItemsToDelete;
    NSIndexPath *selectionIndex;
    UIBarButtonItem *customBtn;
    UIBarButtonItem *rightBarBtn;
    NSMutableArray *filteredArray;
}

@end

@implementation NotesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage* customImg = [UIImage imageNamed:@"menu"];//share_btn@2xmenuplus
    UIImage* rightBarBtnImg = [UIImage imageNamed:@"plus"];
    self.navigationItem.title = @"Notes";
    
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;

    [self.noteTable setAllowsMultipleSelection:YES];

    [self.noteTable setAllowsMultipleSelectionDuringEditing:YES];

    customBtn = [[UIBarButtonItem alloc]initWithImage:customImg style:UIBarButtonItemStyleDone target:self action:@selector(switchToSideMenu)];
    [self.navigationItem setLeftBarButtonItem:customBtn];
    
    rightBarBtn = [[UIBarButtonItem alloc]initWithImage:rightBarBtnImg style:UIBarButtonSystemItemAdd target:self action:@selector(addBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    //self.noteTable.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableBG"]];
    
    [self.noteTable setBackgroundColor:[UIColor clearColor]];
    self.noteTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.noteTable setSeparatorColor:CELL_SEP_COLOR];
    self.view.backgroundColor = APP_BG_COLOR;
    filteredArray = [[NSMutableArray alloc]init];
    [self initializeSearchController];
}

- (void)initializeSearchController {
    
    
    //instantiate a UISearchController - passing in the search results controller table
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];

    //this view controller can be covered by theUISearchController's view (i.e. search/filter table)
    self.definesPresentationContext = YES;
    
    //
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.navigationController.navigationBar.hidden = NO;

    //[self.searchController.searchBar sizeToFit];
    
    
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
                
                //set font color here
                searchBarTextField.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
                
                break;
            }
        }
    }
    
    
    
//    [[UITextField appearanceWhenContainedIn:[UISearchController class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //add the UISearchController's search bar to the header of this table
    self.noteTable.tableHeaderView = self.searchController.searchBar;
    
    
    //this ViewController will be responsible for implementing UISearchResultsDialog protocol method(s) - so handling what happens when user types into the search bar
    self.searchController.searchResultsUpdater = self;
    
    
    //this ViewController will be responsisble for implementing UISearchBarDelegate protocol methods(s)
    self.searchController.searchBar.delegate = self;
}




-(void)switchToSideMenu{

    [DELEGATE.slideContainer toggleLeftSideMenuCompletion:nil];
}


-(void)addBtnClicked{


    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Create Note"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* newNoteAction = [UIAlertAction actionWithTitle:@"New Note" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self createNewNote];
                                                           

                                                           
                                                       }];
    
    UIAlertAction* editNoteAction = [UIAlertAction actionWithTitle:@"Edit Note"
                                                             style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            if (self.noteListArray.count>0) {
                                                                [self editNote];
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
    [alertController addAction:newNoteAction];
    [alertController addAction:editNoteAction];
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
#pragma mark--
-(void)createNewNote{

    NoteDetailsViewController *ndvc = [[NoteDetailsViewController alloc]initWithNibName:@"NoteDetailsViewController" bundle:nil];
    ndvc.pIndexpath = -1;
    
    [self.navigationController pushViewController:ndvc animated:YES];
}

-(void)editNote{
 
    UIImage* customImg = [UIImage imageNamed:@"menu"];
    
    UIBarButtonItem *_customButton = [[UIBarButtonItem alloc] initWithImage:customImg style:UIBarButtonItemStyleDone target:self action:@selector(switchToConfiguration)];
    
    [self.navigationItem setLeftBarButtonItem:_customButton];
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemTrash target:self action: @selector(deleteItemFromCoreData)] animated: TRUE];
    [self.noteTable setEditing:YES animated:YES];

    
}
#pragma mark--
-(void) switchToNormalMode {
    UIImage* customImg = [UIImage imageNamed:@"menu"];//share_btn@2xmenuplus
    UIImage* rightBarBtnImg = [UIImage imageNamed:@"plus"];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithImage:rightBarBtnImg style:UIBarButtonSystemItemAdd target:self action:@selector(addBtnClicked)];
    UIBarButtonItem *customBtn = [[UIBarButtonItem alloc]initWithImage:customImg style:UIBarButtonItemStyleDone target:self action:@selector(switchToSideMenu)];
    [self.navigationItem setLeftBarButtonItem:customBtn];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    [self.noteTable setEditing:NO animated:YES];
}

-(void) switchToConfiguration
{
    
    
    [DELEGATE.slideContainer toggleLeftSideMenuCompletion:nil];
}

# pragma mark--Fetching Note Data



-(NSManagedObjectContext *) managedObjectContext{

    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate respondsToSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return  context;
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Note"];
    self.noteListArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.notesTableView reloadData];
}


-(void)deleteItemFromCoreData{
    
    NSArray *selectedRows = [self.noteTable indexPathsForSelectedRows];
    
    BOOL deleteSpecificRows = selectedRows.count > 0;
    if (deleteSpecificRows)
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
        self.noteListArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
        // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
        indicesOfItemsToDelete = [NSMutableIndexSet new];
        for (selectionIndex in selectedRows)
        {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
            NSLog(@"===integer %li",(long)selectionIndex.row);
            
            
            [context deleteObject:[self.noteListArray objectAtIndex:selectionIndex.row]];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
            
        }
        [self.noteListArray removeObjectsAtIndexes:indicesOfItemsToDelete];
        [self.noteTable deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.noteTable reloadData];
    // Delete the objects from our data model.
    
    
    // Tell the tableView that we deleted the objects
    if (!deleteSpecificRows) {
        [self switchToNormalMode];
    }
    
    if (self.noteListArray.count==0) {
        [self switchToNormalMode];
    }
    
}
# pragma mark--Table View
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (self.searchController.active) {
        return searchResults.count;
    }
    else
        return self.noteListArray.count;
        
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    NoteTableViewCell *cell = (NoteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NoteTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIImage *indicatorImage = [UIImage imageNamed:@"arrow.png"];
    cell.accessoryView =[[UIImageView alloc]initWithImage:indicatorImage];
    
    NSManagedObject *note = [self.noteListArray objectAtIndex:indexPath.row];
    

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];

    
    //
    
    if (self.searchController.active) {
        

        Note *noteObject = [searchResults objectAtIndex:indexPath.row];
        
        //NSLog(@"worked %@",noteObject.title);
        
        cell.titleLabel.text =noteObject.body;
        
        creationDate = noteObject.date;
        
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"dd-MM-yyyy"];
        [cell.dateLabel setText:[format stringFromDate:creationDate]];
        return  cell;
        
    }
    else{
        Note* info=[self.noteListArray objectAtIndex:indexPath.row];
        
        
        cell.titleLabel.text = info.body;
            creationDate = info.date;
        
            NSDateFormatter *format = [[NSDateFormatter alloc]init];
            [format setDateFormat:@"dd-MM-yyyy"];
            [cell.dateLabel setText:[format stringFromDate:creationDate]];

        
        return cell;
    }
    return 0;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.noteTable isEditing]) {
        //NSLog(@"Editing is On");
        
    }
    else{
    
        NoteDetailsViewController *ndvc = [[NoteDetailsViewController alloc]initWithNibName:@"NoteDetailsViewController" bundle:nil];
        if (self.searchController.active) {
            NSManagedObject *note = [filteredArray objectAtIndex:[[self.noteTable indexPathForSelectedRow] row]];
            ndvc.noteString = [note valueForKey:@"body"];
            ndvc.pIndexpath = indexPath.row;

            NSManagedObject *selectedRow = [filteredArray objectAtIndex:[[self.noteTable indexPathForSelectedRow] row]];
            
            ndvc.managedObject = selectedRow;
            
        }
        
        else{
        
            NSManagedObject *note = [self.noteListArray objectAtIndex:indexPath.row];
            ndvc.noteString = [note valueForKey:@"body"];
            ndvc.pIndexpath = indexPath.row;
            
            NSManagedObject *selectedRow = [self.noteListArray objectAtIndex:[[self.noteTable indexPathForSelectedRow] row]];
            
            ndvc.managedObject = selectedRow;
        }
        
        
        
        [self.navigationController pushViewController:ndvc animated:YES];
    }
    
    
    

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.noteListArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
    [self.noteListArray removeObjectAtIndex:indexPath.row];
    [self.noteTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRUE;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 3;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSString *stringToMove = self.noteListArray[sourceIndexPath.row];
    [self.noteListArray removeObjectAtIndex:sourceIndexPath.row];
    [self.noteListArray insertObject:stringToMove atIndex:destinationIndexPath.row];
    
}



#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    
    
    NSString *searchText = searchController.searchBar.text;
    
    searchResults = [self.noteListArray mutableCopy];

    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }

    if (searchText == nil) {
        searchResults = [self.noteListArray mutableCopy];
        [self.noteTable reloadData];
    }
    else{

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.body contains[c] %@",searchText];

        NSMutableArray *tempArray = [[searchResults filteredArrayUsingPredicate:predicate] mutableCopy];
        searchResults = [NSMutableArray arrayWithArray:tempArray];

        filteredArray = [tempArray mutableCopy];
        [self.noteTable reloadData];
        
        
    }
    
}




-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    customBtn.enabled = YES;
    rightBarBtn.enabled = YES;
    self.searchController.active = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.noteTable reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    customBtn.enabled = NO;
    rightBarBtn.enabled = NO;
    searchResults = [self.noteListArray mutableCopy];
    [self.noteTable reloadData];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"%@", [searchBar text]);
    
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0 || !searchText) {
        searchResults = [self.noteListArray mutableCopy];
        [self.noteTable reloadData];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
