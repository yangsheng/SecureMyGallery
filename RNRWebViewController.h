//
//  RNRWebViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 3/14/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNRWebViewController : UIViewController{

    NSTimer *timer;
    UIImage *downloadImage;


}

@property (weak, nonatomic) IBOutlet UIWebView *simpleWebView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarF;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, strong) PGDataSource *pgDataSource;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopBtn;

-(void)saveImageFromWeb:(UIImage *)image toFilePath:(NSString *)folderName;

@end
