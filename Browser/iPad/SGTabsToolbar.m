//
//  SGTabTopView.m
//  SGTabs
//
//  Created by Asif Seraje on 07.06.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//


#import "SGTabsToolbar.h"
#import "SGTabDefines.h"
#import "SGAppDelegate.h"
#import "SGTabsViewController.h"
#import "SGSearchField.h"

#import "NJKWebViewProgressView.h"

@implementation SGTabsToolbar

- (instancetype)initWithFrame:(CGRect)frame browserDelegate:(SGBrowserViewController *)browser; {
    if (self = [super initWithFrame:frame browserDelegate:browser]) {
        [self updateInterface];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, UIColorFromHEX(0xA9A9A9).CGColor);
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(ctx);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat diff = 5.;
    CGFloat length = 40.;
    
    CGRect btnR = CGRectMake(diff, (self.bounds.size.height - length)/2, length, length);
    self.backButton.frame = btnR;
    
    btnR.origin.x += length + diff;
    self.forwardButton.frame = btnR;
    
    CGRect org = self.searchField.frame;
    org.size.width = self.bounds.size.width - (btnR.origin.x + 3*diff + 2*length);
    org.origin.x = btnR.origin.x + length + diff;
    org.origin.y = (self.bounds.size.height - org.size.height)/2;
    self.searchField.frame = org;
    
    btnR.origin.x = CGRectGetMaxX(org) + diff;
    self.menuButton.frame = btnR;
    
    CGRect b = self.bounds;
    self.progressView.frame = CGRectMake(0, b.size.height-2, b.size.width, 2);
}


- (void)updateInterface {
    [super updateInterface];
    
    if (![self.searchField isFirstResponder]) {
        self.searchField.text = [self.browser URL].absoluteString;
    }
    
    self.forwardButton.enabled = [self.browser canGoForward];
    self.backButton.enabled = [self.browser canGoBack];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self presentSearchController];
    //[textField selectAll:self];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [_popoverController dismissPopoverAnimated:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (searchText.length > 0 && !self.popoverController.isPopoverVisible) {
        [self.popoverController presentPopoverFromRect:[self bounds]
                                                inView:self
                              permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else if (searchText.length == 0 && self.popoverController.isPopoverVisible) {
        [self.popoverController dismissPopoverAnimated:YES];
    }
    
    // When the search string changes, filter the recents list accordingly.
    if (self.popoverController) {
        [self.searchController filterResultsUsingString:searchText];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // If the user finishes editing text in the search bar by, for example:
    // tapping away rather than selecting from the recents list, then just dismiss the popover
    [self dismissPresented];
    
    if ([self.browser respondsToSelector:@selector(URL)]) {
        self.searchField.text = [self.browser URL].absoluteString;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // When the search button is tapped, add the search term to recents and conduct the search.
    NSString *searchString = [textField text];
    [self finishSearch:searchString title:nil];
    return YES;
}

#pragma mark - UIPopoverControllerDelegate

- (void)presentSearchController; {
    if (!_popoverController) {// create the popover if not already open
        _popoverController = [[UIPopoverController alloc]
                              initWithContentViewController:self.searchController];
        _popoverController.delegate = self;
        
        // Ensure the popover is not dismissed if the user taps in the search bar.
        _popoverController.passthroughViews = @[self, self.searchField];
    }
}

- (void)presentMenuController:(UIViewController *)vc completion:(void(^)(void))completion; {
    _popoverController = [[UIPopoverController alloc] initWithContentViewController:vc];
    _popoverController.delegate = self;
    [_popoverController presentPopoverFromRect:self.menuButton.frame
                                        inView:self
                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                      animated:YES];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

- (void)dismissPresented; {
    [super dismissPresented];
    if (_popoverController) {
        [_popoverController dismissPopoverAnimated:YES];
        _popoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    // Remove focus from the search bar without committing the search.
    [self resignFirstResponder];
    _popoverController = nil;
}

@end
