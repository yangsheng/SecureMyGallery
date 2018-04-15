//
//  ContentViewController.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/19/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "ContentViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ContentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *gdImageView;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [self.view bringSubviewToFront:self.gdImageView];
//    [self.gdImageView setImageWithURL:[NSURL URLWithString:@"https://drive.google.com/file/d/0B8n9s5_cuMm9blQ2UjZMNzZuR0k/view"]];
    
    self.gdImageView.image = self.image;

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
