//
//  UploadThumbsViewController.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/7/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "UploadThumbsViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "PGThumbsController.h"
#import "PGDataSource.h"
#import "PGImageButton.h"
#import "MBProgressHUD.h"
#import "Utilities.h"
#import "UIImage+fixOrientation.h"
#import "CTAssetsPickerController.h"
#import <AVFoundation/AVFoundation.h>

@interface UploadThumbsViewController (){

    NSMutableArray *result;
}
@property (nonatomic, strong) PGDataSource *dataSource;
@property (strong, nonatomic) NSMutableArray *selectedFileNames;

//UI
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIToolbar *mainToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *actionToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *moveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;


-(BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate;
-(void) setScrollViewInset;
-(void) blockLockscreen;
-(void) unblockLockscreen;
-(void) showActionBar: (bool) visible;
-(NSMutableArray *) getSelectedFileNames;


@end

@implementation UploadThumbsViewController

@synthesize folder = _folder;

//Private
@synthesize dataSource =_dataSource;
@synthesize selectedFileNames = _selectedFileNames;

//UI
@synthesize progressHUD = _progressHUD;
@synthesize imageScrollView = _imageScrollView;
@synthesize mainToolbar = _mainToolbar;
@synthesize actionToolbar = _actionToolbar;
@synthesize shareButton = _shareButton;
@synthesize addButton = _addButton;
@synthesize moveButton = _moveButton;
@synthesize deleteButton = _deleteButton;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Get a data source
        
            PGDataSource *newDS = [[PGDataSource alloc] init];
            self.dataSource = newDS;
            self.dataSource.delegate= self;
        
        //Register for rotation notifications
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - View Events

- (void)viewDidLoad {
    [super viewDidLoad];

        self.tabBarController.tabBar.hidden = YES;
        [self.imageScrollView scrollRectToVisible: CGRectMake(0, 0, 0, 0) animated: FALSE];
        
        //Add progress HUD
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.minSize = CGSizeMake(100, 100);
        _progressHUD.minShowTime = 1;
        [self.view addSubview:_progressHUD];
        
        //Hide actions toolbar
        self.actionToolbar.hidden = TRUE;
        self.mainToolbar.hidden = YES;
        //Set window title
        self.navigationItem.title = self.folder;
    
}



-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.tabBarController.tabBar.hidden = YES;
    //Scrollview refresh
    [self refreshScrollView];
    
    //Scrollview reposition
    //kch [self setScrollViewInset];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
}

#pragma mark - UI Events

- (IBAction)toogleActionToolbar:(id)sender {
    if (self.actionToolbar.hidden == TRUE)
        [self showActionBar: TRUE];
    else
        [self showActionBar: FALSE];
}

- (IBAction)importPhotos:(id)sender {
    //Block lockscreen
    [self blockLockscreen];
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.navigationBar.tintColor=[UIColor blackColor];
    picker.maximumNumberOfSelections = 10;
    picker.assetsFilter = [ALAssetsFilter allAssets];
    
    // only allow video clips if they are at least 5s
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(ALAsset* asset, NSDictionary *bindings) {
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        }
        else {
            return YES;
        }
    }];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

- (IBAction)capturePhoto:(id)sender {
    //Start camera
    //
    //           if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //        {
    //
    ////            [[AdManager sharedInstance] animate_banner:1240];
    //
    //        }
    //        else
    //            [[AdManager sharedInstance] animate_banner:800];
    //
    //
    
    [self startCameraControllerFromViewController: self usingDelegate: self];
    
    
    
}

- (IBAction)sharePhotos:(id)sender {
    
    
//    Show toast
    self.progressHUD.labelText = @"Exporting photos...";
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD show:YES];
    
    //Export files (async)
    [self.dataSource exportFiles: self.selectedFileNames FromFolder: self.folder];
}

- (IBAction)addPhotos:(id)sender {
    //Present album picker
    PGAlbumPicker *picker = [[PGAlbumPicker alloc] initWithNibName: @"PGAlbumPicker" bundle: nil];
    picker.delegate = self;
    picker.tag = 1;
    [self presentViewController:picker animated:true completion:nil];
}

- (IBAction)movePhotos:(id)sender {
    //Preset album picker
    
    PGAlbumPicker *picker = [[PGAlbumPicker alloc] initWithNibName: @"PGAlbumPicker" bundle: nil];
    picker.delegate = self;
    picker.tag = 2;
    [self presentViewController:picker animated:true completion:nil];
}

- (IBAction)deletePhotos:(id)sender {
    //Present confirmation sheet
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: @"Delete Selected Photos" otherButtonTitles: nil];
    actions.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [actions showInView: self.view];
}

#pragma mark - Methods

-(void) blockLockscreen {
    [[NSUserDefaults standardUserDefaults] setBool: TRUE forKey: @"wizardInProgress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) unblockLockscreen {
    [[NSUserDefaults standardUserDefaults] setBool: FALSE forKey: @"wizardInProgress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) showActionBar: (bool) visible {
    if (visible) {
        //Show actions bar
        self.actionToolbar.hidden = FALSE;
        [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(toogleActionToolbar:)]];
        [self.navigationItem setHidesBackButton:YES];
    } else {
        //Hide actions bar
        self.actionToolbar.hidden = TRUE;
        [self.navigationItem setRightBarButtonItem: nil];
        [self.navigationItem setHidesBackButton:FALSE];
    }
    
    //Redraw scrollview
    [self refreshScrollView];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
    if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO )|| (delegate == nil) || (controller == nil))
        return NO;
    
    //Block lockscreen
    [self blockLockscreen];
    
    //Create and show picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                           UIImagePickerControllerSourceTypeCamera];//[[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage,kUTTypeVideo, nil];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:true completion:nil];
    return YES;
    
    
    
    
}

- (IBAction)doneUploading:(id)sender {
    
    self.selectedFileNames = [self getSelectedFileNames];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.folder,@"folderName",self.selectedFileNames,@"fileNames", nil];
    
    
    [[[self presentingViewController]presentingViewController]dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadImage" object:dict];
}

-(void) refreshSelectionStatus {
    if (self.actionToolbar.hidden) {
        //Navigation title
        self.navigationItem.title = self.folder;
    } else {
        //Get selected buttons
        NSMutableArray *fileNames = [self getSelectedFileNames];
        
        //Enable/Disable action buttons
        self.shareButton.enabled = [fileNames count] > 0;
        self.addButton.enabled = [fileNames count] > 0;
        self.moveButton.enabled = [fileNames count] > 0;
        self.deleteButton.enabled = [fileNames count] > 0;
        
        //Navigation title
        self.navigationItem.title = [NSString stringWithFormat: @"%i selected", [fileNames count]];
    }
}

-(void) refreshScrollView {
    //Remove all existing subviews
    for (UIView *subview in self.imageScrollView.subviews) {
        if ([subview isKindOfClass: [PGImageButton class]] || [subview isKindOfClass: [UILabel class]] || [subview isKindOfClass: [UIImageView class]])
            [subview removeFromSuperview];
    }
    
    //Get folder file count
    NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder: self.folder];
    int count = [self.dataSource numberOfFilesForDictionary:_dicItem];
    
    //Draw content
    if (count == 0) {
        //No photos
        UIImageView *imgView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"NoPhotosBig.png"]];
        imgView.frame = self.imageScrollView.bounds;
        imgView.contentMode = UIViewContentModeCenter;
        [self.imageScrollView addSubview: imgView];
        
        //Set scrollview size
        self.imageScrollView.contentSize = CGSizeMake(0, 0);
    } else {
        //Metrics
        int padding = 4;
        int size = 75;
        int currentX = padding;
        int currentY = padding;
        int maximumX = currentX;
        int maximumY = currentY;
        
        for (int i=0; i<count; i++) {
            //Thumb image
            NSString *itemFilename = [self.dataSource fileNameForFolder: self.folder Index: i];
            NSString *thumbFileName = [self.dataSource getThumbnail150PathForFilename:itemFilename];
            UIImage *thumbImage = [UIImage imageWithContentsOfFile: thumbFileName];
            
            //Increment metrics
            if (i != 0) {
                //Increment currentX
                currentX = currentX + size + padding;
                if (currentX + size + padding > self.imageScrollView.bounds.size.width) {
                    //Reset currentX
                    currentX = padding;
                    currentY = currentY + size + padding;
                }
                
                //Maximum values
                if (currentX > maximumX)
                    maximumX = currentX;
                if (currentY > maximumY)
                    maximumY = currentY;
            }
            
            //Search for selection in current state
            bool buttonIsSelected = FALSE;
            for (NSString *fileName in self.selectedFileNames)
                if ([fileName isEqualToString: itemFilename])
                    buttonIsSelected = TRUE;
            
            //Create button
            PGImageButton *newButton = [[PGImageButton alloc] initWithFrame: CGRectMake(currentX, currentY, size, size)
                                                                      Image: thumbImage SelectionMode: !self.actionToolbar.hidden Type:[self.dataSource getTypeFromName:itemFilename]];
            newButton.name = itemFilename;
            newButton.delegate = self;
            newButton.tag = i;
            newButton.selected = buttonIsSelected;
            [self.imageScrollView addSubview: newButton];
        }
        
        //Add summary label
        if (count >= 10) {
            //Create summary label
            UILabel *summary = [[UILabel alloc] initWithFrame: CGRectMake(0, maximumY + size + padding, self.imageScrollView.frame.size.width, 40)];
            summary.text = [self.dataSource getPhotosStringFromNumber: _dicItem];
            summary.font = [UIFont systemFontOfSize: 20];
            summary.textColor = [UIColor lightGrayColor];
            summary.textAlignment = UITextAlignmentCenter;
            summary.contentMode = UIViewContentModeCenter;
            [self.imageScrollView addSubview: summary];
            
            //Set scrollview size
            self.imageScrollView.contentSize = CGSizeMake(maximumX + size + padding, maximumY + size + padding + 40 + padding);
        } else {
            //Set scrollview size
            self.imageScrollView.contentSize = CGSizeMake(maximumX + size + padding, maximumY + size + padding);
        }
    }
    
    //Refresh
    [self refreshSelectionStatus];
}

- (void)setScrollViewInset {
    //Calculate metrics
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    int statusBarSize = statusBarFrame.size.height < statusBarFrame.size.width ? statusBarFrame.size.height : statusBarFrame.size.width;
    
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    int navigationBarSize = navigationBarFrame.size.height < navigationBarFrame.size.width ? navigationBarFrame.size.height : navigationBarFrame.size.width;
    
    CGRect toolBarFrame = self.actionToolbar.frame;
    int toolBarSize = toolBarFrame.size.height < toolBarFrame.size.width ? toolBarFrame.size.height : toolBarFrame.size.width;
    
    //Set view inset
    [self.imageScrollView setContentInset:UIEdgeInsetsMake(statusBarSize + navigationBarSize, 0, toolBarSize, 0)];
    [self.imageScrollView setScrollIndicatorInsets:UIEdgeInsetsMake(statusBarSize + navigationBarSize, 0, toolBarSize, 0)];
}

-(NSMutableArray *) getSelectedFileNames {
    result = [[NSMutableArray alloc]init];
    for (UIView *subview in self.imageScrollView.subviews) {
        if ([subview isKindOfClass: [PGImageButton class]]) {
            PGImageButton *button = (PGImageButton *) subview;
            if (button.selected)
                
                [result addObject:button.name];
            
        }
    }
    return result;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //Show toast
        self.progressHUD.labelText = @"Deleting photos...";
        self.progressHUD.mode = MBProgressHUDModeIndeterminate;
        [self.progressHUD show:YES];
        
        //Delete files (async)
        [self.dataSource deleteFiles: self.selectedFileNames FromFolder: self.folder];
    }
}

#pragma mark - PGDataSourceAsyncOpsDelegate

-(void) pgDataSourceDidFinishImportingFiles: (PGDataSource *) dataSource {
    [self refreshScrollView];
    [self showActionBar: FALSE];
    [self.progressHUD hide: TRUE];
    [self setSelectedFileNames: nil];
}

-(void) pgDataSourceDidFinishExportingFiles: (PGDataSource *) dataSource {
    [self refreshScrollView];
    [self showActionBar: FALSE];
    [self.progressHUD hide: TRUE];
    [self setSelectedFileNames: nil];
}

-(void) pgDataSourceDidFinishCopyingFiles: (PGDataSource *) dataSource {
    [self refreshScrollView];
    [self showActionBar: FALSE];
    [self.progressHUD hide: TRUE];
    [self setSelectedFileNames: nil];
}

-(void) pgDataSourceDidFinishMovingFiles: (PGDataSource *) dataSource {
    
    [self refreshScrollView];
    [self showActionBar: FALSE];
    [self.progressHUD hide: TRUE];
    [self setSelectedFileNames: nil];
}

-(void) pgDataSourceDidFinishDeletingFiles: (PGDataSource *) dataSource {
    [self refreshScrollView];
    [self showActionBar: FALSE];
    [self.progressHUD hide: TRUE];
    [self setSelectedFileNames: nil];
}

#pragma mark - PGAlbumPickerDelegate

-(void) albumPicker: (PGAlbumPicker *) picker didSelectAlbumName: (NSString *) name {
    if (name != nil) {
        //Dismiss modal window
        [self dismissViewControllerAnimated:true completion:nil];
        
        //Add files (async)
        if (picker.tag == 1) {
            [self.dataSource copyFiles: self.selectedFileNames FromFolder: self.folder ToFolder: name];
            self.progressHUD.labelText = @"Adding photos...";
        }
        
        //Move files (async)
        if (picker.tag == 2) {
            
            
            NSLog(@"final selection %@",self.selectedFileNames);
            [self.dataSource moveFiles:self.selectedFileNames FromFolder: self.folder ToFolder: name];
            self.progressHUD.labelText = @"Moving photos...";
        }
        
        //Show toast
        self.progressHUD.mode = MBProgressHUDModeIndeterminate;
        [self.progressHUD show:YES];
    }
}

-(void) albumPickerDidCancel:(PGAlbumPicker *)picker {
    [result removeAllObjects];
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - PGImageButtonDelegate

-(void) pgImageButtonWasTapped:(PGImageButton *)sender {
    //Get current selection status
    self.selectedFileNames = [self getSelectedFileNames];
    
    NSLog(@"Selected images ==== %@",self.selectedFileNames);
    NSLog(@"Selected images ==== %d",self.selectedFileNames.count);
    
    
    //Take action
    if (sender.selectionMode) {
        //Refresh selection status
        [self refreshSelectionStatus];
    } else {
        int tappedIndex = sender.tag;
        NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder: self.folder];
        if (tappedIndex < [self.dataSource numberOfFilesForDictionary:_dicItem]) {
            //Create photo browser controller
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = YES;
            browser.displayNavArrows = YES;
            browser.alwaysShowControls = NO;
            browser.zoomPhotosToFill = YES;
            browser.enableGrid = NO;
            [browser setCurrentPhotoIndex: sender.tag];
            
            //Push controller in navigation
            [self.navigationController pushViewController:browser animated:YES];
            
            //Release controller
        }
    }
}

#pragma mark - CTAssets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [self unblockLockscreen];
    
    //Check zero selection
    if ([assets count] > 0) {
        //Show toast
        self.progressHUD.labelText = @"Importing photos...";
        self.progressHUD.mode = MBProgressHUDModeIndeterminate;
        [self.progressHUD show:YES];
        
        //Import files (async)
        [self.dataSource importArrayDictionary:assets ToFolder: self.folder];
    }
    
    
    //    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //    {
    //        [[AdManager sharedInstance] animate_banner:950];
    //
    //    }
    //    else
    //        [[AdManager sharedInstance] animate_banner:500];
    
    
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //Dismiss controller
    [picker dismissViewControllerAnimated:true completion:nil];
    
    //Unblock lockscreen
    [self unblockLockscreen];
    
    //Refresh scrollview
    [self refreshScrollView];
    
    //        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //        {
    //            [[AdManager sharedInstance] animate_banner:950];
    //
    //        }
    //        else
    //            [[AdManager sharedInstance] animate_banner:500];
    //
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
    
    //Photo was captured
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        //Get original image
        UIImage *originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        //NSArray *_arrObjects = @[info];
        //Save file to local database
        //[self.dataSource importArrayDictionary:_arrObjects ToFolder:self.folder];
        [workingDictionary setObject:ALAssetTypePhoto forKey:@"UIImagePickerControllerMediaType"];
        [workingDictionary setObject:originalImage forKey:@"UIImagePickerControllerOriginalImage"];
        [workingDictionary setObject:@"" forKey:@"UIImagePickerControllerReferenceURL"];
        [self.dataSource createFileWithName: [self.dataSource generateNewFileName:IT_PHOTO] Folder: self.folder Item:workingDictionary];
        
    }
    else
    {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[info objectForKey:UIImagePickerControllerMediaURL] options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        [workingDictionary setObject:ALAssetTypeVideo forKey:@"UIImagePickerControllerMediaType"];
        [workingDictionary setObject:thumb forKey:@"UIImagePickerControllerOriginalImage"];
        [workingDictionary setObject:[info objectForKey:UIImagePickerControllerMediaURL] forKey:@"UIImagePickerControllerReferenceURL"];
        [self.dataSource createFileWithName: [self.dataSource generateNewFileName:IT_VIDEO] Folder: self.folder Item:workingDictionary];
        
    }
    //Dismiss controller
    [picker dismissViewControllerAnimated:true completion:nil];
    
    //Unblock lockscreen
    [self unblockLockscreen];
    
    //Refresh scrollview
    [self refreshScrollView];
    
    
    //    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //    {
    //        [[AdManager sharedInstance] animate_banner:950];
    //
    //    }
    //    else
    //        [[AdManager sharedInstance] animate_banner:500];
    
    
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //Nothing
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //Nothing
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder: self.folder];
    return [self.dataSource numberOfFilesForDictionary:_dicItem];
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    //File name and path
    NSString *filename = [self.dataSource fileNameForFolder: self.folder Index: index];
    NSString *filepath = [self.dataSource getImagePathForFilename: filename Folder: self.folder];
    NSDate *filedate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey: filename];
    NSString *filecaption = filedate == nil ? nil : [Utilities localizedLongDateStringFromDate: filedate];
    
    //Create photo
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:filepath]];
    //photo.filePath = filepath;
    photo.itType = [self.dataSource getTypeFromName:filepath];
    photo.dataSource = self.dataSource;
    photo.fileName = filename;
    photo.folderName = self.folder;
    photo.caption = filecaption;
    return photo;
}

#pragma mark - OS Events

- (void) didRotate:(NSNotification *)notification {
    [self refreshScrollView];
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
    [self setImageScrollView:nil];
    [self setMainToolbar:nil];
    [self setActionToolbar:nil];
    [self setShareButton:nil];
    [self setAddButton:nil];
    [self setMoveButton:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
