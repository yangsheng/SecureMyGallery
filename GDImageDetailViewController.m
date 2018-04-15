//
//  GDImageDetailViewController.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "GDImageDetailViewController.h"
#import "ContentViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "GTLDrive.h"

@interface GDImageDetailViewController (){

    ContentViewController *contentVC;
    int index;

}
@property (nonatomic,strong)UIPageViewController *pageVC;

@end

@implementation GDImageDetailViewController

@synthesize  pageVC;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    pageVC = [[UIPageViewController alloc] init];
    pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageVC.view.frame = CGRectMake(0,70, self.view.frame.size.width, self.view.frame.size.height-100);
    pageVC.dataSource = self;
    pageVC.delegate = self;
//    pageVC.view.userInteractionEnabled = YES;
    
    ContentViewController *startingViewController;

    startingViewController = [self viewControllerAtIndex:(int)self.cellIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:startingViewController];
    [pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageVC];
    [self.view addSubview:pageVC.view];
    [pageVC didMoveToParentViewController:self];
    [[self.view superview] insertSubview:pageVC.view belowSubview:self.view];

    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;{
    
    ContentViewController *currentView = (ContentViewController*) viewController;
    int i = (int)currentView.vcIndex;
    if (i == 0) {
        return nil;
    }
    
    i--;
    return [self viewControllerAtIndex:i];

}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;{
    ContentViewController *currentView = (ContentViewController*) viewController;
    int i = (int)currentView.vcIndex;
    i++;
    if (i == [self.pageingCountArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:i];

}

- (ContentViewController *)viewControllerAtIndex:(int)vcIndex
{
    if (([self.pageingCountArray count] == 0) || (vcIndex >= [self.pageingCountArray count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    contentVC = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    GTLDriveFile *file = [self.pageingCountArray objectAtIndex:vcIndex];

    //total image item
    //MPMediaItem *item = [DELEGATE.sList objectAtIndex:vcIndex];
    
    NSLog(@"selflink testing == %@",file.thumbnailLink);
//    NSURL *url = [NSURL URLWithString:@"https://drive.google.com/file/d/0B8n9s5_cuMm9blQ2UjZMNzZuR0k/view"];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:file.thumbnailLink]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] init] ;//= [[UIImage alloc] initWithData:data];
    img = [UIImage imageWithData:imageData];
    if (img) {
        contentVC.image = img;
    } else{
        UIImage *image = [UIImage imageNamed:@"NoPhotosBig"];
        contentVC.image = image;
    }
    
//    NSString *tempUrl = [self.pageingCountArray objectAtIndex:vcIndex];
//    contentVC.urlString = file.alternateLink;
    contentVC.vcIndex = vcIndex;
    return contentVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (finished) {
        ContentViewController *currentView = [pageVC.viewControllers objectAtIndex:0];
        if (index == currentView.vcIndex) {
            return;
        }
        
        index = currentView.vcIndex;
        
    }
}



- (IBAction)dismissViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
