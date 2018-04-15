//
//  MyViewController.h
//  MusicApp
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface CommonTableView : UIViewController<UITableViewDataSource, UITableViewDelegate, DBRestClientDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataFolderArray;
@property (nonatomic, strong) NSString *navTitle;
@property (strong, nonatomic) NSString *rootPath;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;



@end
