//
//  GDImageDetailViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
///


@interface GDImageDetailViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@property (nonatomic, strong)NSString *downloadUrlString;
@property (nonatomic, strong)NSMutableArray *pageingCountArray;

@property (weak, nonatomic) IBOutlet UILabel *imageNumber;

@property (assign, nonatomic) NSInteger indexNumber;
@property (assign, nonatomic) NSInteger cellIndex;


- (IBAction)dismissViewController:(id)sender;

@end
