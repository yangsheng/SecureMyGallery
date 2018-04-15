//
//  NotesViewController.h
//  PhotoVault
//
//  Created by Asif Seraje on 12/14/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SGAppDelegate.h"
#import "NoteDetailsViewController.h"
#import "NoteTableViewCell.h"

@interface NotesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

}
@property (weak, nonatomic) IBOutlet UITableView *notesTableView;

@property (weak, nonatomic) IBOutlet UITableView *noteTable;
@property (nonatomic, strong) NSMutableArray *noteListArray;
@property (nonatomic, strong) UISearchController *searchController;

-(void)switchToSideMenu;
-(void)addBtnClicked;
-(void)createNewNote;
-(void)editNote;
@end
