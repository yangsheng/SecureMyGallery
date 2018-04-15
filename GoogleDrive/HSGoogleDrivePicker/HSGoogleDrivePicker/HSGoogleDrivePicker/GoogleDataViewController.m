//
//  GoogleDataViewController.m
//  Mazurka
//
//  Created by  Limited on 3/9/16.
//  Copyright © 2016  Limited. All rights reserved.
//

#import "GoogleDataViewController.h"
#import "HSDriveManager.h"
#import "AsyncImageView.h"
//#import "UIScrollView+SVPullToRefresh.h"
#import "GoogleDataViewController.h"
#import "GDUtility.h"
#import "MoreTableViewCell.h"

//#define CLIENT_ID @"861941523810-lfd2q6ss0uni2a3gd5ve7rc45090u7ej.apps.googleusercontent.com"
//#define CLIENT_SECRET @"ShJN0ZuUNUceWkWnOnDiRNvr"

static NSString *const kClientId = @"861941523810-lfd2q6ss0uni2a3gd5ve7rc45090u7ej.apps.googleusercontent.com";
static NSString *const kClientSecret = @"ShJN0ZuUNUceWkWnOnDiRNvr";
//#define ACCESS_TYPE @"Google Drive"

@interface GoogleDataViewController ()<UITableViewDataSource,UITableViewDelegate>{
    GTMHTTPFetcher* fetcher;
    NSArray* tableDataArray;
    NSString *localPath;
    NSMutableArray *folderArray;
    NSMutableArray *fileArray;
    UIActivityIndicatorView *spinner;

}



@property (retain) UIView *outputV;
@property (retain) UILabel *output;

@property (retain) HSDriveManager *manager;
@property (weak)   UITableView *table;
@property (assign) UIToolbar *toolbar;
@property (retain) GTLDriveFileList *fileList;
@property (retain) UIImage *blankImage;
@property (retain) UIBarButtonItem *upItem;
@property (retain) UIBarButtonItem *segmentedControlButtonItem;
@property (retain) NSMutableArray *folderTrail;
@property (retain) NSMutableArray *dataArray;
@property (retain) NSMutableArray *fileTitleArray;
@property (assign) BOOL showShared;

@property (nonatomic, strong) UIButton *selectDeselectBtn;
@property (nonatomic, strong) UIButton *downloadBtn;

@end

@implementation GoogleDataViewController

- (instancetype)initWithId:(NSString*)clientId secret:(NSString*)secret
{
    self = [super init];
    if (self)
    {
        [self setTitle:@"Google Drive"];
        
        self.manager=[[HSDriveManager alloc] initWithId:clientId secret:secret];
        self.modalPresentationStyle=UIModalPresentationPageSheet;
        
        UIGraphicsBeginImageContext(CGSizeMake(40, 40));
        CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 40, 40)); // this may not be necessary
        self.blankImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.folderTrail=[NSMutableArray arrayWithObject:@"root"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager=[[HSDriveManager alloc] initWithId:GCLIENT_ID secret:CLIENT_SECRET];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = self.file.title;
    
    // Create a UITextView to display output.
    CGRect rect = [UIScreen mainScreen].bounds;
    
    NSLog(@"%f %f",rect.size.width, rect.size.height);
    
    UIView *nohistoryV=[[UIView alloc] initWithFrame:CGRectMake(rect.size.width/2 - 100, rect.size.height/2-200, self.view.bounds.size.width/2, self.view.bounds.size.width/2)];
    
    UILabel *nohislbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 120, 200, 30)];

    nohislbl.numberOfLines=0;
    nohislbl.textAlignment=NSTextAlignmentCenter;
    nohislbl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    nohislbl.font = [UIFont fontWithName:@"OpenSans" size:20];
    nohislbl.textColor = [UIColor whiteColor];
    
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 100, 100)];
//    imgV.center = nohistoryV.center;
    imgV.image = [UIImage imageNamed:@"Search_TableView_Placeholder"];
    
    [nohistoryV setBackgroundColor:[UIColor grayColor]];
    [nohistoryV addSubview:imgV];
    [nohistoryV addSubview:nohislbl];
    [self.view addSubview:nohistoryV];
  
    self.outputV=nohistoryV;
    self.output = nohislbl;
    
//    UIToolbar *toolbar=[UIToolbar new];
//    [toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
//    self.toolbar=toolbar;
    //    [self.view addSubview:toolbar];
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setTintColor:[UIColor orangeColor]];
    tableView.allowsMultipleSelectionDuringEditing = true;
   // [tableView addPullToRefreshWithActionHandler:^{
//        [self getFiles];
    //}];
    
    [self.view addSubview:tableView];
    self.table = tableView;
    [self.table setBackgroundColor:[UIColor grayColor]];
    [self.table setSeparatorColor:[UIColor grayColor]];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.view.backgroundColor = [UIColor grayColor];
    
    
    [self openFolder:self.file];
    
//    NSDictionary *views = NSDictionaryOfVariableBindings(toolbar,tableView);
    
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[toolbar]|"
    //                                                                      options:NSLayoutFormatDirectionLeftToRight
    //                                                                      metrics:nil
    //                                                                        views:views]];
    //
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|"
    //                                                                      options:NSLayoutFormatDirectionLeftToRight
    //                                                                      metrics:nil
    //                                                                        views:views]];
    //
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbar(44)][tableView]|"
    //                                                                      options:NSLayoutFormatDirectionLeftToRight
    //                                                                      metrics:nil
    //                                                                        views:views]];
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.fileTitleArray = [[NSMutableArray alloc] init];
    
    folderArray = [[NSMutableArray alloc]init];
    fileArray = [[NSMutableArray alloc] init];
    
    //    [self setupButtons];
    //    [self updateButtons];
    //    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIView *selectDeselectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 110, self.view.frame.size.width, 49)];
    selectDeselectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    selectDeselectView.backgroundColor = [UIColor grayColor];
    
    
    self.selectDeselectBtn = [[UIButton alloc] initWithFrame:CGRectMake(13, 0, 110, 44)];
    [self.selectDeselectBtn setTitle:@"Select All" forState:UIControlStateNormal];
    [self.selectDeselectBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.selectDeselectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.selectDeselectBtn.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:15]];
    self.selectDeselectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.selectDeselectBtn.tag = 1;
    [self.selectDeselectBtn addTarget:self action:@selector(selectDeselectBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    self.selectDeselectBtn.tintColor = [UIColor redColor];
    
    
    self.downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-95, 0, 95, 44)];
    [self.downloadBtn setTitle:@"Download" forState:UIControlStateNormal];
    [self.downloadBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.downloadBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.downloadBtn.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:15]];

    [self.downloadBtn addTarget:self action:@selector(downloadAll) forControlEvents:UIControlEventTouchUpInside];
    self.downloadBtn.tintColor = [UIColor redColor];
    self.downloadBtn.enabled = NO;

    
    [selectDeselectView addSubview:self.selectDeselectBtn];
    [selectDeselectView addSubview:self.downloadBtn];
    [self.view addSubview:selectDeselectView];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startDownloadingNewIteam:) name:@"startNewDownload" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopFetcherOnCurrentThread) name:@"stopDownload" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForExistingFile:) name:@"fileExists" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.table setEditing:YES];
}

// When the view appears, ensure that the Drive API service is authorized, and perform API calls.
- (void)viewDidAppear:(BOOL)animated
{
    UIViewController *authVC=[self.manager authorisationViewController];
    
    if (authVC)
    {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        UINavigationController *nc=(UINavigationController *)[self parentViewController];
        [nc pushViewController:authVC animated:YES];
        
    }
    else
    {
        [self getFiles];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject]; //Get the docs directory
    localPath = [documentsPath stringByAppendingPathComponent:@"/Music/"];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"%lu",(unsigned long)self.dataArray.count);
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    if (self.dataArray.count) {
        for (GTLDriveFile *file in self.dataArray) {
            [titleArray addObject:file.title];
        }
        NSArray *temp = [NSArray arrayWithObjects:self.dataArray, titleArray, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"storeGoogleDriveDownloadArray" object:temp];
    }
}

- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}

-(void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signOut:(id)sender{
    [self.manager signOut];
    [self.table reloadData];
    UIViewController *authVC=[self.manager authorisationViewController];
    
    if (authVC)
    {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        UINavigationController *nc=(UINavigationController *)[self parentViewController];
        [nc pushViewController:authVC animated:YES];
        
    }
}


-(void)showIndicatorInView:(UIView*)view{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = view.center;
    spinner.hidesWhenStopped = YES;
    [view addSubview:spinner];
    spinner.tag = 90;
    [spinner startAnimating];
}

-(void)hideIndicator{
    UIActivityIndicatorView *v = [self.view viewWithTag:90];
    [v removeFromSuperview];
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
}

-(IBAction)editBtnAct:(id)sender{
    UIBarButtonItem *btn = sender;
    if (btn.tag) {
        [btn setTitle:@"Done"];
        [self.table setEditing:YES];
        btn.tag = 0;
    } else {
        [btn setTitle:@"Edit"];
        [self.table setEditing:NO];
        btn.tag = 1;
    }
    
}

-(IBAction)downloadBtnAct:(id)sender{
    if (self.fileTitleArray.count) {
        for (GTLDriveFile *file in self.fileTitleArray) {
            NSString *filePath = [localPath stringByAppendingString:[NSString stringWithFormat:@"/%@", file.title]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                [self.dataArray addObject:file];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"googleDriveDownloading" object:file.title];
                if (!self.isDownloading) {
                    [self downloadGoogleDriveFile:file];
                    [self.dataArray removeObject:[self.dataArray firstObject]];
                }
                self.isDownloading = YES;
                
            }
        }
    }
}

-(void)getFiles
{
   // if (self.table.pullToRefreshView.state==SVPullToRefreshStateStopped)
   // {
   //     [self.table triggerPullToRefresh];
   // }
    
//    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    spinner.center = self.parentViewController.view.center;
//    spinner.hidesWhenStopped = YES;
//    [self.view addSubview:spinner];
//    [spinner startAnimating];
    if (![self.view.subviews containsObject:spinner])
        [self showIndicatorInView:self.view];
    
    self.manager.sharedWithMe=self.showShared;
    self.fileList=NULL;
    
    [self updateDisplay];
    // [self updateButtons];
    
    [self.manager fetchFilesWithCompletionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *fileList, NSError *error)
     {
        // [self.table.pullToRefreshView stopAnimating];
         
//         [spinner removeFromSuperview];
//         [spinner stopAnimating];
//         spinner = nil;
         
         [self hideIndicator];
         
         if (error)
         {
             NSString *message=[NSString stringWithFormat:@"Error: %@",error.localizedDescription ];
             [self.output setText:message];
         }
         else
         {
             self.fileList=fileList;
         }
         
         [self updateDisplay];
         
     }];
}

-(void)updateDisplay
{
    //    [self updateButtons];
    
    if (self.fileList)
    {
        if (self.fileList.items.count)
        {
            [fileArray removeAllObjects];
            [folderArray removeAllObjects];
            for (GTLDriveFile *file in self.fileList) {
                if ([file.mimeType isEqualToString:@"application/vnd.google-apps.folder"] ) {
                    [folderArray addObject:file];
                } else [fileArray addObject:file];
            }
            [self.table setHidden:NO];
            [self hideIndicator];
            self.selectDeselectBtn.enabled = YES;

            [self.table reloadData];
        }
        else
        {
            [self.output setText:@"Nothing found"];
            [self.table setHidden:YES];
            self.selectDeselectBtn.enabled = NO;
        }
    }
    
}


-(void)setupButtons
{
    NSArray *segItemsArray = [NSArray arrayWithObjects: @"Mine",@"Shared", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segItemsArray];
    [segmentedControl addTarget:self action:@selector(mineSharedChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.frame = CGRectMake(0, 0, 100, 30);
    segmentedControl.selectedSegmentIndex = 0;
    UIBarButtonItem *segmentedControlButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)segmentedControl];
    self.segmentedControlButtonItem=segmentedControlButtonItem;
    
    UIBarButtonItem *doneItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                            target:self
                                                                            action:@selector(cancel:)];
    UIBarButtonItem *signOutItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(signOut:)];
    self.upItem=[[UIBarButtonItem alloc] initWithTitle:@"Up"
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(up:)];
    
    
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:doneItem, nil]];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:signOutItem, nil]];
}

-(void)updateButtons
{
    UIBarButtonItem *flex=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                        target:nil
                                                                        action:nil];
    
    if ([self.folderTrail count]>1 && !self.showShared)
    {
        //        [self.toolbar setItems:@[self.upItem,flex,self.segmentedControlButtonItem] animated:YES];
    }
    else
    {
        //        [self.toolbar setItems:@[flex,self.segmentedControlButtonItem] animated:YES];
    }
}

#pragma mark searching

-(void)mineSharedChanged:(UISegmentedControl*)sender
{
    self.showShared=([sender selectedSegmentIndex]==1);
    
    [self getFiles];
}

-(void)up:(id)sender
{
    if ([self.folderTrail count]>1)
    {
        [self.folderTrail removeLastObject];
        [self.manager setFolderId:self.folderTrail.lastObject];
        [self getFiles];
    }
}

-(void)openFolder:(GTLDriveFile *)file
{
    NSString *folderId=[file identifier];
    NSString *currentFolder=[self.folderTrail lastObject];
    
    if ([folderId isEqualToString:currentFolder])
    {
        return;
    }
    
    else
    {
        [self.folderTrail addObject:folderId];
        [self.manager setFolderId:file.identifier];
        [self getFiles];
    }
}



#pragma mark table

-(GTLDriveFile*)fileForIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [folderArray objectAtIndex:indexPath.row];
    } else return [fileArray objectAtIndex:indexPath.row];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return folderArray.count;
    } else return fileArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:self options:nil];
        cell = (MoreTableViewCell *)[topLevelObjects objectAtIndex:0];
        
        UIImageView *iv=cell.imageView;
        [iv setImage:self.blankImage];
        
        AsyncImageView *async=[[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [async setContentMode:UIViewContentModeCenter];
        
        [iv addSubview:async];
    }
    
    AsyncImageView *async=(AsyncImageView *)[cell.imageView.subviews firstObject];
    GTLDriveFile *file=[self fileForIndexPath:indexPath];
    
    if (file)
    {
        
        [cell.title setText:file.title];
        
        if ([file.mimeType isEqualToString:@"application/vnd.google-apps.folder"]) {
            cell.thumb.image = [UIImage imageNamed:@"folder"];
        } else{
            
            if (file.thumbnailLink) {
                [self showIndicatorInView:cell.thumb];
                dispatch_queue_t dq = dispatch_queue_create("imageQueue", NULL);
                dispatch_async(dq, ^{
                    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:file.thumbnailLink]];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async( dispatch_get_main_queue(), ^{
                        // main thread
                        cell.thumb.image = image;
                        [self hideIndicator];
                    });
                });
                //[async setImageURL:[NSURL URLWithString:file.thumbnailLink]];
//                dispatch_release(dq);
            }
              
        }
    }
    else
    {
        [cell.title setText:NULL];
        [async setImage:NULL];
    }
    
    [cell.title setFont:[UIFont fontWithName:@"OpenSans" size:15]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setTintColor:[UIColor greenColor]];
    
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor redColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTLDriveFile *file=[self fileForIndexPath:indexPath];
    if (tableView.isEditing) {
        if (![file isFolder]){
            [self.dataArray addObject:file];
            if (self.dataArray.count == fileArray.count) {
                self.selectDeselectBtn.tag = 0;
                [self.selectDeselectBtn setTitle:@"Deselect All" forState:UIControlStateNormal];
            }
            self.downloadBtn.enabled = YES;
        } else {
            //            [self openFolder:file];
            GoogleDataViewController *google =[[GoogleDataViewController alloc] init];
            google.file = file;
            UINavigationController *nc=(UINavigationController *)[self parentViewController];
            [nc pushViewController:google animated:YES];
            
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTLDriveFile *file = [self fileForIndexPath:indexPath];
    if (self.table.isEditing) {
        [self.dataArray removeObject:file];
        //        if (!self.dataArray.count) {
        self.selectDeselectBtn.tag = 1;
        [self.selectDeselectBtn setTitle:@"Select All" forState:UIControlStateNormal];
        self.downloadBtn.enabled = NO;
        //        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return NO;
    } else return YES;
}

- (IBAction)selectDeselectBtnAct:(UIButton*)sender {
    NSIndexPath *ind;
    if (sender.tag) {
        if (self.dataArray.count) {
            [self.dataArray removeAllObjects];
        }
        
        for (int i=0; i<fileArray.count; i++) {
            ind = [NSIndexPath indexPathForRow:i inSection:1];
            [self.table selectRowAtIndexPath:ind animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.dataArray addObject:[fileArray objectAtIndex:i]];
            
        }
        
        sender.tag=0;
        [sender setTitle:@"Deselect All" forState:UIControlStateNormal];
        self.downloadBtn.enabled = YES;
    }
    
    else{
        for (int i=0; i<fileArray.count; i++) {
            ind = [NSIndexPath indexPathForRow:i inSection:1];
            [self.table deselectRowAtIndexPath:ind animated:YES];
            
        }
        sender.tag = 1;
        [sender setTitle:@"Select All" forState:UIControlStateNormal];
        self.downloadBtn.enabled = NO;
        [self.dataArray removeAllObjects];
        //        self.deleteBtn.enabled = NO;
    }
    
    
}
#pragma mark -- Downlading Stack

-(void)downloadAll{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject]; //Get the docs directory
    NSString *localPathDropbox = [documentsPath stringByAppendingPathComponent:@"/Music/"];
    
    if (self.dataArray.count) {
        NSMutableArray *titleArray = [[NSMutableArray alloc] init];
        GTLDriveFile *downloadingFile;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (GTLDriveFile *file in self.dataArray) {
            NSString* fPath = [localPathDropbox stringByAppendingPathComponent:
                               file.title];
            if (![[NSFileManager defaultManager] fileExistsAtPath:fPath]) {
                if (!self.isDownloading) {
                    [self downloadGoogleDriveFile:file];
                } else {
                    [tempArray addObject:file];
                    [titleArray addObject:file.title];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"googleDriveDownloading" object:file.title];
            }
        }
        self.dataArray = [tempArray mutableCopy];
        NSArray *temp = [NSArray arrayWithObjects:self.dataArray, titleArray, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"storeGoogleDriveDownloadArray" object:temp];
        [self.dataArray removeAllObjects];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];

}


-(void)downloadGoogleDriveFile:(GTLDriveFile *)file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject]; //Get the docs directory
    NSString *localPathDropbox = [documentsPath stringByAppendingPathComponent:@"/Music/"];
    NSString* fPath = [localPathDropbox stringByAppendingPathComponent:
                       file.title];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fPath]){
        fetcher = [self.manager downloadFile:file toPath:fPath withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                self.isDownloading = NO;
                if (self.dataArray.count) {
                    [self downloadGoogleDriveFile:[self.dataArray firstObject]];
                    [self.dataArray removeObject:[self.dataArray firstObject]];
                }
            }
        }];
        self.isDownloading = YES;
        [fetcher setReceivedDataBlock:^(NSData *data) {
            
            NSLog(@"%@ %.2f%% Downloaded",file.title, (100.0 / [file.fileSize longLongValue] * [fetcher downloadedLength]));
            float f = 100.0 / [file.fileSize longLongValue] * [fetcher downloadedLength];
            if (f==100) self.isDownloading = NO;
            if (f==100 && [self isVisible] && self.dataArray.count) {
                [self downloadGoogleDriveFile:[self.dataArray firstObject]];
                [self.dataArray removeObject:[self.dataArray firstObject]];
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:f], @"Downloading",
                                 file.title, @"Title",nil];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dic];
            [userDefaults setObject:personEncodedObject forKey:@"DownloadingArray"];
            [userDefaults synchronize];
            
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newDownloadStarted" object:nil];
    }
}

-(void)stopFetcherOnCurrentThread
{
    [fetcher stopFetching];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)startDownloadingNewIteam:(NSNotification*)notification{
    GTLDriveFile *file = notification.object;
    [self downloadGoogleDriveFile:file];
}

-(void)checkForExistingFile:(NSNotification*)notification{
    //    NSString *title = notification.object;
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSData *data = [userDefaults valueForKey:@"DownloadingArray"];
    //    if (!data) return;
    //    NSDictionary *dataDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //    if (!self.isDownloading && [[dataDic valueForKey:@"Title"] isEqualToString:title]) {
    ////        [self stopFetcherOnCurrentThread];
    self.isDownloading = YES;
    //    }
}



@end
