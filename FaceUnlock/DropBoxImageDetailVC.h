//
//  DropBoxImageDetailVC.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/20/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>


@interface DropBoxImageDetailVC : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic, strong)NSString *downloadUrlString;
@property (nonatomic, strong)NSMutableArray *pageingCountArray;
@property (assign, nonatomic) NSInteger indexNumber;
@property (assign, nonatomic) NSInteger cellIndex;

- (IBAction)dismissViewController:(id)sender;

@end
