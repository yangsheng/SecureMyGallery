//
//  DBCollectionVC.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "DBCollectionVC.h"
#import "DropBoxCollectionCell.h"
#import "SVProgressHUD.h"
#import "GDImageDetailViewController.h"
#import "DropBoxImageDetailVC.h"
#import "DownloadManager.h"


@interface DBCollectionVC ()<DBRestClientDelegate>{
    
    NSMutableArray *dataArray;
    NSMutableArray *imgArray;
    BOOL shareEnabled;
    NSMutableArray *selectedImages;
    NSMutableArray *selectedCell;
    
    
}

@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong , nonatomic) DBRestClient *restClient;
@property (nonatomic) BOOL isLinked;
@property (nonatomic, strong) PGDataSource *pgDataSource;


@end

@implementation DBCollectionVC

@synthesize loadData,dropBoxCollectionView;
@synthesize restClient,isLinked;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [SVProgressHUD show];
    [self.dropBoxCollectionView registerNib:[UINib nibWithNibName:@"DropBoxCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    selectedImages = [[NSMutableArray alloc]init];
    self.dropBoxCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    if (!loadData) {
        loadData = @"/Photo Vault";
        //NSLog(@"load Data %@",loadData);
        
    }
    //[self.downloadButton setImage:[UIImage imageNamed:@"shareNew"] forState:UIControlStateNormal];
    self.pgDataSource = [[PGDataSource alloc]init];
    
    dataArray = [[NSMutableArray alloc]init];
    imgArray = [[NSMutableArray alloc]init];
    selectedCell = [[NSMutableArray alloc]init];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];

}
- (IBAction)downloadFromDropBox:(id)sender {
    [self.downloadButton setTitle:@"" forState:UIControlStateNormal];

    [self.downloadButton setImage:[UIImage imageNamed:@"downloadBtn"] forState:UIControlStateNormal];

    if (shareEnabled) {
        NSUInteger count = [selectedCell count];
        if (count) {
            for (NSIndexPath *newPath in selectedCell) {
                //                NSIndexPath *newPath = [selectedCell objectAtIndex:i];
                DBMetadata *metadata = [dataArray objectAtIndex:newPath.row];
                [selectedImages addObject:metadata];
            }
        }
        //DownloadManager *sharedManager = [DownloadManager sharedManager];
        int totalCount = (int)selectedImages.count;
        if (totalCount == 0) {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Please select first"
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel action");
                                           }];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                       }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            NSLog(@"Select First");
        }
        else{
        
            if ([selectedImages count] > 0) {
                

                DELEGATE.dbSelectedImages = [selectedImages mutableCopy];
                DELEGATE.folderName = self.folderName;
                
                NSString *notificationName = @"dropBoxDownload";
                
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
                [self dismissViewControllerAnimated:YES completion:nil];

//                for (int i = 0; i<totalCount; i++) {
//                    //[SVProgressHUD show];
//                    
//                    DBMetadata *metadata = [selectedImages objectAtIndex:i];
//                    NSLog(@"%@",metadata.path);
//                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//                    
//                    NSString* fPath = [documentsPath stringByAppendingPathComponent:
//                                       @"ustadji.jpg" ];
//                    
//                    
//                    [self.restClient loadFile:metadata.path intoPath:fPath];
//                }
                
            }
            
            // Deselect all selected items
//            for(NSIndexPath *indexPath in self.dropBoxCollectionView.indexPathsForSelectedItems) {
//                [self.dropBoxCollectionView deselectItemAtIndexPath:indexPath animated:NO];
//            }
            
            // Remove all items from selectedRecipes array
            [selectedImages removeAllObjects];
            
            // Change the sharing mode to NO
            shareEnabled = NO;
            self.dropBoxCollectionView.allowsMultipleSelection = NO;
//            
//            [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
//            
        }

        }
            

    else {
        
        // Change shareEnabled to YES and change the button text to DONE
            shareEnabled = YES;
            self.dropBoxCollectionView.allowsMultipleSelection = YES;
//        self.downloadButton.title = @"Upload";
//        [self.downloadButton setStyle:UIBarButtonItemStyleDone];
        [self.downloadButton setTitle:@"" forState:UIControlStateNormal];

        [self.downloadButton setImage:[UIImage imageNamed:@"downloadBtn"] forState:UIControlStateNormal];

            self.downloadButton.imageView.hidden = YES;

    
    }
    
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

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    
    NSLog(@"%@",destPath);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"File downloaded successfully."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
   // NSLog(@"CheckPoint");
    [SVProgressHUD dismiss];
    [self moveItemAtFolder:destPath];
    
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
    [dropBoxCollectionView reloadData];
    [SVProgressHUD dismiss];
    
    NSLog(@"Thumnail image    %@",imgArray);
    NSLog(@"DropBox Data Files%@",dataArray);
}

-(void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath metadata:(DBMetadata *)metadata{
    
   //this is the delegate method

    
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    //[dropBoxDataTable reloadData];
    NSLog(@"Meata Data Loading Failed With Error");
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    NSLog(@"Loaded: %@", destPath);
    
    
    
}




#pragma mark - Collection View
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [dataArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DropBoxCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    DBMetadata *metadata = [dataArray objectAtIndex:indexPath.row];

    NSLog(@" name %@",metadata.filename);
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:metadata.filename];
    cell.dropBoxImageView.image = [UIImage imageWithContentsOfFile:filePath];

    if (!cell.selected) {
        cell.selectedImageView.hidden = YES;

    }
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (shareEnabled) {
       DropBoxCollectionCell *cell = (DropBoxCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        // Determine the selected items by using the indexPath
        DBMetadata *metadata = [dataArray objectAtIndex:indexPath.row];
        // Add the selected item into the array
        cell.selectedImageView.hidden = NO;

        NSLog(@"%@",metadata.filename);
        [selectedCell addObject:indexPath];
    }

    else{

    }
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dropBoxCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (shareEnabled) {
        DropBoxCollectionCell *cell = (DropBoxCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        // Determine the selected items by using the indexPath
       // DBMetadata *metadata = [dataArray objectAtIndex:indexPath.row];
        //NSString *selectedImage = [dataArray objectAtIndex:indexPath.row];
        // Add the selected item into the array
        cell.selectedImageView.hidden = YES;
        
        //NSLog(@"%@",metadata.filename);
        if (selectedCell.count) {
            [selectedCell removeObject:indexPath];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.dropBoxCollectionView.bounds.size.width / 3 - 1;
    return CGSizeMake(width, width);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)dismissViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
