//
//  PhotoGalleryViewController.m
//  PhotoGallery
//
//  Created by Asif Seraje on 1/12/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import "PGAlbumsController.h"
#import "PGDataSource.h"
#import "PGThumbsController.h"
#import "WizardPatternController.h"
#import "AFNetworking.h"
#import "PGAlbumCell.h"

#define APP_BG_COLOR [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define CELL_SEP_COLOR [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:31.0/255.0 green:37.0/255.0 blue:47.0/255.0 alpha:1.0]
#define CELL_SEL_COLOR [UIColor colorWithRed:14.0/255.0 green:19.0/255.0 blue:23.0/255.0 alpha:1.0]





@interface PGAlbumsController ()<UIActionSheetDelegate>

@property (nonatomic, strong) PGDataSource *dataSource;
@property (strong, nonatomic) IBOutlet UITableView *dataTable;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *infoToolbar;

-(void) addNewFolder;
-(void) refreshInfoLabel;
-(void) setScrollViewInset;

@end

@implementation PGAlbumsController

@synthesize dataSource = _dataSource;
@synthesize dataTable = _dataTable;
@synthesize infoLabel = _infoLabel;
@synthesize infoToolbar = _infoToolbar;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Get a data source
        PGDataSource *newDS = [[PGDataSource alloc] init];
        self.dataSource = newDS;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"deleteDImage"];

    //NSLog(@"%f",self.view.frame.size.width);

    //Fullscreen translucent
    //[self setWantsFullScreenLayout:YES];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];

    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    //Scrollview setup
    //kch[self setScrollViewInset];
    [self.dataTable scrollRectToVisible: CGRectMake(0, 0, 0, 0) animated: TRUE];
    
    //Title
    
    self.navigationItem.title = @"Albums";
    //[self.dataTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //Navigation
    
    UIImage* customImg = [UIImage imageNamed:@"menu"];//share_btn@2x
    UIImage* customImg1 = [UIImage imageNamed:@"plus"];

    UIBarButtonItem *_customButton = [[UIBarButtonItem alloc] initWithImage:customImg style:UIBarButtonItemStyleDone target:self action:@selector(switchToConfiguration)];

    [self.navigationItem setLeftBarButtonItem:_customButton];
    
    UIBarButtonItem *_customButton2 = [[UIBarButtonItem alloc] initWithImage:customImg1 style:UIBarButtonItemStyleDone target:self action:@selector(addbtnclicked)];

     [self.navigationItem setRightBarButtonItem: _customButton2];
    //[self.dataTable setBackgroundView:nil];
    [self.dataTable setBackgroundColor:[UIColor whiteColor]];
    self.dataTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.dataTable setSeparatorColor:CELL_SEP_COLOR];
    //self.view.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:37.0/255.0 blue:47.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
}




-(void) rate_respons:(NSDictionary *)respons
{
    
    NSLog(@" rate respons %@",respons);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([[respons objectForKey:@"is_live"] isEqualToString:@"0"])
    {
        [prefs setBool:NO forKey:@"app_live"];
        
    }
    else
        [prefs setBool:YES forKey:@"app_live"];
    
    
    
    
}

- (void)rate_enable_call:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    NSString *link=@"http://www.twinbit.net/webapi.php?appid=1028913316";
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    
    // Initialize Request Operation
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Configure Request Operation
    [requestOperation setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Process Response Object
        
        [self rate_respons:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Handle Error
    }];
    
    // Start Request Operation
    [requestOperation start];
    
}




- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    //Refresh UI
    [self.tabBarController.tabBar setHidden:NO];
    [self.dataTable reloadData];
    
    //Refresh scrollview
    //kch [self setScrollViewInset];
}


- (void)alertUser
{
//    if ([[IAPManager sharedIAPManager] isLocked]) {
//        UIAlertView *_viewAlert = [[UIAlertView alloc] initWithTitle:@"Purchase" message:@"Do you want to  purchase/restore a item to unlock video function?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Purchase",@"Restore", nil];
//        _viewAlert.tag = 100;
//        [_viewAlert show];
//    }
}


-(void) addbtnclicked
{

//    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select  option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
//                            @"Add New Album",
//                            @"Edit Albums",
//                             @"More Apps",
//                            
//                            nil];
//    
//    
//
//    
//    popup.tag = 1;
//    [popup showInView:self.view];
//    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Add New Album"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        UIAlertAction* newContactAction = [UIAlertAction actionWithTitle:@"Create New Album" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     
                                                                     [self addNewFolder];
                                                                     
                                                                     
                                                                 }];
        
        UIAlertAction* editContactAction = [UIAlertAction actionWithTitle:@"Edit Albums" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                      
                                                                      [self switchToEditMode];
                                                                      
                                                                      
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

//    });

}




#pragma mark-ActionSheet Delegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    NSLog(@"%lu",(unsigned long)[actionSheet.subviews count]);
//    for (UIView *subview in actionSheet.subviews) {
//        if ([subview isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)subview;
//            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        }
//    }
    
    [[UIView appearance] setTintColor:[UIColor colorWithRed:(20/256.0) green:(26/256.0) blue:(32/256.0) alpha:1.0]];

}

#pragma mark-
-(void) moreapps
{

    
//    [Xplode presentPromotionForBreakpoint:@"launch_time"
//                    withCompletionHandler:nil
//                        andDismissHandler:nil];
//    


}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self addNewFolder];
                    break;
                case 1:
                    [self switchToEditMode];
                    break;
                case 2:
                    [self moreapps];
                    break;
                
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Edit/Normal Mode

-(void) switchToNormalMode {
    
    
    UIImage* customImg = [UIImage imageNamed:@"menu"];//share_btn@2x
    UIImage* customImg1 = [UIImage imageNamed:@"plus"];
    
    UIBarButtonItem *_customButton = [[UIBarButtonItem alloc] initWithImage:customImg style:UIBarButtonItemStyleDone target:self action:@selector(switchToConfiguration)];
    
    [self.navigationItem setLeftBarButtonItem:_customButton];
    
    UIBarButtonItem *_customButton2 = [[UIBarButtonItem alloc] initWithImage:customImg1 style:UIBarButtonItemStyleDone target:self action:@selector(addbtnclicked)];
    
    [self.navigationItem setRightBarButtonItem: _customButton2];
  
    /*
     
     UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
     UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(SaveImage)];
     UIBarButtonItem *Add=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddComment:)];
     
     UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)];
     NSArray* buttons = [NSArray arrayWithObjects:Add,self.editButtonItem, nil];
     [toolbar setItems:buttons animated:NO];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
     
     */

    
    [self.dataTable setEditing:FALSE animated: TRUE];
}

-(void) switchToEditMode {
    
    
    UIImage* customImg = [UIImage imageNamed:@"menu"];//share_btn@2x
    
    UIBarButtonItem *_customButton = [[UIBarButtonItem alloc] initWithImage:customImg style:UIBarButtonItemStyleDone target:self action:@selector(switchToConfiguration)];
    
    [self.navigationItem setLeftBarButtonItem:_customButton];
    
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action: @selector(switchToNormalMode)] animated: TRUE];
    [self.dataTable setEditing: TRUE animated: TRUE];
}



-(void) switchToConfiguration
{
    
    
    [DELEGATE.slideContainer toggleLeftSideMenuCompletion:nil];
}

#pragma mark - Methods

-(void) renamefoldername:(id)sender
{
    
    //UIButton *btn=(id)sender;
    
    
    
    renamestr = [NSString stringWithFormat:@"%@",[self.dataSource folderNameForIndex:indexno]];

    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    
    [prefs setValue:renamestr forKey:@"old_fold_name"];
    
    NSLog(@"asdsdf  %@",renamestr);
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Rename Album" message: @"Enter new name for this album." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Save", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex: 0].placeholder = @"Title";
    [alertView textFieldAtIndex: 0].text = [prefs valueForKey:@"old_fold_name"];

    [alertView textFieldAtIndex: 0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [alertView setTag:102];

    [alertView show];

}

-(void) addNewFolder {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"New Album" message: @"Enter a name for this album." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Save", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex: 0].placeholder = @"Title";
    [alertView textFieldAtIndex: 0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [alertView setTag:101];
    [alertView show];
}

-(void) refreshInfoLabel {
    //Calculate
    int albums = [self.dataSource numberOfFolders];
    NSDictionary* _dicItems = [self.dataSource totalPhotoCount];
    
    //Display summary
    if ([self.dataSource numberOfFilesForDictionary:_dicItems] == 0)
        self.infoLabel.text = [NSString stringWithFormat: @"Gallery info: %@", [self.dataSource getAlbumsStringFromNumber: albums]];
    else
        self.infoLabel.text = [NSString stringWithFormat: @"Gallery info: %@, %@", [self.dataSource getAlbumsStringFromNumber: albums], [self.dataSource getPhotosStringFromNumber: _dicItems]];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
//            [[IAPManager sharedIAPManager] purchaseUnlockProduct:^(SKPaymentTransaction *transaction) {
            
//            }];
        }
        if (buttonIndex == 2) {
//            [[IAPManager sharedIAPManager] restoreUnlockProductWithCompletion:^{
//                UIAlertView *_viewAlert = [[UIAlertView alloc] initWithTitle:@"The Video Function is unlocked." message:@"" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
//                [_viewAlert show];
//            }];
        }
    }
    
    else if (alertView.tag == 101)
    {
        NSString *text = [[alertView textFieldAtIndex: 0] text];
        [self.dataSource createFolderWithName: text];
        [self.dataTable reloadData];
    }
    
    else if (alertView.tag == 102)
    {
        
        NSString *text = [[alertView textFieldAtIndex: 0] text];
       // NSLog(@"sdsdf %@",renamestr);

        [self.dataSource renamefoldername:renamestr newstr:text];
        [self.dataTable reloadData];
    }

}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        if([[[alertView textFieldAtIndex:0] text] length] >= 1 )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }else{
        return YES;
    }
}

#pragma mark - UITablewViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self refreshInfoLabel];
    return [self.dataSource numberOfFolders];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITableViewCell";

    
    PGAlbumCell *cell = (PGAlbumCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PGAlbumCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }


    //Label
    NSString *folderName = [self.dataSource folderNameForIndex: indexPath.row];
    cell.pgTitleLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];

    cell.pgDetailTitlelbl.font = [UIFont fontWithName:@"OpenSans" size:12.0];
    cell.pgTitleLabel.text = folderName;
    
    //Sublabel
    NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder:folderName];
    int files = [self.dataSource numberOfFilesForDictionary:_dicItem];
    NSString *folderDetails = [self.dataSource getPhotosStringFromNumber: _dicItem];
    cell.pgDetailTitlelbl.text = folderDetails;

    //Disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    //Left image
    if (files > 0) {
        NSString *thumbFilePath = [self.dataSource getThumbnail110PathForFilename: [self.dataSource fileNameForFolder: folderName Index: files-1]];
        cell.pgImageView.image = [UIImage imageWithContentsOfFile: thumbFilePath];
    } else {
        cell.pgImageView.image = [UIImage imageNamed: @"photogallery"];
    }
    
    UIImage *indicatorImage = [UIImage imageNamed:@"arrow.png"];
    cell.accessoryView =[[UIImageView alloc]initWithImage:indicatorImage];
    
    
    
    //Return cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Deselect
    
    if ([tableView isEditing])
    {
        //do what you want to do when table is in editing mode
        
        indexno=indexPath.row;
        
        [self renamefoldername:nil];
        
        
        
    }
    else
    {
        
        //do what you want to do when table is NOT in editing mode
       
        [tableView deselectRowAtIndexPath: indexPath animated: TRUE];
        
        //Create controller
        PGThumbsController *thumbs = [[PGThumbsController alloc] initWithNibName: @"PGThumbsController" bundle: nil];
        thumbs.folder = [self.dataSource folderNameForIndex: indexPath.row];
        
        //Push on navigation
        [self.navigationController pushViewController: thumbs animated: TRUE];
    
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRUE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *folder = [self.dataSource folderNameForIndex: indexPath.row]; 
    [self.dataSource deleteForlderWithName: folder];
    [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationFade];
}




- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

}




#pragma mark - TableInset

- (void)setScrollViewInset {
    //Calculate metrics
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    int statusBarSize = statusBarFrame.size.height < statusBarFrame.size.width ? statusBarFrame.size.height : statusBarFrame.size.width;
    
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    int navigationBarSize = navigationBarFrame.size.height < navigationBarFrame.size.width ? navigationBarFrame.size.height : navigationBarFrame.size.width;
    
    CGRect toolBarFrame = self.infoToolbar.frame;
    int toolBarSize = toolBarFrame.size.height < toolBarFrame.size.width ? toolBarFrame.size.height : toolBarFrame.size.width;
    
    //Set insets
    [self.dataTable setContentInset:UIEdgeInsetsMake(statusBarSize + navigationBarSize, 0, toolBarSize, 0)];
    [self.dataTable setScrollIndicatorInsets: UIEdgeInsetsMake(statusBarSize + navigationBarSize, 0, toolBarSize, 0)];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self performSelectorOnMainThread:@selector(setScrollViewInset) withObject:nil waitUntilDone:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setDataTable:nil];
    [self setInfoLabel:nil];
    [self setInfoToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
