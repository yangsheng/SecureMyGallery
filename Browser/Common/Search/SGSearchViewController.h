//
//  SGURLBarRecentsController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 03.07.12.
//  Copyright (c) 2012-2014 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGSearchDelegate <NSObject>

- (void)finishSearch:(NSString *)searchString title:(NSString *)title;
- (void)finishPageSearch:(NSString *)searchString;
- (NSString *)text;

@optional
- (void)userScrolledSuggestions;

@end

@interface SGSearchViewController : UITableViewController 

@property (nonatomic, weak) id<SGSearchDelegate> delegate;

- (void)filterResultsUsingString:(NSString *)filterString;
@end
