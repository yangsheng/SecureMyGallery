//
//  IBURLSuggestionVC.h
//  iconsweb
//
//  Created by Asif Seraje on 5/30/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBURLSuggestionDelegate <NSObject>

- (void)suggestionDidSelectedURL:(NSString *)url withTitle:(NSString *)title;
- (void)suggestionViewDidWillBeginDragging;

@end

@interface IBURLSuggestionVC : UITableViewController
{
    NSMutableArray *suggestions;
    id<IBURLSuggestionDelegate> delegate;
}

@property (strong) NSMutableArray *suggestions;
@property (strong) id<IBURLSuggestionDelegate> delegate;

- (void)loadWithQuery:(NSString *)_query;
- (id)initWithFrame:(CGRect)frame;
@end
