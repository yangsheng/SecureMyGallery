//
//  MyViewController.h
//  MusicApp
//
//  Created by Asif Seraje on 1/18/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropboxViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DBRestClientDelegate>

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width andHeight:(float)i_height;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
