//
//  GDCollectionVC.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "GDCollectionVC.h"
#import "GoogleDriveManager.h"
#import "GDCollectionCellCollectionViewCell.h"
#import "SVProgressHUD.h"
#import "GDImageDetailViewController.h"
//#import "GDCollectionHeader.h"
#import "PGDataSource.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "DownloadManager.h"
static NSString *const kKeychainItemName = @"My App";
static NSString *const kClientId = @"861941523810-lfd2q6ss0uni2a3gd5ve7rc45090u7ej.apps.googleusercontent.com";
static NSString *const kClientSecret = @"ShJN0ZuUNUceWkWnOnDiRNvr";

typedef void(^FileSavingCompletionHandler) (BOOL successStatus);
//861941523810-lfd2q6ss0uni2a3gd5ve7rc45090u7ej.apps.googleusercontent.com
//ShJN0ZuUNUceWkWnOnDiRNvr

@interface GDCollectionVC (){

    NSMutableArray *dataArray;
    SGAppDelegate *appDelegate;
    NSMutableArray *googleDriveDataArray;;
    NSMutableArray *driveFolderArray;
    NSMutableArray *driveFileArray;
    BOOL fileFetchStatusFailure;
    NSMutableArray *selectedImages;
    BOOL shareEnabled;
    int flagCount;
    NSMutableArray *selectedCell;
}

@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (nonatomic, strong) PGDataSource *pgDataSource;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, retain) GTLServiceDrive *driveService;

@end

@implementation GDCollectionVC

@synthesize googleDriveCollectionView,driveService;

- (void)initGoogleDriveManager
{
    [SVProgressHUD dismiss];

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.googleDriveCollectionView registerNib:[UINib nibWithNibName:@"GDCollectionCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)googleDriveCollectionView.collectionViewLayout;
    self.googleDriveCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //[self.downloadButton setImage:[UIImage imageNamed:@"shareNew"] forState:UIControlStateNormal];

    self.pgDataSource = [[PGDataSource alloc]init];
    googleDriveDataArray = [[NSMutableArray alloc]init];
    driveFolderArray = [[NSMutableArray alloc]init];
    driveFileArray = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    selectedImages = [[NSMutableArray alloc]init];
    selectedCell = [[NSMutableArray alloc]init];
    dataArray = [NSMutableArray arrayWithObjects:driveFolderArray,driveFileArray,nil];
    // [self loadDriveFilesForMyDrive];
    flagCount = 0;
    //[SVProgressHUD show];
    [self fetchFiles];

}


- (void)fetchFiles
{

    
    [[GoogleDriveManager sharedInstance] fetchFilesWithCompletionBlock:^(BOOL success, NSArray *files, NSError *error) {
        [SVProgressHUD show];

        if(success)
        {
            [SVProgressHUD show];

//            NSLog(@"__________________________________________");
//            
//            NSLog(@"Files From Google Drive>>>>>>>>>%@",files);
//            NSLog(@"__________________________________________");
            
            NSMutableString *filesString = [[NSMutableString alloc] init];
            if (files.count > 0) {
                [filesString appendString:@"Files:\n"];
                for (GTLDriveFile *file in files) {
                    [filesString appendFormat:@"%@ (%@)\n", file.title, file.identifier];
                    //NSLog(@" Appended String ========>>>>>>%@",file.title);
                   
                        [googleDriveDataArray addObject:file];

                    
//                    if ([file.mimeType isEqualToString:@"application/vnd.google-apps.folder"]){
//                        [driveFolderArray addObject:file];
//                    }
//                    else {
//                    
//                        [driveFileArray addObject:file];
//                    }
                }
            } else {
                [filesString appendString:@"No files found."];
                [SVProgressHUD dismiss];

            }
            //self.output.text = filesString;
            
        }
        else
        {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            
            //[self showAlert:@"Error" message:error.localizedDescription];
        }
        [SVProgressHUD dismiss];

        
        [self.googleDriveCollectionView reloadData];

    }];

}



- (IBAction)downloadFromGoogleDrive:(id)sender {
    [self.downloadButton setTitle:@"" forState:UIControlStateNormal];
    [self.downloadButton setImage:[UIImage imageNamed:@"downloadBtn"] forState:UIControlStateNormal];
    
    //[self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    
    if (shareEnabled) {
       // DownloadManager *sharedManager = [DownloadManager sharedManager];
        NSUInteger count = [selectedCell count];
        if (count) {
            for (NSIndexPath *newPath in selectedCell) {
//                NSIndexPath *newPath = [selectedCell objectAtIndex:i];
                GTLDriveFile *file = [googleDriveDataArray objectAtIndex:newPath.row];
                [selectedImages addObject:file];
            }
        }
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
                
                DELEGATE.gdSelectedImeges = [selectedImages mutableCopy];
                DELEGATE.folderName = self.folderName;
//
//                NSString *gdNotificationName = @"googleDriveDownload";
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:gdNotificationName object:nil userInfo:nil];
//                [self dismissViewControllerAnimated:YES completion:nil];
                

                for (int i = 0; i<totalCount; i++) {
                    
                    GTLDriveFile *file = [selectedImages objectAtIndex:i];

                    [self downloadFileContentWithService:@"Eaxmple"
                                                    file:file];
                }
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            
            // Deselect all selected items
//            for(NSIndexPath *indexPath in self.googleDriveCollectionView.indexPathsForSelectedItems) {
//                [self.googleDriveCollectionView deselectItemAtIndexPath:indexPath animated:NO];
//            }
            
            // Remove all items from selectedRecipes array
            [selectedImages removeAllObjects];
            
            // Change the sharing mode to NO
            shareEnabled = NO;
            self.googleDriveCollectionView.allowsMultipleSelection = NO;
            //        self.downloadButton.title = @"Download";
            //        [self.downloadButton setStyle:UIBarButtonItemStylePlain];
            [self.downloadButton setTitle:@"" forState:UIControlStateNormal];

            [self.downloadButton setImage:[UIImage imageNamed:@"downloadBtn"] forState:UIControlStateNormal];
            //self.downloadButton.imageView.hidden = YES;
            
        }

        }
    
    else {
        
        // Change shareEnabled to YES and change the button text to DONE
        shareEnabled = YES;
        self.googleDriveCollectionView.allowsMultipleSelection = YES;
        //        self.downloadButton.title = @"Upload";
        //        [self.downloadButton setStyle:UIBarButtonItemStyleDone];
        [self.downloadButton setTitle:@"" forState:UIControlStateNormal];

        [self.downloadButton setImage:[UIImage imageNamed:@"downloadBtn"] forState:UIControlStateNormal];
        
        self.downloadButton.imageView.hidden = YES;
        
        
    }

    
}
#pragma mark-Saving Files

//- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
//    
//    //assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
//    
//    NSError *error = nil;
//    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
//                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
//    if(!success){
//        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
//    }
//    else{
//        NSLog(@"Skip Attribute added successfully for %@", [URL lastPathComponent]);
//    }
//    
//    return success;
//}


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
#pragma mark-Downloading

-(void)downloadFileContentWithService:(NSString *)loaclpath
                                 file:(GTLDriveFile *)file
{
    NSLog(@"Dwonload URL %@",file.downloadUrl);
    if (file.downloadUrl != nil)
    {
        if (!self.driveService) {
            [self initGoogleDriveManager];
        }
        NSLog(@"begin download");
        GTMHTTPFetcher *fetcher =[self.driveService.fetcherService fetcherWithURLString:file.downloadUrl];
        [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
            if (error == nil) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                
                NSString* fPath = [documentsPath stringByAppendingPathComponent:
                                                   @"test.jpg" ];
                //[data writeToFile:@"/Users/mycomputer/Desktop/a.mov" atomically:YES];
                //[data writeToFile:@"/Users/mycomputer/Desktop/b.mov" atomically:YES];
                [data writeToFile:fPath atomically:YES];
                NSLog(@"download ok");
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
//                                                               message:@"File downloaded successfully."
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"Ok"
//                                                     otherButtonTitles:nil];
//                //[alert show];
               
                [self moveItemAtFolder:fPath];
                NSString *notificationName = @"refreshDownLoadForGD";
                [[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:nil];
                
                int count = (int)DELEGATE.gdSelectedImeges.count;
                if (flagCount<count-1){
                    ++flagCount;
                }
                else{
                    
                    [DELEGATE.gdSelectedImeges removeAllObjects];
                }

            } else {
                NSLog(@"An error occurred: %@", error);
            }
        }];
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
    
    [SVProgressHUD dismiss];
    
}
-(NSString*)directoryPathForSavingFile:(NSString *)directoryName
{
    //NSString *directoryName = @"pdfFile";
    // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    // NSString *applicationDirectory = [paths objectAtIndex:0];
    
    NSString *applicationDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"name.png"];
    applicationDirectory = [applicationDirectory stringByAppendingPathComponent:directoryName];
    return applicationDirectory;//[applicationDirectory stringByAppendingPathComponent:directoryName];
}


#pragma mark -Collection View



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    // dataArray is a class member variable that contains one array per section.
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    NSLog(@"%lu",[googleDriveDataArray count]);
    return [googleDriveDataArray count];

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     GDCollectionCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    GTLDriveFile *file = [googleDriveDataArray objectAtIndex:indexPath.row] ;//[dataArray[indexPath.section] objectAtIndex:indexPath.row]

    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:file.thumbnailLink]];
    UIImage *image = [UIImage imageWithData:data];
    if ([file.mimeType isEqualToString:@"application/vnd.google-apps.folder"])
    {
        //cell.googleDriveImageView.image = [UIImage imageNamed:@"folder.png"];
    }
    else if (file.thumbnailLink) {
        cell.googleDriveImageView.image = image;

    }
   // cell.googleDriveImageView.image = image;
//    {
//        
//        //download the image and show it on view
//        NSString *downloadUrl = file.downloadUrl;
//        NSLog(@"\n\ngoogle drive file download url link = %@", downloadUrl);
//        GTMHTTPFetcher *fetcher =
//        [self.driveService.fetcherService fetcherWithURLString:downloadUrl];
//        //async call to download the file data
//        [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
//            if (error == nil) {
//                //TODO: Do whatever you wnat to do with image
//            } else {
//                NSLog(@"An error occurred: %@", error);
//            }
//        }];
//    }
    if (!cell.selected) {
        cell.selectedImageView.hidden = YES;

    }
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //downloadUrl
    if (shareEnabled) {
        GTLDriveFile *file = [googleDriveDataArray objectAtIndex:indexPath.row];
        GDCollectionCellCollectionViewCell *cell = (GDCollectionCellCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell.selectedImageView.hidden = NO;
        //[DELEGATE.gdSelectedImeges addObject:file];
//        [selectedImages addObject:file];

        [selectedCell addObject:indexPath];
    }
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.googleDriveCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (shareEnabled) {
        GDCollectionCellCollectionViewCell *cell = (GDCollectionCellCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell.selectedImageView.hidden = YES;
        NSLog(@"%ld",indexPath.row);
        NSUInteger count = selectedImages.count;
        
        //[selectedImages removeObjectAtIndex:indexPath.row];
        if (selectedCell.count) {
            [selectedCell removeObject:indexPath];
        }
        
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.googleDriveCollectionView.bounds.size.width / 3 - 1;
    return CGSizeMake(width, width);
}

//- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    GDCollectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
//                                         UICollectionElementKindSectionHeader withReuseIdentifier:@"CELL" forIndexPath:indexPath];
//    //set title to header
//    if (kind == UICollectionElementKindSectionHeader) {
//        
//        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CELL" forIndexPath:indexPath];
//        
//        if (reusableview==nil) {
//            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        }
//        
//        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        label.text=[NSString stringWithFormat:@"Recipe Group #%li", indexPath.section + 1];
//        [reusableview addSubview:label];
//        return reusableview;
//    }
//    return headerView;
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
////    CGSize headerSize = CGSizeMake(320, 44);
////    return headerSize;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)dismissViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
