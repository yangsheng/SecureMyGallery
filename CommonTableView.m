//
//  MyViewController.m
//  MusicApp
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "CommonTableView.h"
#import "DropboxViewController.h"
#define APP_KEY @"5af0p8jgymj92vn"
#define APP_SECRET @"2e05mhq9vmedaum"
#define ACCESS_TYPE @"dropbox"

//#define BDAPP_KEYTEST @"5af0p8jgymj92vn"
//#define DBAPP_SECRETTEST @"2e05mhq9vmedaum"

static NSString *folderPath;

@interface CommonTableView (){
    DBRestClient *restClient;
    NSMutableArray *metaDataArray;
    NSMutableArray *metaDataArrayFolders;
    NSString *localPathDropbox;
    NSArray *directoryContent;
    NSMutableArray *selectedIndexes;
    NSString *folderdirName;
    NSString *filePath;
    UIActivityIndicatorView *spinner;
}
@property (weak, nonatomic) IBOutlet UITableView *dataTable;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectDeselectBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;


@end

@implementation CommonTableView


- (void)viewDidLoad {
    [super viewDidLoad];
    
    metaDataArray = [[NSMutableArray alloc] init];
    metaDataArrayFolders = [[NSMutableArray alloc] init];
    
    self.dataTable.delegate = self;
    self.dataTable.dataSource = self;
    
    DBSession* dbSession = [[DBSession alloc]
                            initWithAppKey:APP_KEY
                            appSecret:APP_SECRET
                            root:kDBRootDropbox];
    
    [DBSession setSharedSession:dbSession];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject]; //Get the docs directory
    localPathDropbox = [documentsPath stringByAppendingPathComponent:@"/Music/"];                                                       //
    
    selectedIndexes = [[NSMutableArray alloc] init];
    
    if (self.rootPath) {
        folderPath = @"/";
        folderPath = [folderPath stringByAppendingPathComponent:self.navTitle];
        self.rootPath = nil;
    }
    
    if (folderPath) {
    }
    else {
        folderPath = @"/";
        folderPath = [folderPath stringByAppendingPathComponent:self.navTitle];
    }
    
    metaDataArray = [self.dataArray mutableCopy];
    metaDataArrayFolders = [self.dataFolderArray mutableCopy];
    self.backBtn.hidden = YES;
    
    self.dataTable.rowHeight = 56;
    
    
    
//    if (IS_DEVICE_IPAD) {
//        self.dataTable.contentInset = UIEdgeInsetsMake(0, 0, table_inset_value_ipad, 0);
//        
//    }
//    else
//        
//        self.dataTable.contentInset = UIEdgeInsetsMake(0, 0, table_inset_value, 0);
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = self.navTitle;
    [self.dataTable setEditing:YES];
    self.downloadBtn.enabled = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    if (![[NSFileManager defaultManager] fileExistsAtPath:localPathDropbox])
        [[NSFileManager defaultManager] createDirectoryAtPath:localPathDropbox withIntermediateDirectories:NO attributes:nil error:nil];
    [self restClient];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isBack"]) {
        self.dataTable.userInteractionEnabled = NO;
        [self backBtnAction:self];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBack"];
        
    }
    [super viewWillDisappear:animated];
}



#pragma mark - Action Stack

- (IBAction)backBtnAction:(id)sender {
    if ([folderPath isEqualToString:@""] || !folderPath) return;
    NSString *str = [folderPath substringWithRange:NSMakeRange(0, [folderPath rangeOfString:@"/" options:NSBackwardsSearch].location)];
    if ([str isEqualToString:@"/"] || [str isEqualToString:@""]) {
        
    }else {
        [self loadDataWithFolderName:filePath];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)loadData:(UIButton*)sender {
    sender.enabled = NO;
    [metaDataArray removeAllObjects];
    [metaDataArrayFolders removeAllObjects];
    folderPath = @"";
    [[self restClient] loadMetadata:@"/"];
}

- (IBAction)btnPressed:(id)sender {
    [self didPressLink];
}

#pragma mark - Dropbox Stack

- (void)didPressLink {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
}

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

-(void)showIndicatorInView:(UIView*)view{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = view.center;
    spinner.hidesWhenStopped = YES;
    [view addSubview:spinner];
    spinner.tag = 90;
    [spinner startAnimating];
}

-(void)hideIndicator{
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}


-(BOOL)loadData{
    [self showIndicatorInView:self.view];
    if (![[DBSession sharedSession] isLinked]) {
        [self didPressLink];
    }else {
        [metaDataArray removeAllObjects];
        [metaDataArrayFolders removeAllObjects];
        NSLog(@"%@",folderPath);
        folderPath = @"";
        self.backBtn.hidden = YES;
        [[self restClient] loadMetadata:@"/"];
    }
    return YES;
}

-(void)loadDataDb:(NSNotification*)n{
    [metaDataArray removeAllObjects];
    [metaDataArrayFolders removeAllObjects];
    folderPath = @"";
    [[self restClient] loadMetadata:@"/"];
}

-(void)loadDataWithFolderName2:(NSString*)folderName{
    [self showIndicatorInView:self.view];
    self.backBtn.hidden = NO;
    [metaDataArray removeAllObjects];
    [metaDataArrayFolders removeAllObjects];
    
    [[self restClient] loadMetadata:[NSString stringWithFormat:@"%@/", folderPath]];
}


-(void)loadDataWithFolderName:(NSString*)folderName{
    [self showIndicatorInView:self.view];
    self.backBtn.hidden = NO;
    [metaDataArray removeAllObjects];
    [metaDataArrayFolders removeAllObjects];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isBack"]) {
        
        folderPath = [folderPath stringByAppendingPathComponent:folderName];
        [[self restClient] loadMetadata:[NSString stringWithFormat:@"%@/", folderPath]];
        
    }
    else{
        folderPath = folderName;
        [[self restClient] loadMetadata:[NSString stringWithFormat:@"%@", folderPath]];
        
    }

}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-1] animated:YES];

    if (metadata.isDirectory) {
        for (DBMetadata *file in metadata.contents) {
            
            if (file.isDirectory) {
                [metaDataArrayFolders addObject:file];
                
            } else if ([file.path.pathExtension isEqualToString:@"jpeg"] || [file.path.pathExtension isEqualToString:@"jpg"] || [file.path.pathExtension isEqualToString:@"png"]){
                [metaDataArray addObject:file];
                 [restClient loadThumbnail:file.path ofSize:@"m" intoPath:[NSTemporaryDirectory() stringByAppendingPathComponent:file.filename]];
            }
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isBack"]) {

        [self.dataTable reloadData];

    }
    else {
        if (![folderPath isEqualToString:@""]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CommonTableView *comVC = [[CommonTableView alloc] initWithNibName:@"CommonTableView" bundle:nil];
                comVC.dataArray = [metaDataArray mutableCopy];
                comVC.dataFolderArray = [metaDataArrayFolders mutableCopy];
                comVC.navTitle = folderdirName;
                [self.navigationController pushViewController:comVC animated:YES];
            });
        }
    }
    [self hideIndicator];
    self.dataTable.userInteractionEnabled = YES;
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);
    NSError *error;
    directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPathDropbox error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self.dataTable reloadData];
}
- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    NSLog(@"File loaded into path: %@", localPath);
}

-(void)restClient:(DBRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath{
    NSLog(@"%.2f%%", progress*100);
}

#pragma mark - Table View Stack

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (!metaDataArray.count && !metaDataArrayFolders.count) {
        return nil;
    }
    
    if (section == 0) {
        return @"Dropbox Folders";
    } else return @"Dropbox Mp3 Files";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!metaDataArray.count && !metaDataArrayFolders.count) {
        return [UIView new];
    }
    NSString *header;
    if (section == 0) {
        header = @"Dropbox Folders";
    } else header = @"Dropbox Mp3 Files";
    
    UIView* v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,44)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.shadowColor = [UIColor whiteColor];
    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor lightGrayColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont boldSystemFontOfSize:17];
    [tempLabel setFont:[UIFont fontWithName:@"OpenSans" size:17.0f]];
    tempLabel.text = header;
    [v addSubview:tempLabel];
    return v;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && metaDataArrayFolders.count) {
        return metaDataArrayFolders.count;
    } else if (section == 1 && metaDataArray.count) {
        return metaDataArray.count;
    }else return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMetadata* file;
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.preservesSuperviewLayoutMargins = NO;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = @"";
    
    if (indexPath.section == 0 && metaDataArrayFolders.count) {
        file = [metaDataArrayFolders objectAtIndex:indexPath.row];
        cell.textLabel.text = file.filename;
        cell.imageView.image = [UIImage imageNamed:@"folder"];
    } else if (indexPath.section == 1 && metaDataArray.count) {
        file = [metaDataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = file.filename;
        [self showIndicatorInView:cell.imageView];
        file = [metaDataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = file.filename;
        NSLog(@" name %@",file.path);
        NSString *imageFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:file.filename];
        
        UIImage *dbImage = [UIImage imageWithContentsOfFile:imageFilePath];
        UIImage *scaledImage = [DropboxViewController imageWithImage:dbImage scaledToWidth:40.0 andHeight:40];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.imageView.image = scaledImage;
        [self hideIndicator];
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMetadata *file;
    if (indexPath.section == 0) {
        file = [metaDataArrayFolders objectAtIndex:indexPath.row];
    } else {
        file = [metaDataArray objectAtIndex:indexPath.row];
    }
    if (self.dataTable.isEditing) {
        if (![file isDirectory]) {
            [selectedIndexes addObject:file];
            if (selectedIndexes.count == metaDataArray.count) {
                [self.selectDeselectBtn setTitle:@"Deselect All" forState:UIControlStateNormal];
                self.selectDeselectBtn.tag=0;
            }
            self.downloadBtn.enabled = YES;
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBack"];
            [self loadDataWithFolderName:file.filename];
            folderdirName = file.filename;
            filePath = [file.path stringByDeletingLastPathComponent];
            return;
        }
    }else {
        if ([file isDirectory]) {
            [self loadDataWithFolderName:file.filename];
            folderdirName = file.filename;
            return;
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:localPathDropbox])
            [[NSFileManager defaultManager] createDirectoryAtPath:localPathDropbox withIntermediateDirectories:NO attributes:nil error:nil];
//        if ([DELEGATE.directoryContent containsObject:file.filename]) {
//            return;
//        }
//        if (!DELEGATE.downloadingFilesDictionary.count) {
//            [DELEGATE.downloadManager loadFileIntoDownloadingArray:file toDownloadIntoPath:localPathDropbox];
//        }
//        [DELEGATE.dropboxDownloadingArray addObject:file];
//        [DELEGATE.directoryContent addObject:file.filename];
//        [DELEGATE.downloadManager.fileSourceArray setValue:@"Dropbox" forKey:file.filename];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    } else return UITableViewCellEditingStyleDelete;
}

- (IBAction)selectDeselectBtnAct:(UIButton*)sender {
    NSIndexPath *ind;
    if (sender.tag) {
        if (selectedIndexes.count) {
            [selectedIndexes removeAllObjects];
        }
        
        for (int i=0; i<metaDataArray.count; i++) {
            ind = [NSIndexPath indexPathForRow:i inSection:1];
            if (![[metaDataArray objectAtIndex:i] isDirectory]) {
                [self.dataTable selectRowAtIndexPath:ind animated:YES scrollPosition:UITableViewScrollPositionNone];
                [selectedIndexes addObject:[metaDataArray objectAtIndex:i]];
            }
            
        }
        
        sender.tag=0;
        [sender setTitle:@"Deselect All" forState:UIControlStateNormal];
        self.downloadBtn.enabled = YES;
    }
    
    else{
        for (int i=0; i<metaDataArray.count; i++) {
            ind = [NSIndexPath indexPathForRow:i inSection:1];
            [self.dataTable deselectRowAtIndexPath:ind animated:YES];
            
        }
        sender.tag = 1;
        [sender setTitle:@"Select All" forState:UIControlStateNormal];
        self.downloadBtn.enabled = NO;
        [selectedIndexes removeAllObjects];
        //        self.deleteBtn.enabled = NO;
    }
    
    
    
    
}

- (IBAction)logOut:(id)sender {
    [[DBSession sharedSession] unlinkAll];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)downloadFiles:(id)sender {
    

    if (selectedIndexes.count) {
        for (DBMetadata *file in selectedIndexes) {
            NSString *localFilePath = [localPathDropbox stringByAppendingString:[NSString stringWithFormat:@"/%@", file.filename]];
//            if (![[NSFileManager defaultManager] fileExistsAtPath:localFilePath] && ![DELEGATE.directoryContent containsObject:file.filename]){
//                if (!DELEGATE.downloadingFilesDictionary.count) {
//                    [DELEGATE.downloadManager loadFileIntoDownloadingArray:file toDownloadIntoPath:localPathDropbox];
//                }
//                [DELEGATE.dropboxDownloadingArray addObject:file];
//                [DELEGATE.directoryContent addObject:file.filename];
//                [DELEGATE.downloadManager.fileSourceArray setValue:@"Dropbox" forKey:file.filename];
//            }
        }
    }
    UITabBarController* tabBarController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController ;
    [tabBarController setSelectedIndex:1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBMetadata *file = [metaDataArray objectAtIndex:indexPath.row];
    if (self.dataTable.isEditing) {
        [selectedIndexes removeObject:file];
        [self.selectDeselectBtn setTitle:@"Select All" forState:UIControlStateNormal];
        self.selectDeselectBtn.tag = 1;
        if (!selectedIndexes.count) {
            self.downloadBtn.enabled = NO;
        }
    }
    //    [self.selectDeselectBtn setTitle:@"Select All" forState:UIControlStateNormal];
    //    self.selectDeselectBtn.tag=1;
    //    [testArray removeObject:indexPath];
    //    if (!testArray.count) {
    //        self.deleteBtn.enabled = NO;
    //    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return NO;
    }else return YES;
}


#pragma mark -----

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
