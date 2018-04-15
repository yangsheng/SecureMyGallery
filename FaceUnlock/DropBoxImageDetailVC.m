//
//  DropBoxImageDetailVC.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/20/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "DropBoxImageDetailVC.h"
#import "ContentViewController.h"

@interface DropBoxImageDetailVC (){

    ContentViewController *contentVC;
    int index;
}

@property (nonatomic,strong)UIPageViewController *pageVC;


@end

@implementation DropBoxImageDetailVC
@synthesize pageVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageVC.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-100);
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
    DBMetadata *metadata = [self.pageingCountArray objectAtIndex:vcIndex];

    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:metadata.filename];
    UIImage *img = [[UIImage alloc] init] ;
    img = [UIImage imageWithContentsOfFile:filePath];
    if (img) {
        contentVC.image = img;
    } else{
        UIImage *image = [UIImage imageNamed:@"NoPhotosBig"];
        contentVC.image = image;
    }
    
    
    contentVC.vcIndex = vcIndex;
    return contentVC;
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

- (IBAction)dismissViewController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
