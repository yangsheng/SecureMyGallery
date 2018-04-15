//
//  RNRWebViewController.m
//  Foxbrowser
//
//  Created by Asif Seraje on 3/14/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "RNRWebViewController.h"
#import "PGDataSource.h"
#import "PGADownloadsController.h"
#import "SGAppDelegate.h"
#import "MBProgressHUD.h"

@interface RNRWebViewController ()<UISearchBarDelegate>{

    UILabel *lableCopy;
    MBProgressHUD *HUD;

}

@end

@implementation RNRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.hidden = YES;
    self.searchBarF.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    
    self.searchBarF.text = @"https://www.google.com";
   

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    singleTap.numberOfTapsRequired = 1;
    //singleTap.delegate = self;
    //[self.Webview addGestureRecognizer:singleTap];
    [self.simpleWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com"]]]];
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(loading:) userInfo:nil repeats:YES];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.5;
    longPress.cancelsTouchesInView = YES;
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    self.searchBarF.delegate=self;

    [self.simpleWebView addGestureRecognizer:longPress];
    
    
    
}




- (IBAction)slideToMainMenuAction:(id)sender {
    
    [DELEGATE.slideContainer toggleLeftSideMenuCompletion:nil];
    
}




-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    bool pageFlag = [userDefaults boolForKey:@"pageDirectionRTLFlag"];
    NSLog(@"pageFlag tapbtnRight %d", pageFlag);
    
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self.simpleWebView stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"urlToSave :%@",urlToSave);
    NSURL * imageURL = [NSURL URLWithString:urlToSave];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    
    
    
    if (image) {
        
        
        
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Save image"
                                                                preferredStyle:UIAlertControllerStyleActionSheet]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Save"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  
                                                                  
//                                                                  UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                                                                  
                                                                  [self saveImageURL:imageURL];


                                                                  NSLog(@"You pressed button one%@",imageURL);
                                                              }]; // 2
        
        UIAlertAction *thirdaction = [UIAlertAction actionWithTitle:@"Copy Image url"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  
                                                                  
                                                                  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                                  pasteboard.string = [NSString stringWithFormat:@"%@",imageURL];
                                                                  NSLog(@"You pressed button one%@",imageURL);
                                                                  [self showprogress:@"URL Copied"];
                                                                  

                                                                  
                                                              }]; // 2
        
        
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           NSLog(@"You pressed button two");
                                           
                                       }]; // 3
        alert.view.tintColor = [UIColor colorWithRed:(20/255.0) green:(26/255.0) blue:(32/255.0) alpha:1.0];

        
        [alert addAction:firstAction]; // 4
        [alert addAction:thirdaction]; // 4
        
        [alert addAction:secondAction]; // 5
        
        
        alert.view.tintColor = [UIColor colorWithRed:(20/255.0) green:(26/255.0) blue:(32/255.0) alpha:1.0];

        //        if (UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM())
        //        {
        //            [alert setModalPresentationStyle:UIModalPresentationPopover];
        //
        //            UIPopoverPresentationController *popPresenter = [alert
        //                                                             popoverPresentationController];
        //
        //            popPresenter.sourceView = tabsView;
        //            popPresenter.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-300, 30, 30);
        //
        //
        //            [self presentViewController:alert animated:YES completion:nil];
        //
        //
        //
        //        }
        //
        //        else
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert
                                                         popoverPresentationController];
        if (popPresenter)
        {
            popPresenter.sourceView = self.view;
            popPresenter.sourceRect = self.view.bounds;
            popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
            [alert.popoverPresentationController setPermittedArrowDirections:0];
        }
        alert.view.tintColor = [UIColor colorWithRed:(20/255.0) green:(26/255.0) blue:(32/255.0) alpha:1.0];

        [self presentViewController:alert animated:YES completion:nil]; // 6
        
        alert.view.tintColor = [UIColor colorWithRed:(20/255.0) green:(26/255.0) blue:(32/255.0) alpha:1.0];

        
        
        
    }
    else
    {
        
        
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed"
                                                                       message:@"This image is not permitted to save or tab the image again to full screen and press long to download."
                                                                preferredStyle:UIAlertControllerStyleActionSheet]; // 1
        
        
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                       {
                                           NSLog(@"You pressed button two");
                                           
                                           
                                       }]; // 3
        alert.view.tintColor = [UIColor colorWithRed:(20/255.0) green:(26/255.0) blue:(32/255.0) alpha:1.0];

        
        [alert addAction:secondAction]; // 5
        
        
        
        //        if (IS_IPAD)
        //        {
        //            [alert setModalPresentationStyle:UIModalPresentationPopover];
        //
        //            UIPopoverPresentationController *popPresenter = [alert
        //                                                             popoverPresentationController];
        //
        //            popPresenter.sourceView = tabsView;
        //            popPresenter.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-300, 30, 30);
        //
        //
        //            [self presentViewController:alert animated:YES completion:nil];
        //
        //
        //
        //        }
        //
        //        else
        
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert
                                                         popoverPresentationController];
        if (popPresenter)
        {
            popPresenter.sourceView = self.view;
            popPresenter.sourceRect = self.view.bounds;
            popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
            [alert.popoverPresentationController setPermittedArrowDirections:0];
        }
        
        [self presentViewController:alert animated:YES completion:nil]; // 6
        
        alert.view.tintColor = [UIColor colorWithRed:(20/255.0) green:(26/255.0) blue:(32/255.0) alpha:1.0];
  
    }
    
    
}

- (void) image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if (error) {
        NSLog(@"Some Error");
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked: (UISearchBar * )searchBar {
    NSString *searchString = self.searchBarF.text;
    NSString *searchUrl = [NSString stringWithFormat:@"http://www.google.com/search?q=%@",searchString];
    NSString* encodedUrl = [searchUrl stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    [self.simpleWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]]];
    
    NSLog(@"%@",self.searchBarF.text);
    [self.simpleWebView addSubview:self.indicator];
    
    
    [self.searchBarF resignFirstResponder];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(loading:) userInfo:nil repeats:YES];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    NSLog(@"gestureRecognizer shouldReceiveTouch: tapCount = %d",(int)touch.tapCount);
    
    return YES;
}



#pragma mark-SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    self.searchBarF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //[self fixSearchBar:self.searchBarF];

    
}

-(void) loading:(id)sender {
    if (!self.simpleWebView.loading) {
        [self.indicator stopAnimating];
    }else{
        [self.indicator startAnimating];
    }
}
-(void)searchBarCancelButtonClicked: (UISearchBar * )searchBar {
    self.searchBarF.text = nil;
    [self.searchBarF resignFirstResponder];
    
}


- (void)saveImageURL:(NSURL *)url {
   
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            //            downloadImage = [UIImage imageWithData:data];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"imageData"];
        }
        
        //
        PGADownloadsController *pgDC2 = [[PGADownloadsController alloc]initWithNibName:@"PGADownloadsController" bundle:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SavePhoto"];
        
        [self presentViewController:pgDC2 animated:YES completion:nil];
        
        
        
    
}

-(void)saveImageFromWeb:(UIImage *)image toFilePath:(NSString *)folderName{
    
    
    self.pgDataSource = [[PGDataSource alloc]initWithCaller];
    
    //    [self.pgDataSource createFolderWithName:@"Downloads"];
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"imageData"];
    downloadImage = [UIImage imageWithData:data];
    
    NSLog(@"something %@",downloadImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    //    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
    //    [pngData writeToFile:filePath atomically:YES];
    NSString* fPath = [documentsPath stringByAppendingPathComponent:
                       @"test_110.jpg" ];
    
    NSLog(@"%@",fPath);
    
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *imageData = UIImageJPEGRepresentation(downloadImage, 1);
    //[fileManager createFileAtPath:path contents:imageData attributes:nil];
    [imageData writeToFile:fPath atomically:YES];
    
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
    [workingDictionary setObject:ALAssetTypePhoto forKey:@"UIImagePickerControllerMediaType"];
    [workingDictionary setObject:downloadImage forKey:@"UIImagePickerControllerOriginalImage"];
    [workingDictionary setObject:fPath forKey:@"UIImagePickerControllerReferenceURL"];
    
    [returnArray addObject:workingDictionary];
    
    [self.pgDataSource importArrayDictionary:returnArray ToFolder:folderName];
    
    [self showprogress:@"Saved to Downloads"];
  
    
}

- (void)              _image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo {
    if (error) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Submit", nil)
                                    message:NSLocalizedString(@"Error Retrieving Data", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    NSString* currentURL = self.simpleWebView.request.URL.absoluteString;
    NSString* mainDocumentURL = self.simpleWebView.request.mainDocumentURL.absoluteString;
    self.searchBarF.text = currentURL;
}


#pragma mark- placeholder alignment

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.searchBarF resignFirstResponder];
    //[self fixSearchBar:_searchBarF];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self fixSearchBar:self.searchBarF];
    
}






-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
   // [self fixSearchBar:self.searchBarF];
}

-(void)fixSearchBar:(UISearchBar*)searchBar
{
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    
    // [searchField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UILabel *lable=[searchField valueForKey:@"_placeholderLabel"];
    
    if(!lableCopy)
    {
        lableCopy=[[UILabel alloc]initWithFrame:lable.frame];
        lableCopy.font=lable.font;
        [lableCopy setText:@"Search"];//lable.text
        [lableCopy setTextColor:lable.textColor];
        UIButton *button;
        
        for (UIView *view in [[[[searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:1] subviews]) {
            if([view isKindOfClass:[UIButton class]])
            {
                button=(UIButton*)view;
                break;
            }
        }
        
        
        
        if(button)
        {
            //lable.hidden=YES;
            CGRect newFrame=lable.frame;
            newFrame.size.width=button.frame.origin.x-lable.frame.origin.x;
            lableCopy.frame=newFrame;
            [lableCopy adjustsFontSizeToFitWidth];
            //lableCopy.backgroundColor=[UIColor blackColor];
            [searchField addSubview:lableCopy];
            lableCopy.text=lable.text;
            //lableCopy.textColor=[UIColor redColor];
        }
        
    }
    for (UIView *view in [[searchBar.subviews objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[UITextField class]])
        {
            // NSLog(@"%@",view);
            NSLog(@"TextFieldPresent==>%@",view);
            if([view isFirstResponder])
            {
                lable.hidden=NO;
                lableCopy.hidden=YES;
            }
            else
            {
                lable.hidden=YES;
                lableCopy.hidden=NO;
            }
            break;
        }
    }
    
}

#pragma mark-progress

-(void) showprogress : (NSString *)title{
    
    HUD.labelText = nil;
    HUD=[[MBProgressHUD alloc] initWithView:DELEGATE.window];
    [DELEGATE.window addSubview:HUD];
    
    [HUD showWhileExecuting:@selector(myMixedTask2:) onTarget:self withObject:title animated:YES];
    title= @" ";
}



- (void)myMixedTask2 : (NSString *) title{
    
    sleep(.5);
    // UIImageView is a UIKit class, we have to initialize it on the main thread
    __block UIImageView *imageView;
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageNamed:@"Checkmark37"];
        imageView = [[UIImageView alloc] initWithImage:image];
    });
    HUD.customView = imageView;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = title;
    [HUD hide:YES afterDelay:3];
    
    sleep(1);
}



@end
