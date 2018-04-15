//
//  SlideViewController.m
//  You tube app
//
//  Created by Asif Seraje on 6/8/15.
//  Copyright (c) 2015 Dhiman Das. All rights reserved.
//

#import "SlideViewController.h"
#import "SGAppDelegate.h"
//#import <XplodeSDK/XplodeSDK.h>
#import "ContactViewController.h"
#import "PGADownloadsController.h"
#import "SettingsViewController.h"
#import "SideViewCell.h"
#import "KKPasscodeLock.h"

#define CELL_TITLE_COLOR [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0]
#define CELL_TITLE_COLOR_SEL [UIColor colorWithRed:(248/255.0) green:(53/255.0) blue:(52/255.0) alpha:1.0]
#define BG_COLOR [UIColor colorWithRed:(31/255.0) green:(37/255.0) blue:(47/255.0) alpha:1.0]
#define CELL_SEL_COLOR [UIColor colorWithRed:(22/255.0) green:(29/255.0) blue:(35/255.0) alpha:1.0]
#define SECTION_BREAK_COLOR [UIColor colorWithRed:(20/255.0) green:(26/255.0) blue:(35/255.0) alpha:1.0]
#define CELL_SEPARETOR [UIColor colorWithRed:(58/255.0) green:(72/255.0) blue:(88/255.0) alpha:1.0]






@interface SlideViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UINavigationController *nav;
    UINavigationController *nav2;
    NSArray *menuInFirstSection;

}

@property (nonatomic, strong)NSMutableArray *sideBarMenu;
@end

@implementation SlideViewController
@synthesize noteNav;
@synthesize albumNav;
@synthesize contactNav;
@synthesize passNav;
@synthesize downloadNav;

+ (SlideViewController *)instance{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [[SlideViewController alloc]initWithNibName:@"SlideViewController_iPad" bundle:nil];
    
                }
                
    else
    return [[SlideViewController alloc]initWithNibName:@"SlideViewController" bundle:nil];
}
//Users/TwinbitMac1/Desktop/Twinbit/youtubelatest/You tube app/common.h
- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.sliderTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.view.backgroundColor = BG_COLOR;
    [self.sliderTableView setSeparatorColor:CELL_SEPARETOR];
//    [self.sliderTableView setBackgroundView:nil];
    [self.sliderTableView setBackgroundColor:BG_COLOR];
    
    self.sideBarMenu = [[NSMutableArray alloc] init];
    
    menuInFirstSection = @[@"Album",@"Note",@"Contact",@"Password",@"Settings"];
    //NSDictionary *firstSectionDict = @{@"menuList" : menuInFirstSection};
//    NSArray *menuInSecondSection = @[];
//    NSDictionary *secondSectionDict = @{@"menuList" : menuInSecondSection};
   
    
   // [self.sideBarMenu addObject:firstSectionDict];
    //[self.sideBarMenu addObject:secondSectionDict];

}




//-(IBAction)switchToConfiguration
//{
//   
//}


- (IBAction)instagrame:(id)sender
{

    
    PasswordViewController *passwordVC =[[PasswordViewController alloc]initWithNibName:@"PasswordViewController" bundle:nil];
    passNav = [[UINavigationController alloc]initWithRootViewController:passwordVC];
    passNav.tabBarItem.title=@"PassWord";
    NSLog(@"%@",DELEGATE.localViewControllersArray);
    
    [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:passNav];
    //[DELEGATE.localViewControllersArray insertObject:noteNav atIndex:1];
    
    // NSLog(@"%@",DELEGATE.localViewControllersArray);
    
    
    //[DELEGATE.window setRootViewController:DELEGATE.tabBarController];
    
    DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;
    
    
    //    NSArray *controllers = [NSArray arrayWithObject:noteNav];
    //navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
    
//    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=twinbitlimited"];
//    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//        [[UIApplication sharedApplication] openURL:instagramURL];
//    }
}
- (IBAction)rate_us:(id)sender

{
    
//UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NotesViewController *notesViewCtrlr =[[NotesViewController alloc]initWithNibName:@"NotesViewController" bundle:nil];
    noteNav = [[UINavigationController alloc]initWithRootViewController:notesViewCtrlr];
    noteNav.tabBarItem.title=@"Notes";
     NSLog(@"%@",DELEGATE.localViewControllersArray);
    
    [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:noteNav];
    //[DELEGATE.localViewControllersArray insertObject:noteNav atIndex:1];
    
    NSLog(@"%@",DELEGATE.localViewControllersArray);
    
    
    //[DELEGATE.window setRootViewController:DELEGATE.tabBarController];
    
    DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;

    
   // NSArray *controllers = [NSArray arrayWithObject:noteNav];
   //navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    

    
    
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1028913316&pageNumber=0&sortOrdering=2&mt=8"]];
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    
//    [prefs setBool:YES forKey:@"israte"];
    
    
}

- (IBAction)contact_us:(id)sender
{
    
    ContactListViewController *contactListVC =[[ContactListViewController alloc]initWithNibName:@"ContactListViewController" bundle:nil];
    contactNav = [[UINavigationController alloc]initWithRootViewController:contactListVC];
    contactNav.tabBarItem.title=@"Contact";
    NSLog(@"%@",DELEGATE.localViewControllersArray);
    
    [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:contactNav];
    //[DELEGATE.localViewControllersArray insertObject:noteNav atIndex:1];
    
   // NSLog(@"%@",DELEGATE.localViewControllersArray);
    
    
    //[DELEGATE.window setRootViewController:DELEGATE.tabBarController];
    
    DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;
    
    
//    NSArray *controllers = [NSArray arrayWithObject:noteNav];
    //navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
    


//    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
//    controller.mailComposeDelegate = self;
//    NSArray *toRecipients = [NSArray arrayWithObjects:@"contact@twinbit.net",nil];
//    
//    [controller setToRecipients:toRecipients];
//    [controller setSubject:@"MusicalSave Feedback!"];
//    [controller setMessageBody:@"" isHTML:NO];
//    if (controller)
//        [self.navigationController presentViewController:controller animated:YES completion:nil];
    


}

- (IBAction)tellafriend:(id)sender {
    
  
    SettingsViewController *settingsVC =[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
    downloadNav = [[UINavigationController alloc]initWithRootViewController:settingsVC];
    downloadNav.tabBarItem.title=@"Settings";
    NSLog(@"%@",DELEGATE.localViewControllersArray);
    
    [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:downloadNav];
    //[DELEGATE.localViewControllersArray insertObject:noteNav atIndex:1];
    
   // NSLog(@"%@",DELEGATE.localViewControllersArray);
    
    
    //[DELEGATE.window setRootViewController:DELEGATE.tabBarController];
    
    DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;
    
    
    //NSArray *controllers = [NSArray arrayWithObject:albumNav];
    //navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    

    
    
//
//    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
//    controller.mailComposeDelegate = self;
//    [controller setSubject:@"Save Musical.ly Videos!"];
//    [controller setMessageBody:@"Watch & download all the funniest Musical.ly video feeds with this awesome iOS app for FREE! Get the app on this link: https://goo.gl/uiowK4" isHTML:NO];
//    if (controller)
//    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
    
    
    
}



//- (void)mailComposeController:(MFMailComposeViewController*)controller
//          didFinishWithResult:(MFMailComposeResult)result
//                        error:(NSError*)error;
//{
//    if (result == MFMailComposeResultSent) {
//        NSLog(@"It's away!");
//    }
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//}


-(void)anmation:(NSString*)labelstring{
    
    
    self.downlodpopuoview.hidden=NO;
    self.downloadlabel.text=labelstring;
    self.downlodpopuoview.frame = CGRectMake(0, -64, self.downlodpopuoview.frame.size.width, self.downlodpopuoview.frame.size.height);
    [UIView animateWithDuration:1.1f
                          delay:0.0
         usingSpringWithDamping:2
          initialSpringVelocity:2
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.downlodpopuoview.frame = CGRectMake(0, 0, self.downlodpopuoview.frame.size.width, self.downlodpopuoview.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                         
                         [self.view addSubview:self.downlodpopuoview];
                         
                         
                         //dettableview.hidden=NO;
                         
                         self.downlodpopuoview.frame = CGRectMake(0, 0, self.downlodpopuoview.frame.size.width, self.downlodpopuoview.frame.size.height);
                         [UIView animateWithDuration:3.0f
                                               delay:0.0
                              usingSpringWithDamping:2.0
                               initialSpringVelocity:2.0
                                             options: UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.downlodpopuoview.frame = CGRectMake(0, -64, self.downlodpopuoview.frame.size.width, self.downlodpopuoview.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              self.downlodpopuoview.hidden=YES;
                                              self.downloadlabel.text=@"";
                                              
                                          }];
                         
                         
                         
                     }];
    
    
    
    
    
    
    
    
}

- (IBAction)setupe:(id)sender
    {
    
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey: @"touch_btn"];
//
//        //Configuration wizard
//        WizardPatternController *wizard = [[WizardPatternController alloc] initWithNibName: @"WizardPatternController" bundle: nil];
//        wizard.currentState = PATTERN_STATE_DEFINE;
//        
//        //Create navigation controller
        
       /* PGAlbumsController *pg =[[PGAlbumsController alloc]initWithNibName:@"PGAlbumsController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: pg];
        NSArray *controllers = [NSArray arrayWithObject:pg];
        navController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];*/
        
        PGAlbumsController *pg =[[PGAlbumsController alloc]initWithNibName:@"PGAlbumsController" bundle:nil];
        albumNav = [[UINavigationController alloc]initWithRootViewController:pg];
        albumNav.tabBarItem.title=@"Album";
        NSLog(@"%@",DELEGATE.localViewControllersArray);
        
        [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:albumNav];
        //[DELEGATE.localViewControllersArray insertObject:noteNav atIndex:1];
        
        NSLog(@"%@",DELEGATE.localViewControllersArray);
        
        
        //[DELEGATE.window setRootViewController:DELEGATE.tabBarController];
        
        DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;
        
        
        //NSArray *controllers = [NSArray arrayWithObject:albumNav];
        //navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];


//        navController.navigationBar.barStyle = UIBarStyleDefault;
//        //navController.navigationBar.translucent = true;
//        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        
//        //Present modal controller
//        [self presentViewController:navController animated:true completion:nil];
//        //Release controllers

        
        
      
    
    
    }


//- (IBAction)clearcache:(id)sender {
//    
//    
//    [Xplode presentPromotionForBreakpoint:@"launch_time"
//                    withCompletionHandler:nil
//                        andDismissHandler:nil];
//    
//    
//
//    
//    
//}



//- (IBAction)searchBtnAct:(id)sender {
//    
//    if(IS_IPAD){
//        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//        NSArray *controllers = [NSArray arrayWithObject:[SearchBarController instance]];
//        navigationController.viewControllers = controllers;
//        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//    }
//    else{
//    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//    NSArray *controllers = [NSArray arrayWithObject:[SearchBarController instance]];
//    navigationController.viewControllers = controllers;
//    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//    }
//}
//- (IBAction)playListBtnAct:(id)sender {
//    
//    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//    NSArray *controllers = [NSArray arrayWithObject:[PlayListViewController instance]];
//    navigationController.viewControllers = controllers;
//    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//}
//
//- (IBAction)historyBtnAct:(id)sender {
//    
//    if(IS_IPAD){
//        
//        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//        NSArray *controllers = [NSArray arrayWithObject:[[HistoryViewController alloc] initWithNibName:@"HistoryViewController_iPad" bundle:nil]];
//        navigationController.viewControllers = controllers;
//        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//        
//        
//    }
//    else{
//        
//        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//        NSArray *controllers = [NSArray arrayWithObject:[HistoryViewController instance]];
//        navigationController.viewControllers = controllers;
//        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//        
//
//        
//    }
//    
//}
//
//- (IBAction)settingsBtnAct:(id)sender {
//    
//    
//    if(IS_IPAD){
//        
//        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//        NSArray *controllers = [NSArray arrayWithObject:[[SettingsViewContoller alloc] initWithNibName:@"SettingsViewContoller_iPad" bundle:nil]];
//        navigationController.viewControllers = controllers;
//        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//        
//
//        
//    }
//    else{
//        
//        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//        NSArray *controllers = [NSArray arrayWithObject:[SettingsViewContoller instance]];
//        navigationController.viewControllers = controllers;
//        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//
//        
//    }
//    
//    
//    
//}
//- (IBAction)removeAdsBtnAct:(id)sender {
//    
//    
//}
//
//
//- (IBAction)bookmarkbutton:(id)sender {
//    
//    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//    NSArray *controllers = [NSArray arrayWithObject:[BookmarkViewController instance]];
//    navigationController.viewControllers = controllers;
//    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//    
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

#pragma mark-UITableView Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    //return [self.sideBarMenu count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    NSDictionary *dictionary = self.sideBarMenu[section];
//    NSArray *array = dictionary[@"menuList"];
    return [menuInFirstSection count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    static NSString *cellIdentifier = @"SimpleTableCell";
    
    SideViewCell *cell = (SideViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    NSDictionary *dictionary = self.sideBarMenu[indexPath.section];
//    NSArray *array = dictionary[@"menuList"];
    NSString *cellvalue = menuInFirstSection[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    cell.titleLabel.textColor = CELL_TITLE_COLOR;
    cell.titleLabel.text = cellvalue;
    //cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];
    
    if ([cellvalue isEqualToString:@"Album"]) {
        cell.iconImageView.image = [UIImage imageNamed:@"SideBarAlbumIcon"];
        //cell.iconImageView.highlightedImage = [UIImage imageNamed:@"SideBarSelectedAlbum"];
    }
    else if ([cellvalue isEqualToString:@"File"]){
        cell.iconImageView.image = [UIImage imageNamed:@"SideBarFileIcon"];
        //cell.iconImageView.highlightedImage = [UIImage imageNamed:@"SideBarSelectedfile"];
        
    }
    else if ([cellvalue isEqualToString:@"Note"]){
    
        cell.iconImageView.image = [UIImage imageNamed:@"SideBarNoteIcon"];
        //cell.iconImageView.highlightedImage = [UIImage imageNamed:@"SideBarSelectedNote"];

    }
    else if ([cellvalue isEqualToString:@"Contact"]){
    
        cell.iconImageView.image = [UIImage imageNamed:@"SideBarContactIcon"];
        //cell.iconImageView.highlightedImage = [UIImage imageNamed:@"SideBarSelectedContact"];

    }
    else if ([cellvalue isEqualToString:@"Password"]){
        
        cell.iconImageView.image = [UIImage imageNamed:@"SideBarPasswordIcon"];
        //cell.iconImageView.highlightedImage = [UIImage imageNamed:@"SideBarSelectedPass"];

    }
    else if([cellvalue isEqualToString:@"Settings"]){
    
        cell.iconImageView.image = [UIImage imageNamed:@"SideBarSettingIcon"];
       // cell.iconImageView.highlightedImage = [UIImage imageNamed:@"SideBarSelectedSetting"];


    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = SECTION_BREAK_COLOR;
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//
////     UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, 150)];
////    if (section==0) {
////       
////        footerView.backgroundColor = SECTION_BREAK_COLOR;
////        return footerView;
////    }
////    else
////        return footerView;
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return  40.0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        int cellNumber = (int)indexPath.row;
        PGAlbumsController *pg =[[PGAlbumsController alloc]initWithNibName:@"PGAlbumsController" bundle:nil];
        NotesViewController *notesViewCtrlr =[[NotesViewController alloc]initWithNibName:@"NotesViewController" bundle:nil];
        ContactListViewController *contactListVC =[[ContactListViewController alloc]initWithNibName:@"ContactListViewController" bundle:nil];
        PasswordViewController *passwordVC =[[PasswordViewController alloc]initWithNibName:@"PasswordViewController" bundle:nil];

        SettingsViewController *settingsVC =[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
        
        switch (cellNumber) {
            case 0:
                albumNav = [[UINavigationController alloc]initWithRootViewController:pg];
                albumNav.tabBarItem.title=@"Album";
                albumNav.tabBarItem.image = [UIImage imageNamed:@"album"];
                albumNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"album_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                NSLog(@"%@",DELEGATE.localViewControllersArray);
                
                [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:albumNav];
                NSLog(@"%@",DELEGATE.localViewControllersArray);

                DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;

                
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                break;
                
            case 1:
                
                noteNav = [[UINavigationController alloc]initWithRootViewController:notesViewCtrlr];
                noteNav.tabBarItem.title=@"Notes";
                noteNav.tabBarItem.image = [UIImage imageNamed:@"tabBarNoteIcon"];
                noteNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbarNoteSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:noteNav];
                
                DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;
                
               
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

                break;
            case 2:
                contactNav = [[UINavigationController alloc]initWithRootViewController:contactListVC];
                contactNav.tabBarItem.title=@"Contact";
                contactNav.tabBarItem.image = [UIImage imageNamed:@"tabBarContact"];
                contactNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbarContactSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:contactNav];
                
                
                DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;
                
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                
                break;
            case 3:
                passNav = [[UINavigationController alloc]initWithRootViewController:passwordVC];
                passNav.tabBarItem.title=@"PassWord";
                passNav.tabBarItem.image = [UIImage imageNamed:@"tabBarPassWordIcon"];
                passNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbarPasswordSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                NSLog(@"%@",DELEGATE.localViewControllersArray);
                
                [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:passNav];
                
                
                DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;
                
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                
                break;

            case 4:
                
                downloadNav = [[UINavigationController alloc]initWithRootViewController:settingsVC];
                downloadNav.tabBarItem.title=@"Settings";
                //NSLog(@"%@",DELEGATE.localViewControllersArray);
                downloadNav.tabBarItem.image = [UIImage imageNamed:@"tabBarSettingsIcon"];
                downloadNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbarSettingSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [DELEGATE.localViewControllersArray replaceObjectAtIndex:1 withObject:downloadNav];
                
                
                DELEGATE.tabBarController.viewControllers = DELEGATE.localViewControllersArray;
                
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                break;
            default:
                break;
        }
    }
    
    
    [DELEGATE.tabBarController setSelectedIndex:1];
    
    
}

@end
