//
//  DropBoxDownLoadListVC.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/12/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//
#import <DropboxSDK/DropboxSDK.h>
#import "DropBoxDownLoadListVC.h"
#import "DropBoxCell.h"
#import "PGDataSource.h"

@interface DropBoxDownLoadListVC ()<DBRestClientDelegate>{

    NSMutableArray *dataArray;
    NSMutableArray *imgArray;
    
}

@property (strong , nonatomic) DBRestClient *restClient;
@property (nonatomic) BOOL isLinked;
@property (nonatomic, strong) PGDataSource *pgDataSource;
@property (nonatomic, strong) NSFileManager *fileManager;


@end

@implementation DropBoxDownLoadListVC

@synthesize loadData,dropBoxDataTable;
@synthesize restClient,isLinked;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!loadData) {
        loadData = @"/Photo Vault";
        NSLog(@"load Data %@",loadData);

    }
    self.pgDataSource = [[PGDataSource alloc]init];

    dataArray = [[NSMutableArray alloc]init];
    imgArray = [[NSMutableArray alloc]init];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
    [self.dropBoxDataTable reloadData];

}

#pragma mark - Dropbox Methods

- (DBRestClient *)restClient
{
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

-(void)fetchAllDropboxData
{
    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
    //NSLog(@"load Data %@",loadData);
    [self.restClient loadMetadata:@"/"];
}



#pragma mark - DBRestClientDelegate Methods for Load Data
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        if (data.isDirectory) {
            
        }
        else{
        [dataArray addObject:data];

        [restClient loadThumbnail:data.path ofSize:@"m" intoPath:[NSTemporaryDirectory() stringByAppendingPathComponent:data.filename]];
//            [restClient loadThumbnail:<#(NSString *)#> ofSize:<#(NSString *)#> intoPath:<#(NSString *)#>];
        }
        
        
    }
    [dropBoxDataTable reloadData];

    NSLog(@"Thumnail image    %@",imgArray);
    NSLog(@"DropBox Data Files%@",dataArray);
}

-(void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath metadata:(DBMetadata *)metadata{
    
    NSLog(@"%@",metadata.path);
    //UIImage *image = [UIImage imageWithContentsOfFile:destPath];
    //Do something with my thumbnail
    //[imgArray addObject:image];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    //[dropBoxDataTable reloadData];
    NSLog(@"Meata Data Loading Failed With Error");
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    //NSLog(@"Loaded: %@", destPath);
    //UIImage *image = [UIImage imageWithContentsOfFile:destPath];
    //Do something with my thumbnail
    //[imgArray addObject:image];
   

}



#pragma mark - DBRestClientDelegate Methods for Download Data

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
   
    NSLog(@"%@",destPath);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"File downloaded successfully."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
    NSLog(@"CheckPoint");
    
    [self moveItemAtFolder:destPath];
    
}

-(void)moveItemAtFolder:(NSString *)filePath{
    
    UIImage *downloadedImage = [UIImage imageWithContentsOfFile: filePath];
    NSData *imageData = UIImageJPEGRepresentation(downloadedImage, 1);
    [imageData writeToFile:filePath atomically:YES];


    NSLog(@"%@",downloadedImage);
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
    [workingDictionary setObject:ALAssetTypePhoto forKey:@"UIImagePickerControllerMediaType"];
    [workingDictionary setObject:downloadedImage forKey:@"UIImagePickerControllerOriginalImage"];
    [workingDictionary setObject:filePath forKey:@"UIImagePickerControllerReferenceURL"];
   
    [returnArray addObject:workingDictionary];

    //NSLog(@"%@",self.folderName);
    [self.pgDataSource importArrayDictionary:returnArray ToFolder:self.folderName];
//    [self.fileManager removeItemAtPath:filePath error:nil];
    
    

}

-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:[error localizedDescription]
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}




#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{

    //return [dataArray count];
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{

    static NSString *cellIdentifier = @"cell";
    DropBoxCell *cell = (DropBoxCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DropBoxCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.downLoadButton.tag = indexPath.row;
    DBMetadata *metadata = [dataArray objectAtIndex:indexPath.row];
    
    [cell.downLoadButton setTitle:metadata.path forState:UIControlStateDisabled];
    [cell.downLoadButton addTarget:self action:@selector(btnDownloadPress:) forControlEvents:UIControlEventTouchUpInside];
    
    if (metadata.isDirectory) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.downLoadButton.hidden = YES;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.downLoadButton.hidden = NO;
    }
    cell.nameLabel.text = metadata.filename;
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:metadata.filename];
    cell.imageview.image = [UIImage imageWithContentsOfFile:filePath];//[UIImage imageNamed:@"NoPhotosBig.png"];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    
}


-(void)btnDownloadPress:(id)sender{
    UIButton *btnDownload = (UIButton *)sender;
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(downloadFileFromDropBox:) withObject:[btnDownload titleForState:UIControlStateDisabled] afterDelay:.1];
   
    
}


-(void)downloadFileFromDropBox:(NSString *)filePath
{
   


//    [self.pgDataSource createFolderWithName: @"DropBox"];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
  
    NSString* fPath = [documentsPath stringByAppendingPathComponent:
                       @"ustadji.jpg" ];
    
    NSLog(@"First Final Path ------->>>>>%@",fPath);

     [self.restClient loadFile:filePath intoPath:fPath];
    
    

}

- (IBAction)doneImporting:(id)sender {

}

- (IBAction)dismissViewController:(id)sender {
    [restClient cancelAllRequests];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
