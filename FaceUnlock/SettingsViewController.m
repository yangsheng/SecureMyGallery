//
//  SettingsViewController.m
//  PhotoVault
//
//  Created by Asif Seraje on 12/13/15.
//
//

#import "SettingsViewController.h"
#import "MFSideMenu.h"
#import "SGAppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
#import "PGAlbumsController.h"
#import "UploadListViewController.h"
#import "MBProgressHUD.h"
#import "LockTypeSettingsVC.h"
#import "SettingTableViewCell.h"
#import "SettingTableViewCell2.h"
#import "SettingsTableViewCell3.h"
#import "KKPasscodeSettingsViewController.h"
#import "KKPasscodeLock.h"

NSString *scopes = @"https://www.googleapis.com/auth/drive.file";
NSString *keychainItemName = @"My A";
NSString *clientId = @"861941523810-lfd2q6ss0uni2a3gd5ve7rc45090u7ej.apps.googleusercontent.com";
NSString *clientSecret = @"ShJN0ZuUNUceWkWnOnDiRNvr";


#define APP_BG_COLOR [UIColor colorWithRed:20.0/255.0 green:26.0/255.0 blue:32.0/255.0 alpha:1.0]
#define CELL_SEP_COLOR [UIColor colorWithRed:32.0/255.0 green:39.0/255.0 blue:52.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:30.0/255.0 green:37.0/255.0 blue:45.0/255.0 alpha:1.0]
#define CELL_SEL_COLOR [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]


#define APP_KEY  @"5liyk6rqa99uvui"
#define APP_SECRET  @"0wllh2y0ikrsa6r"

@interface SettingsViewController ()<DBRestClientDelegate,UITableViewDataSource,UITableViewDelegate,KKPasscodeViewControllerDelegate>{
    int count;
    UIActivityIndicatorView *spinner;
    BOOL isAuthorized;
    BOOL fileFetchStatusFailure;
}
@property (nonatomic, strong)NSMutableArray *settingsMenuArray;

//@property (nonatomic, retain) GTLServiceDrive *driveService;
//@property (nonatomic, retain) GTMOAuth2Authentication *credentials;
@property (strong , nonatomic) DBRestClient *restClient;
@property (nonatomic) BOOL isLinked;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end


@implementation SettingsViewController

@synthesize restClient,isLinked;

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;

    self.extendedLayoutIncludesOpaqueBars = YES;

    self.settingsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    UIImage *customImage = [UIImage imageNamed:@"menu"];
    
    UIBarButtonItem *leftMenuBtn = [[UIBarButtonItem alloc]initWithImage:customImage style:UIBarButtonItemStylePlain target:self action:@selector(switchToSideMenu)];
    [self.navigationItem setLeftBarButtonItem:leftMenuBtn];
    self.navigationItem.title = @"Settings";
    


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentVC:) name:@"presentVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImage:) name:@"uploadImage" object:nil];
    self.settingsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//    [self.settingsTableView setSeparatorColor:[UIColor colorWithRed:(157/256) green:(157/256) blue:(157/256) alpha:1.0]];
    [self.settingsTableView setBackgroundView:nil];
    [self.settingsTableView setBackgroundColor:[UIColor clearColor]];
    self.settingsMenuArray = [[NSMutableArray alloc]init];
    
    NSArray *menuInFirstSection = @[@"Lock enable"];
    NSDictionary *firstSectionDict = @{@"menuList" : menuInFirstSection};
    
//    NSArray *menuInSecondSection = @[@"Home page",@"Search engine"];
//    NSDictionary *secondSectionDict = @{@"menuList" : menuInSecondSection};
    
    NSArray *menuInThirdSection = @[@"Rate us",@"Same Feedback",@"Our More Apps",@"Buttons"];
    NSDictionary *thirdSectionDict = @{@"menuList" : menuInThirdSection};
    
    //CGFloat height = self.settingsTableView.contentSize.height;

    //self.settingsTableView.frame = CGRectMake(0,64,self.view.frame.size.width,self.view.frame.size.width+300);
    self.settingsTableView.bounces = YES;
    
    [self.settingsMenuArray addObject:firstSectionDict];
    //[self.settingsMenuArray addObject:secondSectionDict];
    [self.settingsMenuArray addObject:thirdSectionDict];
    

    [self.settingsTableView setContentInset:UIEdgeInsetsMake(0, 0, 160, 0)];



}

-(void)viewWillAppear:(BOOL)animated{

    [self.settingsTableView reloadData];
}

-(void)switchToSideMenu{

    [DELEGATE.slideContainer toggleLeftSideMenuCompletion:nil];
}

- (IBAction)uploadImageToDropBox:(id)sender{

    [self didPressLink];
    
}


-(void)didPressLink
{
    if (![[DBSession sharedSession] isLinked]){
        [[DBSession sharedSession] linkFromController:self];
    }else{

        [self presentVC:nil];
    }
}

-(void)presentVC : (NSNotification *) info{
    NSLog(@"%@",info.object);
    


    UploadListViewController *uploadVC = [[UploadListViewController alloc]initWithNibName:@"UploadListViewController" bundle:nil];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fromPresentedVC"];
    [self presentViewController:uploadVC animated:YES completion:nil];
    
    

}





-(void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath
{
    //destPath is a path at which place your file is uploaded.
    //srcPath is a path from which place your file is uploaded.
    [spinner stopAnimating];
    NSLog(@"stopped spinning");
}



-(void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
    count--;

    NSLog(@"File upload failed with error: %@", error);
}





#pragma mark-UITableView Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.settingsMenuArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *dictionary = self.settingsMenuArray[section];
    NSArray *array = dictionary[@"menuList"];
    return [array count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

       if (indexPath.section == 0) {
       
           static NSString *cellIdentifier = @"SimpleTableCell";
           
           SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
           if (cell == nil)
           {
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil];
               cell = [nib objectAtIndex:0];
           }
           
           
               cell.lockSwitch.hidden = NO;
               
               [cell.lockSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];


               if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
                   [cell.lockSwitch setOn:YES];
               } else {
                   [cell.lockSwitch setOn:NO];
               }
               NSDictionary *dictionary = self.settingsMenuArray[indexPath.section];
               NSArray *array = dictionary[@"menuList"];
               NSString *cellvalue = array[indexPath.row];
               cell.backgroundColor = [UIColor clearColor];
               cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
               cell.iconImageView.image = [UIImage imageNamed:@"lock"];
               cell.titleLabel.text = cellvalue;
               cell.separetorLabelFull.hidden = YES;
               cell.separetorLabelSemi.hidden = YES;

               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               return  cell;

    }
    
  
    else{
    
        if (indexPath.row == 0) {
            static NSString *cellIdentifier = @"SimpleTableCell";
            
            SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.lockSwitch.hidden = YES;
            NSDictionary *dictionary = self.settingsMenuArray[indexPath.section];
            NSArray *array = dictionary[@"menuList"];
            NSString *cellvalue = array[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];

            //cell.titleLabel.textColor = [UIColor colorWithRed:(156/256) green:(156/256) blue:(156/256) alpha:(1.0)];
            //cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];
            cell.iconImageView.image = [UIImage imageNamed:@"rate-us"];
            //cell.iconImageView.highlightedImage = [UIImage imageNamed:@"rate-us_select"];
            cell.titleLabel.text = cellvalue;
            cell.separetorLabelFull.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = CELL_SEL_COLOR;
            [cell setSelectedBackgroundView:bgColorView];
            return  cell;
        }
        else if(indexPath.row == 1){
        
            static NSString *cellIdentifier = @"SimpleTableCell";
            
            SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.lockSwitch.hidden = YES;
            NSDictionary *dictionary = self.settingsMenuArray[indexPath.section];
            NSArray *array = dictionary[@"menuList"];
            NSString *cellvalue = array[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];

            //cell.titleLabel.textColor = [UIColor colorWithRed:(156/256) green:(156/256) blue:(156/256) alpha:(1.0)];
            //cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];

            cell.iconImageView.image = [UIImage imageNamed:@"feedback"];
            //cell.iconImageView.highlightedImage = [UIImage imageNamed:@"feedback_select"];

            cell.titleLabel.text = cellvalue;
            cell.separetorLabelFull.hidden = YES;
            cell.separetorLabelSemi.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = CELL_SEL_COLOR;
            [cell setSelectedBackgroundView:bgColorView];
            return  cell;
        }
        else if(indexPath.row == 2){
            
            static NSString *cellIdentifier = @"SimpleTableCell";
            
            SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.lockSwitch.hidden = YES;
            NSDictionary *dictionary = self.settingsMenuArray[indexPath.section];
            NSArray *array = dictionary[@"menuList"];
            NSString *cellvalue = array[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
            
            //cell.titleLabel.textColor = [UIColor colorWithRed:(156/256) green:(156/256) blue:(156/256) alpha:(1.0)];
            //cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];
            
            cell.iconImageView.image = [UIImage imageNamed:@"our_more_apps"];
            //cell.iconImageView.highlightedImage = [UIImage imageNamed:@"our_more_apps_selected"];
            
            cell.titleLabel.text = cellvalue;
            cell.separetorLabelFull.hidden = YES;
            cell.separetorLabelSemi.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = CELL_SEL_COLOR;
            [cell setSelectedBackgroundView:bgColorView];
            return  cell;
        }
        else{
        
            static NSString *cellIdentifier = @"SimpleTableCell";
            
            SettingsTableViewCell3 *cell = (SettingsTableViewCell3 *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsTableViewCell3" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell.conectInstagram setImage:[UIImage imageNamed:@"instagram"] forState:UIControlStateNormal];
            [cell.connectFB setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
            [cell.connectTwitter setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];

            
            
            return  cell;

        }
    }
   
   
    
}

- (void)changeSwitch:(id)sender{
    
    if ([sender isOn]) {
        KKPasscodeSettingsViewController *vc = [[KKPasscodeSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        KKPasscodeSettingsViewController *vc = [[KKPasscodeSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didSettingsChanged:(KKPasscodeViewController*)viewController{

    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"lockSwitch"]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"lockSwitch"];
    }else{
    
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"lockSwitch"];

    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 55)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, tableView.frame.size.width, 20)];
    [label setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16]];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textColor = [UIColor colorWithRed:(110/256.0) green:(110/256.0) blue:(112/256.0) alpha:(1.0)];

    /* Section header is in 0th index... */
    //[label setText:@"Header"];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]]; //your background color...
    UIView *lineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 45, tableView.frame.size.width, 1)] ;
    lineViewBottom.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
    UIView *lineViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)] ;
    lineViewTop.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
    [view addSubview:lineViewBottom];
    [view addSubview:lineViewTop];

    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  45.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        NSString *header = @"PRIVACY SETTINGS";
        
        return header;
    }
    else{
    
        NSString *header = @"GENERAL SETTINGS";
        return header;
    }
    
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if ((indexPath.section == 0)&& (indexPath.row == 1)) {
        LockTypeSettingsVC *lockTypeVC = [[LockTypeSettingsVC alloc]initWithNibName:@"LockTypeSettingsVC" bundle:nil];
        [self.navigationController pushViewController:lockTypeVC animated:YES];
    }

}


@end
