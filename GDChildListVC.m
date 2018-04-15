//
//  GDChildListVC.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/21/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "GDChildListVC.h"
#import "GoogleDriveManager.h"
#import "GTLDrive.h"
#import "GTLDriveChildReference.h"
#import "SVProgressHUD.h"
#import "GTMOAuth2ViewControllerTouch.h"

static NSString *const kKeychainItemName = @"My App";
static NSString *const kClientId = @"861941523810-lfd2q6ss0uni2a3gd5ve7rc45090u7ej.apps.googleusercontent.com";
static NSString *const kClientSecret = @"ShJN0ZuUNUceWkWnOnDiRNvr";

@interface GDChildListVC (){

    int level;
}

@property (nonatomic, retain) GTLServiceDrive *driveService;
@property (strong , nonatomic) NSMutableArray *driveFiles;
@property (strong , nonatomic) NSMutableArray *parentIdArray;
@property (strong , nonatomic) NSMutableArray *titleArray;
@property (strong , nonatomic) NSMutableArray *fileNames;

@end

@implementation GDChildListVC

@synthesize driveFiles,driveService;

- (void)viewDidLoad {
    [super viewDidLoad];

    //NSLog(@"%@",self.childListArray);
    // Do any additional setup after loading the view from its nib.
    
    self.gdChildDataTable.delegate=self;
    self.gdChildDataTable.dataSource=self;
    //tableViewForFiles.separatorStyle=UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
    
    
    
    
    
    self.parentIdArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.titleArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.fileNames = [[NSMutableArray alloc]initWithCapacity:0];

    
    
   
    
    driveFiles = [[NSMutableArray alloc]init];
    if (!driveService) {
        [self initGoogleDriveManager];
    }
    [SVProgressHUD show];
    [self printFilesInFolderWithService:driveService folderId:self.folderIdentifier];

    [self.backButton addTarget:self  action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];

}
- (IBAction)backButtonAction:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelClicked{

    [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewWillAppear:(BOOL)animated{
//    [SVProgressHUD show];
//    [self printFilesInFolderWithService:driveService folderId:self.folderIdentifier];
}


#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    
    NSLog(@"%d",[driveFiles count]);

    return [driveFiles count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    }
    
    GTLDriveFile *file = [driveFiles objectAtIndex:indexPath.row];
    NSData * data;
    NSLog(@"%@ \n %@",file.thumbnailLink,file.selfLink);
    if (file.thumbnailLink) {
         data = [NSData dataWithContentsOfURL:[NSURL URLWithString:file.thumbnailLink]];

    }
    UIImage *image = [UIImage imageWithData:data];
    if ([file.kind isEqualToString:@"application/vnd.google-apps.folder"])
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        //imageViewForIcon.image=[UIImage imageNamed:@"folder.png"];
        cell.textLabel.text = file.identifier;
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
    }
    else if (file.thumbnailLink) {
        cell.textLabel.text = file.title;
        cell.imageView.image = image;
        cell.accessoryType = UITableViewCellAccessoryNone;
  
        
    }
    else{
        
        cell.textLabel.text = file.title;
        
    }
    
    
//    cell.textLabel.text = @"Test";
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    GTLDriveFile *file = [driveFiles objectAtIndex:indexPath.row];
    if ([file.mimeType isEqualToString:@"application/vnd.google-apps.folder"])
    {
        level+=1;
        [self.parentIdArray addObject:file.identifier];
    if ([self.backButton.titleLabel.text isEqualToString:@"Cancel"])
    {
        [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
        [self.backButton removeTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton addTarget:self action:@selector(performBackNavigation) forControlEvents:UIControlEventTouchUpInside];
    }
    GDChildListVC *gdChildVC = [[GDChildListVC alloc]initWithNibName:@"GDChildListVC" bundle:nil];
    NSLog(@"%@",file.identifier);
    gdChildVC.folderIdentifier = file.identifier;
    [self printFilesInFolderWithService:driveService folderId:file.identifier];
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

-(void)printFilesInFolderWithService:(GTLServiceDrive *)service
                            folderId:(NSString *)folderId {
    
    
    // NSLog(@"folder id: %@", folderId);
    
    [driveFiles removeAllObjects];
    
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
                NSLog(@"Hello,No Item Exists");
                [SVProgressHUD dismiss];
            }
           // NSLog(@"Counting Children %lu",(unsigned long)children.items.count);
            //            [driveFiles addObject:children.items];
           // NSLog(@"Drive Files Array Count %lu",(unsigned long)[driveFiles count]);
            
            if (error == nil) {
                for (GTLDriveChildReference *child in children) {
                    NSLog(@"File Id: =======>>>%@", child.identifier);
                    
                    GTLQuery *query = [GTLQueryDrive queryForFilesGetWithFileId:child.identifier];
                    
                   
                    
                    // queryTicket can be used to track the status of the request.
                    [self.driveService executeQuery:query
                                  completionHandler:^(GTLServiceTicket *ticket,
                                                      GTLDriveFile *file,
                                                      NSError *error) {
                                      
                                      [driveFiles addObject:file];
                                      NSLog(@"Drive Files Array Count %lu",(unsigned long)[driveFiles count]);
                                      
                                      //NSLog(@"%@",file.originalFilename);
                                      
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
                                          
                                          
                                          [SVProgressHUD dismiss];
                                          
                                          [self.gdChildDataTable reloadData];

                                      }
                                  }];
                }
            } else {
                NSLog(@"An error occurred: %@", error);
            }

        }];
    
}


-(void)changeTitleWithId:(NSString *)parentId
{
    NSString *title=[self.titleArray lastObject];
    self.navigationController.title = title;
    [self.titleArray removeLastObject];
}

-(void)performBackNavigation
{
    level-=1;
    
    if (level==0)
    {
        //titleLabel.text=@"Google Files";
        self.navigationController.title = @"Google Files";
        [self.parentIdArray removeAllObjects];
        [self.titleArray removeAllObjects];
        
        [self.backButton removeTarget:self action:@selector(performBackNavigation) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
        [self printFilesInFolderWithService:driveService folderId:@"root" ];
    }
    else
    {
        [self.parentIdArray removeLastObject];
        
        NSString *folderId=[self.parentIdArray lastObject];
        
        [self changeTitleWithId:folderId];
        [self printFilesInFolderWithService:driveService folderId:folderId];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
