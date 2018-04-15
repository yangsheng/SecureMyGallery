//
//  UploadListViewController.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/7/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "UploadListViewController.h"
#import "PGThumbsController.h"
#import "PGDataSource.h"
#import "UploadThumbsViewController.h"

@interface UploadListViewController ()
@property (nonatomic, strong) PGDataSource *dataSource;
@property (strong, nonatomic) IBOutlet UITableView *dataTable;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *infoToolbar;

//-(void) addNewFolder;
//-(void) refreshInfoLabel;
-(void) setScrollViewInset;
@end

@implementation UploadListViewController


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
    // Do any additional setup after loading the view from its nib.
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    
    //Scrollview setup
    //kch[self setScrollViewInset];
    [self.dataTable scrollRectToVisible: CGRectMake(0, 0, 0, 0) animated: TRUE];
    
    //Title
    self.navigationItem.title = @"Albums";
}




//-(void) addbtnclicked
//{
//    
//    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select  option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
//                            @"Add New Album",
//                            @"Edit Albums",
//                            @"More Apps",
//                            
//                            nil];
//    
//    
//    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[UIColor blackColor]];
//    
//    
//    popup.tag = 1;
//    [popup showInView:self.view];
//    
//    
//}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // [self refreshInfoLabel];
    return [self.dataSource numberOfFolders];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITableViewCell";
    
    //Get a working cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    //Label
    NSString *folderName = [self.dataSource folderNameForIndex: indexPath.row];
    cell.textLabel.text = folderName;
    
    //Sublabel
    NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder:folderName];
    int files = [self.dataSource numberOfFilesForDictionary:_dicItem];
    NSString *folderDetails = [self.dataSource getPhotosStringFromNumber: _dicItem];
    cell.detailTextLabel.text = folderDetails;
    
    //Disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //Left image
    if (files > 0) {
        NSString *thumbFilePath = [self.dataSource getThumbnail110PathForFilename: [self.dataSource fileNameForFolder: folderName Index: files-1]];
        cell.imageView.image = [UIImage imageWithContentsOfFile: thumbFilePath];
    } else {
        cell.imageView.image = [UIImage imageNamed: @"NoPhotos.png"];
    }
    
    
    
    
    //Return cell
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath: indexPath animated: TRUE];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DownloadedPhoto"];
    
    //Create controller
    UploadThumbsViewController *thumbs = [[UploadThumbsViewController alloc] initWithNibName: @"UploadThumbsViewController" bundle: nil];
    thumbs.folder = [self.dataSource folderNameForIndex: (int)indexPath.row];
    //NSLog(@"%@",thumbs.folder);
    //thumbs.dflag = 1;
    
    //Push on navigation
    [self presentViewController:thumbs animated:YES completion:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    //Refresh UI
    [self.tabBarController.tabBar setHidden:NO];
    [self.dataTable reloadData];
    
    //Refresh scrollview
    //kch [self setScrollViewInset];
}
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissFormViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
