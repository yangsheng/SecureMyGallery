//
//  GoogleDriveListVCViewController.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/14/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "GoogleDriveListVCViewController.h"
#import "GoogleDriveManager.h"
#import "GTLDrive.h"
#import "SVProgressHUD.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GDChildListVC.h"

static NSString *const kKeychainItemName = @"My App";
static NSString *const kClientId = @"861941523810-lfd2q6ss0uni2a3gd5ve7rc45090u7ej.apps.googleusercontent.com";
static NSString *const kClientSecret = @"ShJN0ZuUNUceWkWnOnDiRNvr";


//typedef void(^FileSavingCompletionHandler) (BOOL successStatus);

@interface GoogleDriveListVCViewController (){

    NSMutableArray *dataArray;

    SGAppDelegate *appDelegate;
    NSMutableArray *googleDriveDataArray;;
    BOOL fileFetchStatusFailure;
    NSInteger fileNameLength;
    NSInteger level;
    NSMutableArray *thumbImageArray;

}

@property (strong , nonatomic) NSMutableArray *driveFiles;
@property (strong , nonatomic) NSMutableArray *parentIdArray;
@property (strong , nonatomic) NSMutableArray *titleArray;
@property (strong , nonatomic) UIView *viewForActivityIndicator;
@property (strong , nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong , nonatomic) NSMutableArray *arrayForStoringViewOrigin;
@property (strong , nonatomic) NSMutableArray *fileNames;
@property (nonatomic, strong) PGDataSource *pgDataSource;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, retain) GTLServiceDrive *driveService;

@end

@implementation GoogleDriveListVCViewController

@synthesize driveService, driveFiles,parentIdArray, titleArray, viewForActivityIndicator, activityIndicator,  arrayForStoringViewOrigin;
@synthesize fileNames;
@synthesize buttonForBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pgDataSource = [[PGDataSource alloc]init];
    googleDriveDataArray = [[NSMutableArray alloc]init];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(dismissViewFromSuper)];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationController.title = @"Google Drive";
    //[SVProgressHUD show];
    [self fetchFiles];


}

- (void)viewWillAppear:(BOOL)animated{

   // [self.googleDriveDataTable reloadData];
}

- (void)dismissViewFromSuper{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initGoogleDriveManager
{
    // Initialize the Drive API service & load existing credentials from the keychain if available.
    self.driveService = [[GTLServiceDrive alloc] init];
    
    // Check for authorization.
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                          clientID:kClientId
                                                                                      clientSecret:kClientSecret];
    
    if ([auth canAuthorize]) {
        [[self driveService] setAuthorizer:auth];
    }
}

#pragma mark -Google Drive Load Files

- (void)fetchFiles
{
    //self.output.text = @"Getting files...";
    
    [[GoogleDriveManager sharedInstance] fetchFilesWithCompletionBlock:^(BOOL success, NSArray *files, NSError *error) {
        
        if(success)
        {
            NSLog(@"__________________________________________");

            NSLog(@"Files From Google Drive>>>>>>>>>%lu",(unsigned long)files.count);
            NSLog(@"__________________________________________");
            
            NSMutableString *filesString = [[NSMutableString alloc] init];
            if (files.count > 0) {
                [filesString appendString:@"Files:\n"];
                for (GTLDriveFile *file in files) {
                    [filesString appendFormat:@"%@ (%@)\n", file.title, file.identifier];
                    NSLog(@" Appended String ========>>>>>>%@",file.title);
                    [googleDriveDataArray addObject:file];
                    
                }
            } else {
                [filesString appendString:@"No files found."];
            }
            //self.output.text = filesString;
            
        }
        else
        {
            NSLog(@"%@",error);
            
            //[self showAlert:@"Error" message:error.localizedDescription];
        }
        [SVProgressHUD dismiss];
        [self.googleDriveDataTable reloadData];

    }];
}







#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{

    NSLog(@"%lu",(unsigned long)googleDriveDataArray.count);
    return googleDriveDataArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{

    static NSString *cellIdentifier = @"cell";
    GDTableViewCell *cell = (GDTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GDTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    GTLDriveFile *file = [googleDriveDataArray objectAtIndex:indexPath.row];
    

    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:file.thumbnailLink]];
    UIImage *image = [UIImage imageWithData:data];
    if ([file.mimeType isEqualToString:@"application/vnd.google-apps.photo"])
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        //imageViewForIcon.image=[UIImage imageNamed:@"folder.png"];
        cell.titleLabel.text = file.title;
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
        cell.downLoadButton.hidden = YES;
    }
    else if (file.thumbnailLink) {
        cell.titleLabel.text = file.title;
        cell.imageView.image = image;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.downLoadButton.hidden = YES;

    }
    else{
    
        cell.titleLabel.text = file.title;
        cell.downLoadButton.hidden = YES;

    }


    driveFiles = [[NSMutableArray alloc]init];
   // GTLDriveFile *file=[driveFiles objectAtIndex:indexPath.row];
    
    
    //[cell.textLabel setText:[NSString stringWithFormat:@"%@",item.name]];
//    UIImageView *imageViewForIcon  = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 30, 30)];
//    [cell.contentView addSubview:imageViewForIcon];
    
    
//    else
//        
//    {
//        if (file.thumbnailLink) {
//            NSString *fileExtension=file.fileExtension;
//            
//
//            if (fileExtension)
//            {
//                
//                
//                if([fileExtension isEqualToString:@"jpg"]||[fileExtension isEqualToString:@"jpeg"]||[fileExtension isEqualToString:@"png"]||[fileExtension isEqualToString:@"gif"]||[fileExtension isEqualToString:@"tiff"]||[fileExtension isEqualToString:@"bmp"])
//                {
//                    cell.imageView.image = image;
//                    
//                }
//        }
//        
//    
//    cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gray_bar_no_upper.png"]];
//        }
    
//}
    return cell;

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTLDriveFile *file=[googleDriveDataArray objectAtIndex:indexPath.row];
    if ([file.mimeType isEqualToString:@"application/vnd.google-apps.folder"])
    {
        level+=1;
        [parentIdArray addObject:file.identifier];
        

        if (!driveService) {
            [self initGoogleDriveManager];
        }
        //[self printFilesInFolderWithService:driveService folderId:file.identifier andName:file.title];


        GDChildListVC *gdChildVC = [[GDChildListVC alloc]initWithNibName:@"GDChildListVC" bundle:nil];
        NSLog(@"%@",file.identifier);
        gdChildVC.folderIdentifier = file.identifier;
        [self.navigationController pushViewController:gdChildVC animated:YES];
        


        
        
        
    }

    if (file.thumbnailLink) {
        if (!driveService) {
            [self initGoogleDriveManager];
        }
            //download the image and show it on view
            NSString *downloadUrl = file.downloadUrl;
            NSLog(@"\n\ngoogle drive file download url link = %@", downloadUrl);
            GTMHTTPFetcher *fetcher =
            [self.driveService.fetcherService fetcherWithURLString:downloadUrl];
            //async call to download the file data
            [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
                if (error == nil) {
                    //TODO: Do whatever you wnat to do with image
                    //show a image view
                    NSLog(@"Showing images");
                } else {
                    NSLog(@"An error occurred: %@", error);
                }
            }];
        
        
        }
   
    
}






-(void)changeTitleWithId:(NSString *)parentId
{
    NSString *title=[titleArray lastObject];
    self.titleLabel.text=title;
    
    [titleArray removeLastObject];
}

-(void)performBackNavigation
{
    level-=1;
    
    if (level==0)
    {
        self.titleLabel.text=@"Google Files";
        
        [parentIdArray removeAllObjects];
        [titleArray removeAllObjects];
        
        [buttonForBack removeTarget:self action:@selector(performBackNavigation) forControlEvents:UIControlEventTouchUpInside];
        [buttonForBack addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttonForBack setTitle:@"Cancel" forState:UIControlStateNormal];
        
        [self printFilesInFolderWithService:driveService folderId:@"root" andName:nil];
    }
    else
    {
        [parentIdArray removeLastObject];
        
        NSString *folderId=[parentIdArray lastObject];
        
        [self changeTitleWithId:folderId];
        [self printFilesInFolderWithService:driveService folderId:folderId andName:nil];
    }
    
}



-(void)printFilesInFolderWithService:(GTLServiceDrive *)service
                            folderId:(NSString *)folderId andName:(NSString *)name{
    
    
   // NSLog(@"folder id: %@", folderId);
    
  
    
    service.shouldFetchNextPages = NO;
    
    //[driveFiles removeAllObjects];
    
    GTLQueryDrive *query =
    [GTLQueryDrive queryForChildrenListWithFolderId:folderId];
    query.q =[NSString stringWithFormat:@"'%@' in parents and trashed=false", folderId];

    // queryTicket can be used to track the status of the request.
    GTLServiceTicket *queryTicket =
    [service executeQuery:query
        completionHandler:^(GTLServiceTicket *ticket,
                            GTLDriveChildList *children, NSError *error) {
           
            if (children.items.count == 0) {
                NSLog(@"Hello");

            }
           
            if (error == nil) {
                for (GTLDriveChildReference *child in children) {
                    NSLog(@"File Id: =======>>>%@", child.identifier);
                    
                    GTLQuery *query = [GTLQueryDrive queryForFilesGetWithFileId:child.identifier];
                    
                    if (!driveService) {
                        [self initGoogleDriveManager];
                    }
                    
                    // queryTicket can be used to track the status of the request.
                    [self.driveService executeQuery:query
                                  completionHandler:^(GTLServiceTicket *ticket,
                                                      GTLDriveFile *file,
                                                      NSError *error) {
                                      
                                      [driveFiles addObject:file];
                                      NSLog(@"Drive Files Array Count %lu",(unsigned long)[driveFiles count]);

                                      NSLog(@"%@",file.originalFilename);
                                      
                                      if (children.items.count==driveFiles.count)
                                      {
//                                          [UIView beginAnimations:nil context:NULL];
//                                          [UIView setAnimationDuration:0.4];
//                                          self.googleDriveDataTable.alpha=0.0;
//                                          [UIView commitAnimations];
//                                          
//                                          [self.googleDriveDataTable reloadData];
//                                          
//                                          [UIView beginAnimations:nil context:NULL];
//                                          [UIView setAnimationDuration:0.4];
//                                          self.googleDriveDataTable.alpha=1.0;
//                                          [UIView commitAnimations];
//                                          
//                                          viewForActivityIndicator.hidden=YES;
//                                          [activityIndicator stopAnimating];
                                          

                                          

                                          
                                      }
                                  }];
                }
            } else {
                NSLog(@"An error occurred: %@", error);
            }
        }];
    
    }






#pragma mark - Save Data

//-(void)saveFileJSONData:(NSData*)jsonData forFileName:(NSString*)fileName withCompletionHandler:(FileSavingCompletionHandler)completionHandler
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
//        
//        NSError *error;
//        BOOL fileSavingStatus = [jsonData writeToFile:fileName options:NSDataWritingAtomic error:&error];
//        
//        if (!error)
//        {
//            completionHandler(fileSavingStatus);
//        }
//        else
//        {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"File writing error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alertView show];
//            
//        }
//    });
//    
//    
//    
//}

-(NSString*)directoryPathForSavingFile:(NSString *)directoryName
{
    
    
    NSString *applicationDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    applicationDirectory = [applicationDirectory stringByAppendingPathComponent:directoryName];
    return applicationDirectory;//[applicationDirectory stringByAppendingPathComponent:directoryName];
}

#pragma mark Method creating MoreApps/Images dirictory

-(void)showFileAtPath:(NSString *)path
{

}

- (IBAction)dismissFromViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
