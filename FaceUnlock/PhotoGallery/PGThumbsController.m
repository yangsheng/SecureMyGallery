//
//  PGThumbsController.m
//  PhotoGallery
//
//  Created by Asif Seraje on 1/12/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "PGThumbsController.h"
#import "PGDataSource.h"
#import "PGImageButton.h"
#import "MBProgressHUD.h"
#import "Utilities.h"
#import "UIImage+fixOrientation.h"
#import "CTAssetsPickerController.h"
#import "DropBoxDownLoadListVC.h"
#import "GoogleDriveListVCViewController.h"
#import "GDCollectionVC.h"
#import "DBCollectionVC.h"
#import "GTLDrive.h"
#import <DropboxSDK/DropboxSDK.h>
#import "GoogleDriveManager.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "HSDrivePicker.h"
#import "DropboxViewController.h"

#define APP_BG_COLOR [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:31.0/255.0 green:37.0/255.0 blue:47.0/255.0 alpha:1.0]



#define iPhone6Plus         ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)


#define DEVICE_HEIGHT                                   ([[UIScreen mainScreen] bounds].size.height)
#define DEVICE_WIDTH                                    ([[UIScreen mainScreen] bounds].size.width)
#define IS_IPHONE_4                                     ([[UIScreen mainScreen] bounds].size.height <= 480.0)
#define IS_IPHONE_5                                     ([[UIScreen mainScreen] bounds].size.height <= 568.0)
#define IS_IPHONE_6                                     ([[UIScreen mainScreen] bounds].size.height <= 667.0)
#define MAIN_SCREEN_HEIGHT                              ([[UIScreen mainScreen] bounds].size.height)
#define MAIN_SCREEN_WIDTH                              ([[UIScreen mainScreen] bounds].size.width)
#define	IS_DEVICE_IPAD                                  ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define iPadPro ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && [UIScreen mainScreen].bounds.size.height == 1366)



static NSString *const kKeychainItemName = @"GD";
static NSString *const kClientId = @"861941523810-lfd2q6ss0uni2a3gd5ve7rc45090u7ej.apps.googleusercontent.com";
static NSString *const kClientSecret = @"ShJN0ZuUNUceWkWnOnDiRNvr";

@interface PGThumbsController()<CTAssetsPickerControllerDelegate,DBRestClientDelegate>{

    NSMutableArray *result;
    int extraViewCount;
    MBProgressHUD *HUD;


}

//Private
@property (nonatomic, strong) PGDataSource *dataSource;
@property (strong, nonatomic) NSMutableArray *selectedFileNames;
@property (nonatomic, strong) DownloadManager *downloadManager;

//UI
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIToolbar *mainToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *actionToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *moveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *dropBox;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *googleDrive;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *camera;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *importG;


//
@property (nonatomic, retain) GTLServiceDrive *driveService;

@property (strong , nonatomic) DBRestClient *restClient;

@property (nonatomic) BOOL isLinked;

//Methods
-(BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate;
-(void) setScrollViewInset;
-(void) blockLockscreen;
-(void) unblockLockscreen;
-(void) showActionBar: (bool) visible;
-(NSMutableArray *) getSelectedFileNames;

@property (nonatomic, strong)NSString *albumName;

@end



@implementation PGThumbsController
@synthesize restClient,isLinked;
//Public
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
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DownloadedPhoto"]) {
            PGDataSource *newDS = [[PGDataSource alloc] initWithCaller];
            self.dataSource = newDS;
            self.dataSource.delegate= self;
            self.mainToolbar.hidden = YES;
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"DownloadedPhoto"];
        }
        else{
            PGDataSource *newDS = [[PGDataSource alloc] init];
            self.dataSource = newDS;
            self.dataSource.delegate= self;
            self.downloadManager.dlDelegate = self;
        }
        
        //Register for rotation notifications
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - View Events

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString *newNotificationName = @"refreshDownLoadForGD";
    self.navigationController.navigationBar.translucent = NO;

    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshScrollViewForDBandGD:) name:newNotificationName object:nil];
    
    NSString *notificationName = @"refreshDownLoad";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshScrollViewForDBandGD:) name:notificationName object:nil];
    
    if ((int)self.dflag == 1) {
        self.tabBarController.tabBar.hidden = YES;
        self.view.backgroundColor = APP_BG_COLOR;
        [self.imageScrollView scrollRectToVisible: CGRectMake(0, 0, 0, 0) animated: FALSE];
        NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder: self.folder];
        int count = [self.dataSource numberOfFilesForDictionary:_dicItem];
        //Add progress HUD
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.minSize = CGSizeMake(100, 100);
        _progressHUD.minShowTime = 1;
        [self.view addSubview:_progressHUD];

        PGDataSource *newDS = [[PGDataSource alloc] initWithCaller];
        self.dataSource = newDS;
        self.dataSource.delegate= self;
        self.actionToolbar.hidden = YES;
        self.mainToolbar.hidden = YES;
        if (count != 0){

            UIBarButtonItem *aButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleActionToolbarNew)];
            [self.navigationItem setRightBarButtonItem: aButton];
            
        }
        //Set window title
        self.navigationItem.title = self.folder;
    }
    else{

        self.tabBarController.tabBar.hidden = YES;
        [self.imageScrollView scrollRectToVisible: CGRectMake(0, 0, 0, 0) animated: FALSE];
        NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder: self.folder];
        int count = [self.dataSource numberOfFilesForDictionary:_dicItem];
        self.view.backgroundColor = APP_BG_COLOR;

        //NSLog(@"count %i",count);
        
        if (count != 0){

            UIBarButtonItem *aButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleActionToolbar)];
            [self.navigationItem setRightBarButtonItem: aButton];

        }
        

        
        //Add progress HUD
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.minSize = CGSizeMake(100, 100);
        _progressHUD.minShowTime = 1;
        [self.view addSubview:_progressHUD];


        UIImage *cameraImage = [[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.camera setImage:cameraImage];
        
        UIImage *importGallery = [[UIImage imageNamed:@"importGallery"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.importG setImage:importGallery];

        UIImage *googleDrive = [[UIImage imageNamed:@"google_drive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.googleDrive setImage:googleDrive];
        
        UIImage *dropBox = [[UIImage imageNamed:@"Drop_box"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.dropBox setImage:dropBox];
        
        

        //Hide actions toolbar
        self.actionToolbar.hidden = TRUE;
        //Set window title
        self.navigationItem.title = self.folder;
    }
}

-(void)toggleActionToolbar{

    
    if (self.actionToolbar.hidden == TRUE)
        [self showActionBar: TRUE];
    else
        [self showActionBar: FALSE];

}

- (void)toggleActionToolbarNew{

    [self showActionBar: TRUE];

}



-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.tabBarController.tabBar.hidden = YES;
    //Scrollview refresh
    [self refreshScrollView];
   
    
    //Scrollview reposition
    // [self setScrollViewInset];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];

}

#pragma mark - UI Events

- (IBAction)toogleActionToolbar:(id)sender {

}

- (IBAction)importPhotos:(id)sender {
    //Block lockscreen
    [self blockLockscreen];

    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.navigationBar.barTintColor = NAV_BAR_TINT_COLOR;
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

- (IBAction)importPhotoFromDropBox:(id)sender {
   

    
//    if (![[DBSession sharedSession] isLinked]) {
//        [[DBSession sharedSession] linkFromController:self];
//    } else {

//        DBCollectionVC *dbCollectionVC = [[DBCollectionVC alloc]initWithNibName:@"DBCollectionVC" bundle:nil];
//        dbCollectionVC.folderName = self.folder;
    
        DropboxViewController *DBVC = [[DropboxViewController alloc]initWithNibName:@"DropboxViewController" bundle:nil];
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:DBVC];
    
    //now present this navigation controller modally
    
        
        [self presentViewController:navigationController animated:YES completion:nil];
//    }
    
}

- (IBAction)importPhotoFromGoogleDrive:(id)sender {

    GDCollectionVC *gdCollectionVC = [[GDCollectionVC alloc]initWithNibName:@"GDCollectionVC" bundle:nil];

    gdCollectionVC.folderName = self.folder;

    HSDrivePicker *drivePicker = [[HSDrivePicker alloc]initWithId:kClientId secret:kClientSecret];
    //[self presentViewController:gdCollectionVC animated:YES completion:nil];
    [drivePicker pickFromViewController:self
                             withCompletion:^(HSDriveManager *manager, GTLDriveFile *file) {
                                 NSLog(@"selected: %@",file.title);
                             }];

}

- (IBAction)capturePhoto:(id)sender {
    //Start camera

    [self startCameraControllerFromViewController: self usingDelegate: self];

}

- (IBAction)sharePhotos:(id)sender {
  
    
    //Show toast
    self.progressHUD.labelText = @"Exporting photos...";
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD show:YES];
    
    //Export files (async)
    [self.dataSource exportFiles: self.selectedFileNames FromFolder: self.folder];
}

- (IBAction)addPhotos:(id)sender {
    
    //Present album picker
    if ((int)self.dflag == 1) {
        PGDLAlbumPicker *dlPicker = [[PGDLAlbumPicker alloc]initWithNibName:@"PGDLAlbumPicker" bundle:nil];
        dlPicker.delegate = self;
        dlPicker.naviTitle = @"Copy to";
        dlPicker.tag = 1;
        [self presentViewController:dlPicker animated:true completion:nil];
    }
    else{
    
        PGAlbumPicker *picker = [[PGAlbumPicker alloc] initWithNibName: @"PGAlbumPicker" bundle: nil];
        picker.delegate = self;
        picker.naviTitle = @"Copy to";
        picker.tag = 1;
        [self presentViewController:picker animated:true completion:nil];
    }
}

- (IBAction)movePhotos:(id)sender {
    //Preset album picker
    
    if ((int)self.dflag == 1) {
        PGDLAlbumPicker *dlPicker = [[PGDLAlbumPicker alloc]initWithNibName:@"PGDLAlbumPicker" bundle:nil];
        dlPicker.delegate = self;
        dlPicker.naviTitle = @"Move to";
        dlPicker.tag = 2;
        [self presentViewController:dlPicker animated:true completion:nil];
    }
    else{
        
        PGAlbumPicker *picker = [[PGAlbumPicker alloc] initWithNibName: @"PGAlbumPicker" bundle: nil];
        picker.delegate = self;
        picker.naviTitle = @"Move to";
        picker.tag = 2;
        [self presentViewController:picker animated:true completion:nil];
    }
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
        self.navigationItem.rightBarButtonItem = nil;
//        UIImage *image = [UIImage imageNamed:@"toolbar_image"];
//        [self.actionToolbar setBackgroundImage:image forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];

        
        UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(toggleActionToolbar)];//style:UIBarButtonItemStyleDone target:self action:@selector(toggleActionToolbar
//        UIImage *export = [[UIImage imageNamed:@"Export"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [self.shareButton setImage:export];
//        
//        UIImage *copyBtn = [[UIImage imageNamed:@"copy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [self.addButton setImage:copyBtn];
//        
//        UIImage *moveBtn = [[UIImage imageNamed:@"move"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [self.moveButton setImage:moveBtn];
//        
//        UIImage *deleteBtn = [[UIImage imageNamed:@"delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [self.deleteButton setImage:deleteBtn];
        
        [self.navigationItem setRightBarButtonItem: customButton];

        [self.navigationItem setHidesBackButton:YES];
    } else {
        //Hide actions bar
        self.actionToolbar.hidden = TRUE;
        [self.navigationItem setRightBarButtonItem: nil];    
        [self.navigationItem setHidesBackButton:FALSE];
        NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder: self.folder];
        int count = [self.dataSource numberOfFilesForDictionary:_dicItem];
        if (count != 0){
            
//            UIImage* customImg = [UIImage imageNamed:@"shareNew"];//share_btn@2x
//            UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithImage:customImg style:UIBarButtonItemStyleDone target:self action:@selector(toggleActionToolbar)];
            UIBarButtonItem *aButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleActionToolbar)];
            [self.navigationItem setRightBarButtonItem: aButton];
        }
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
        self.navigationItem.title = [NSString stringWithFormat: @"%lu selected", (unsigned long)[fileNames count]];
    }
}

-(void) refreshScrollView{
    //Remove all existing subviews
    //self.view.backgroundColor = [UIColor redColor];
    
   self.imageScrollView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width+40, [UIScreen mainScreen].bounds.size.height);
    
    if (IS_IPHONE_4) {
        self.imageScrollView.frame=CGRectMake(1, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    }
    else if (IS_IPHONE_5)
    {
        self.imageScrollView.frame=CGRectMake(1, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    
    }
    
    else if (IS_DEVICE_IPAD)
    {
        if(iPadPro)
             self.imageScrollView.frame=CGRectMake(1, 0, [UIScreen mainScreen].bounds.size.width+70, [UIScreen mainScreen].bounds.size.height);
    }
    

    self.imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bool buttonIsSelected;
     int dbExtraView = (int)DELEGATE.dbSelectedImages.count;
     int gdExtraView = (int)DELEGATE.gdSelectedImeges.count;
     extraViewCount = dbExtraView + gdExtraView;//(int) DELEGATE.dbSelectedImages.count
    
    for (UIView *subview in self.imageScrollView.subviews) {
        if ([subview isKindOfClass: [PGImageButton class]] || [subview isKindOfClass: [UILabel class]] || [subview isKindOfClass: [UIImageView class]])
            [subview removeFromSuperview];
    }
    

    //Get folder file count
    NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder: self.folder];
    int count = [self.dataSource numberOfFilesForDictionary:_dicItem];
    int totalCount = count + extraViewCount;
    NSLog(@"image scroll count %i",totalCount);


    //Draw content
    if (totalCount == 0) {
        
        //No photos
        CGRect frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];//Image: [UIImage imageNamed: @"NoPhotosBig"]
        imgView.image = [UIImage imageNamed:@"NoPhotosBig"];
        imgView.contentMode = UIViewContentModeCenter;
        
        [self.view addSubview: imgView];
        
//        CGRect labelFrame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//        UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];//Image: [UIImage imageNamed: @"NoPhotosBig"]
//        textLabel.text = @"No Photos";
//        textLabel.contentMode = UIViewContentModeCenter;
//        
//        [self.view addSubview: textLabel];
        
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:];//Image: [UIImage imageNamed: @"NoPhotosBig"]
//        imgView.frame = self.imageScrollView.bounds;
//        imgView.contentMode = UIViewContentModeCenter;
//        [self.imageScrollView addSubview: imgView];
        
        

//        UIImage *importGallery = [[UIImage imageNamed:@"importPhotoAlbum"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //[self.importG setImage:importGallery];
        //Set scrollview size
        self.imageScrollView.contentSize = CGSizeMake(0, 0);
    }
    else {
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass: [PGImageButton class]] || [subview isKindOfClass: [UILabel class]] || [subview isKindOfClass: [UIImageView class]])
                [subview removeFromSuperview];
        }
        
        //Metrics
        int padding = 4;
        int size = 120;
        int currentX = padding;
        int currentY = padding;
        int maximumX = currentX;
        int maximumY = currentY;
        
        if (IS_IPHONE_5 && IS_IPHONE_4)
        {
            size=101;
        }
        else if (iPhone6Plus)
            size=133;
        else if (IS_DEVICE_IPAD)
        {
            
  if(iPadPro)
      size=166;
  else
      size=149;

        }
      
      
        
        int totalCount = count + extraViewCount;
        NSLog(@"image scroll count %i",totalCount);
        
        
        for (int i=0; i<count+extraViewCount; i++) {
            //Thumb image
            if (extraViewCount != 0) {
                //----------------------------------------------------------------------------
                
                if (count == 0){
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
                    
                    UIImage *thumbImage = [UIImage imageNamed:@"Default.png"];
                    PGImageButton *newButton = [[PGImageButton alloc] initWithFrame: CGRectMake(currentX, currentY, size, size)
                                                                              Image:thumbImage SelectionMode: !self.actionToolbar.hidden Type:IT_PHOTO];
                    CGRect rect = CGRectMake(newButton.bounds.size.width/2,newButton.bounds.size.height/2, 10, 10);
                    
                    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithFrame:rect];
                    activity.hidesWhenStopped = YES;
                    //newButton.name = itemFilename;
                    newButton.delegate = self;
                    newButton.tag = i;
                    newButton.selected = buttonIsSelected;
                    [self.imageScrollView addSubview: newButton];
                    [newButton addSubview:activity];
                    [activity startAnimating];
                    newButton.userInteractionEnabled = NO;
                    //--------------------------------------------------------------------------


                }
                else{
                //extra view count is not zero and count also is not zero
                    int flagCount = count;
                    if (i<flagCount) {
                        NSString *itemFilename = [self.dataSource fileNameForFolder: self.folder Index: i];
                        NSString *thumbFileName = [self.dataSource getThumbnail150PathForFilename:itemFilename];
                        UIImage *thumbImage = [UIImage imageWithContentsOfFile: thumbFileName];
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
                        //                    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithFrame:];
                        //                    activity.hidesWhenStopped = YES;
                        //UIImage *thumbImage = [UIImage imageNamed:@"Default.png"];
                        PGImageButton *newButton = [[PGImageButton alloc] initWithFrame: CGRectMake(currentX, currentY, size, size)
                                                                                  Image: thumbImage SelectionMode: !self.actionToolbar.hidden Type:[self.dataSource getTypeFromName:itemFilename]];
                        newButton.name = itemFilename;
                        newButton.delegate = self;
                        newButton.tag = i;
                        newButton.selected = buttonIsSelected;
                        [self.imageScrollView addSubview: newButton];
                    }
                    else{
                    //----------------------------------------------------------------------------------
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
                        
                        UIImage *thumbImage = [UIImage imageNamed:@"Default.png"];
                        PGImageButton *newButton = [[PGImageButton alloc] initWithFrame: CGRectMake(currentX, currentY, size, size)
                                                                                  Image:thumbImage SelectionMode: !self.actionToolbar.hidden Type:IT_PHOTO];
                        CGRect rect = CGRectMake(newButton.bounds.size.width/2,newButton.bounds.size.height/2, 10, 10);
                        
                        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithFrame:rect];
                        activity.hidesWhenStopped = YES;
                        //newButton.name = itemFilename;
                        newButton.delegate = self;
                        newButton.tag = i;
                        newButton.selected = buttonIsSelected;
                        [self.imageScrollView addSubview: newButton];
                        [newButton addSubview:activity];
                        [activity startAnimating];
                        newButton.userInteractionEnabled = NO;

                       //------------------------------------------------------------------
                    }
                    
                }
                
            }else{
            
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
                
                buttonIsSelected = FALSE;
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
            NSLog(@"%f",self.imageScrollView.contentSize.width);
        }
        else {
            //Set scrollview size
            self.imageScrollView.contentSize = CGSizeMake(maximumX + size + padding, maximumY + size + padding);     
        }
    }
    
    //Refresh

    self.imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    NSLog(@"%f",self.imageScrollView.contentSize.width);

    [self refreshSelectionStatus];
}

- (void)setScrollViewInset {
 
    //Calculate metrics
    self.imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
    [self showprogress:@"Saved to Camera Roll"];
    [self setSelectedFileNames: nil];
}

-(void) pgDataSourceDidFinishCopyingFiles: (PGDataSource *) dataSource {
    [self refreshScrollView];
    [self showActionBar: FALSE];
    [self.progressHUD hide: TRUE];
    [self showprogress:[NSString stringWithFormat:@"Added to %@",self.albumName]];
    [self setSelectedFileNames: nil];
}

-(void) pgDataSourceDidFinishMovingFiles: (PGDataSource *) dataSource {
    
    [self refreshScrollView];
    [self showActionBar: FALSE];
    [self.progressHUD hide: TRUE];
    [self showprogress:[NSString stringWithFormat:@"Moved to %@",self.albumName]];
    [self setSelectedFileNames: nil];
}

-(void) pgDataSourceDidFinishDeletingFiles: (PGDataSource *) dataSource {
    [self refreshScrollView];
    [self showActionBar: FALSE];
    [self.progressHUD hide: TRUE];
    [self setSelectedFileNames: nil];
}
#pragma mark - DownloadManager Delegate
-(void)dbDidFinishDownloadingFiles:(DBCollectionVC *)dbCollection{

    [self refreshScrollView];
    [self showActionBar: FALSE];
    [self.progressHUD hide: TRUE];
    [self setSelectedFileNames: nil];
}
- (void)gdDidFinishDownloadingFiles:(DownloadManager *)downloadManager{

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
            self.albumName = name;
        }
        
        //Move files (async)
        if (picker.tag == 2) {

            
            NSLog(@"final selection %@",self.selectedFileNames);
            [self.dataSource moveFiles:self.selectedFileNames FromFolder: self.folder ToFolder: name];
            self.progressHUD.labelText = @"Moving photos...";
            self.albumName = name;


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

#pragma mark-PGDLAlbumPickerDelegate

-(void) dlAlbumPicker: (PGDLAlbumPicker *) picker didSelectAlbumName: (NSString *) name{

    if (name != nil) {
        //Dismiss modal window
        [self dismissViewControllerAnimated:true completion:nil];
        
        //Add files (async)
        if (picker.tag == 1) {
            [self.dataSource copyFiles: self.selectedFileNames FromFolder: self.folder ToFolder: name];
            self.progressHUD.labelText = @"Adding photos...";
            self.albumName = name;

        }
        
        //Move files (async)
        if (picker.tag == 2) {
            
            
            NSLog(@"final selection %@",self.selectedFileNames);
            [self.dataSource moveFiles:self.selectedFileNames FromFolder: self.folder ToFolder: name];
            self.progressHUD.labelText = @"Moving photos...";
            self.albumName = name;

        }
        
        //Show toast
        self.progressHUD.mode = MBProgressHUDModeIndeterminate;
        [self.progressHUD show:YES];
    }
}

-(void) dlAlbumPickerDidCancel:(PGDLAlbumPicker *)picker{
    [result removeAllObjects];
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - PGImageButtonDelegate

-(void) pgImageButtonWasTapped:(PGImageButton *)sender {
    //Get current selection status
    self.selectedFileNames = [self getSelectedFileNames];

    
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
        //self.progressHUD.labelText = @"Importing photos...";
        self.progressHUD.mode = MBProgressHUDModeIndeterminate;
        [self.progressHUD show:YES];
        
        //Import files (async)
        [self.dataSource importArrayDictionary:assets ToFolder: self.folder];
    }
    

    

}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //Dismiss controller
    [picker dismissViewControllerAnimated:true completion:nil];
    
    //Unblock lockscreen
    [self unblockLockscreen];
    
    //Refresh scrollview
    [self refreshScrollView];
    
    
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
#pragma mark-Custom Refresh
- (void)refreshScrollViewForDBandGD:(NSNotification *)notif{
    self.imageScrollView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width+40, [UIScreen mainScreen].bounds.size.height);
    
    if (IS_IPHONE_4) {
        self.imageScrollView.frame=CGRectMake(1, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    }
    else if (IS_IPHONE_5)
    {
        self.imageScrollView.frame=CGRectMake(1, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        
    }
    
    else if (IS_DEVICE_IPAD)
    {
        if(iPadPro)
            self.imageScrollView.frame=CGRectMake(1, 0, [UIScreen mainScreen].bounds.size.width+70, [UIScreen mainScreen].bounds.size.height);
    }
    
    
    self.imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    bool buttonIsSelected;
//    int dbextraView = (int)DELEGATE.dbSelectedImages.count;
//    int gdextraView = (int)DELEGATE.gdSelectedImeges.count;
    
    for (UIView *subview in self.imageScrollView.subviews) {
        if ([subview isKindOfClass: [PGImageButton class]] || [subview isKindOfClass: [UILabel class]] || [subview isKindOfClass: [UIImageView class]])
            [subview removeFromSuperview];
    }
    
    
    //Get folder file count
    NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder: self.folder];
    int count = [self.dataSource numberOfFilesForDictionary:_dicItem];
    int totalCount = count + extraViewCount;
    NSLog(@"image scroll count %i",totalCount);
    
    
    //Draw content
    if (totalCount == 0) {
        //No photos
        UIImageView *imgView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"NoPhotosBig@2x.png"]];
        imgView.frame = self.imageScrollView.bounds;
        imgView.contentMode = UIViewContentModeCenter;
        [self.imageScrollView addSubview: imgView];
        
        //Set scrollview size
        self.imageScrollView.contentSize = CGSizeMake(0, 0);
    }
    else {
        
        UIImage* customImg = [UIImage imageNamed:@"shareNew"];//share_btn@2x
        UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithImage:customImg style:UIBarButtonItemStyleDone target:self action:@selector(toggleActionToolbar)];
        UIBarButtonItem *aButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleActionToolbar)];
        [self.navigationItem setRightBarButtonItem: aButton];
        
        //Metrics
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass: [PGImageButton class]] || [subview isKindOfClass: [UILabel class]] || [subview isKindOfClass: [UIImageView class]])
                [subview removeFromSuperview];
        }
        
        //Metrics
        int padding = 4;
        int size = 120;
        int currentX = padding;
        int currentY = padding;
        int maximumX = currentX;
        int maximumY = currentY;
        
        if (IS_IPHONE_5 && IS_IPHONE_4)
        {
            size=101;
        }
        else if (iPhone6Plus)
            size=133;
        else if (IS_DEVICE_IPAD)
        {
            
            if(iPadPro)
                size=166;
            else
                size=149;
            
        }
        
        int totalCount = count + extraViewCount;
        NSLog(@"image scroll count %i",totalCount);
        
        
        
        
        for (int i=0; i<count+extraViewCount; i++) {
            //Thumb image
            if (extraViewCount != 0) {
                //----------------------------------------------------------------------------
                
                if (count == 0){
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
                    
                    UIImage *thumbImage = [UIImage imageNamed:@"Default.png"];
                    PGImageButton *newButton = [[PGImageButton alloc] initWithFrame: CGRectMake(currentX, currentY, size, size)
                                                                              Image:thumbImage SelectionMode: !self.actionToolbar.hidden Type:IT_PHOTO];
                    CGRect rect = CGRectMake(newButton.bounds.size.width/2,newButton.bounds.size.height/2, 10, 10);
                    
                    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithFrame:rect];
                    activity.hidesWhenStopped = YES;
                    //newButton.name = itemFilename;
                    newButton.delegate = self;
                    newButton.tag = i;
                    newButton.selected = buttonIsSelected;
                    [self.imageScrollView addSubview: newButton];
                    [newButton addSubview:activity];
                    [activity startAnimating];
                    newButton.userInteractionEnabled = NO;
                    //--------------------------------------------------------------------------
                    
                    
                }
                else{
                    //extra view count is not zero and count also is not zero
                    int flagCount = count;
                    if (i<flagCount) {
                        NSString *itemFilename = [self.dataSource fileNameForFolder: self.folder Index: i];
                        NSString *thumbFileName = [self.dataSource getThumbnail150PathForFilename:itemFilename];
                        UIImage *thumbImage = [UIImage imageWithContentsOfFile: thumbFileName];
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
                        //                    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithFrame:];
                        //                    activity.hidesWhenStopped = YES;
                        //UIImage *thumbImage = [UIImage imageNamed:@"Default.png"];
                        PGImageButton *newButton = [[PGImageButton alloc] initWithFrame: CGRectMake(currentX, currentY, size, size)
                                                                                  Image: thumbImage SelectionMode: !self.actionToolbar.hidden Type:[self.dataSource getTypeFromName:itemFilename]];
                        newButton.name = itemFilename;
                        newButton.delegate = self;
                        newButton.tag = i;
                        newButton.selected = buttonIsSelected;
                        [self.imageScrollView addSubview: newButton];
                    }
                    else{
                        //----------------------------------------------------------------------------------
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
                        
                        UIImage *thumbImage = [UIImage imageNamed:@"Default.png"];
                        PGImageButton *newButton = [[PGImageButton alloc] initWithFrame: CGRectMake(currentX, currentY, size, size)
                                                                                  Image:thumbImage SelectionMode: !self.actionToolbar.hidden Type:IT_PHOTO];
                        CGRect rect = CGRectMake(newButton.bounds.size.width/2,newButton.bounds.size.height/2, 10, 10);
                        
                        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithFrame:rect];
                        activity.hidesWhenStopped = YES;
                        //newButton.name = itemFilename;
                        newButton.delegate = self;
                        newButton.tag = i;
                        newButton.selected = buttonIsSelected;
                        [self.imageScrollView addSubview: newButton];
                        [newButton addSubview:activity];
                        [activity startAnimating];
                        newButton.userInteractionEnabled = NO;
                        
                        //------------------------------------------------------------------
                    }
                    
                }
                
            }else{
                
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
                
                buttonIsSelected = FALSE;
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
    extraViewCount --;
    //Refresh
    [self refreshSelectionStatus];


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





#pragma mark-Google Drive
#pragma  mark -
-(void) showprogress : (NSString *)title{
    
    HUD.labelText = nil;
    HUD=[[MBProgressHUD alloc] initWithView:DELEGATE.window];
    [DELEGATE.window addSubview:HUD];
    
    [HUD showWhileExecuting:@selector(myMixedTask2:) onTarget:self withObject:title animated:YES];
    title= @" ";
}



- (void)myMixedTask2 : (NSString *) title{
    
    sleep(.5);
    // UIImageView is a UIKit class, we have to initialize it on the main thread
    __block UIImageView *imageView;
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageNamed:@"Checkmark37"];
        imageView = [[UIImageView alloc] initWithImage:image];
    });
    HUD.customView = imageView;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = title;
    [HUD hide:YES afterDelay:3];
    
    sleep(1);
}



@end
