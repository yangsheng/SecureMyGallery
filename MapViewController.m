//
//  MapViewController.m
//  Foxbrowser
//
//  Created by Asif Seraje on 1/12/18.
//  Copyright © 2018 Asif Seraje. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txt1.delegate=self;
    self.txt2.delegate=self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonDonePressed:(id)sender {
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.txt1 resignFirstResponder];
    [self.txt2 resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.txt1 resignFirstResponder];
    [self.txt2 resignFirstResponder];
    return NO;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return (newLength > 999) ? NO : YES;
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
