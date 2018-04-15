//
//  SGAddiconViewController.m
//  Foxbrowser
//
//  Created by Asif Seraje on 9/7/15.
//  Copyright (c) 2015 Asif Seraje. All rights reserved.
//

#import "SGAddiconViewController.h"
#import "IBMainVC.h"
#import "ImageLoader.h"
#import "Helper.h"
#import "MD5.h"


#define ICON_TAG 1
#define WINDOW_WIDTH 320
#define NAV_HEIGHT 44
#define SITE_NAME_TAG 2


@interface SGAddiconViewController (){

    __weak IBOutlet UITextField *urlTxtField;
    
    __weak IBOutlet UITextField *nameTxtField;

    __weak IBOutlet UIImageView *defaultImage;
    __weak IBOutlet UIButton *addbtn;
    __weak IBOutlet UIButton *bckbtn;
}

@end

@implementation SGAddiconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addIcon"];

    urlTxtField.layer.cornerRadius = 10;
    urlTxtField.clipsToBounds = YES;
    urlTxtField.layer.borderWidth=1.0f;
    urlTxtField.layer.borderColor=[UIColor colorWithRed:(214/256.0) green:(214/256.0) blue:(214/256.0) alpha:1.0].CGColor;


    nameTxtField.layer.cornerRadius = 10;
    nameTxtField.clipsToBounds = YES;
    nameTxtField.layer.borderWidth=1.0f;
    nameTxtField.layer.borderColor=[UIColor colorWithRed:(214/256.0) green:(214/256.0) blue:(214/256.0) alpha:1.0].CGColor;

    
    addbtn.layer.cornerRadius = 10;
    addbtn.clipsToBounds = YES;
    addbtn.layer.borderColor=[UIColor colorWithRed:(214/256.0) green:(214/256.0) blue:(214/256.0) alpha:1.0].CGColor;
    addbtn.layer.borderWidth=1.0f;
    
    bckbtn.layer.cornerRadius = 10;
    bckbtn.clipsToBounds = YES;
    bckbtn.layer.borderColor=[UIColor colorWithRed:(214/256.0) green:(214/256.0) blue:(214/256.0) alpha:1.0].CGColor;
    bckbtn.layer.borderWidth=1.0f;
    urlTxtField.delegate=self;
    nameTxtField.delegate=self;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

    [self _layout];

}

- (void)_layout {

UIInterfaceOrientation toInterfaceOrientation = self.interfaceOrientation;
//    bool isIPhone = !([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);

if ( UIDeviceOrientationIsLandscape(toInterfaceOrientation))
{
    NSLog(@"left");
    //x,y as you want
    // [urlTxtField setFrame:CGRectMake:(50,30,100,44)];
    
    [UIView animateWithDuration:.3 animations:^{
        urlTxtField.frame=CGRectMake(178, 30, 213, 30);
        nameTxtField.frame=CGRectMake(219, 82, 130, 30);
        
        defaultImage.frame=CGRectMake(129, 136, 85, 90);
        
        addbtn.frame=CGRectMake(261, 166, 46, 30);
        bckbtn.frame=CGRectMake(261, 212, 46, 30);

    }];
   

}
else
{
    //In potrait
    //x,y as you want
    // [ button setFrame:CGRectMake:(x,y,button.width,button.height)];
    [UIView animateWithDuration:.3 animations:^{
//        urlTxtField.frame=CGRectMake(65, 96, 213, 30);
//        nameTxtField.frame=CGRectMake(106, 164, 130, 30);
//        defaultImage.frame=CGRectMake(34, 239, 85, 90);
//        addbtn.frame=CGRectMake(148, 299, 46, 30);
//        bckbtn.frame=CGRectMake(148, 365, 46, 30);
    }];
    
    
}
}


- (BOOL)shouldAutorotate {
    return self.presentedViewController ? [self.presentedViewController shouldAutorotate] : YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self _layout];
}


- (IBAction)addIconbtnAction:(id)sender {
    
   
    NSDate *date = [NSDate date];
    
    NSDateFormatter* format=[[NSDateFormatter alloc] init];
    format.dateFormat=@"yyyyMMddhhmmss";
    
//    NSLog(@"%@",[format stringFromDate:date]);
    
    NSString *filePath = [Helper getFilePathWithFilename:[NSString stringWithFormat:@"%@.png", [format stringFromDate:date]]];
    
//    NSLog(@"%@",[filePath lastPathComponent]);

    NSString* url;
    
    if ([urlTxtField.text rangeOfString:@"http://"].location == NSNotFound) {
        url=[NSString stringWithFormat:@"http://%@", urlTxtField.text];
    } else {
        url=[NSString stringWithFormat:@"%@", urlTxtField.text];
    }
   
    
    [UIImagePNGRepresentation(defaultImage.image) writeToFile:filePath atomically:YES];
    
    NSMutableDictionary *siteInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:[filePath lastPathComponent], @"icon", nameTxtField.text, @"name",url , @"url", nil];
    
    
    IBMainVC *mainvc=[[IBMainVC alloc] init];
    [mainvc siteIconAdded:siteInfo];
    
    [self performSelector:@selector(saveMessage) withObject:nil afterDelay:1];

}

-(void)saveMessage{

    [[[UIAlertView alloc] initWithTitle:@"" message:@"Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}


- (void)iconLoaded:(NSString *)iconFilePath
{
    
}





- (IBAction)backbtnAction:(id)sender {
    
    [self.presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;

}


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
