//
//  PhotoGalleryViewController.h
//  PhotoGallery
//
//  Created by Asif Seraje on 1/12/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class PGAlbumsController;

//@protocol PGAlbumsControllerDelegate <NSObject>
//- (void) removeSubView:(PGAlbumsController *)pgaAlbumC;
//
//
//@end

@interface PGAlbumsController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

{

    NSString *renamestr;
    NSInteger * indexno;
   // __weak id<PGAlbumsControllerDelegate> deleGate;

}
//@property (weak, nonatomic) id<PGAlbumsControllerDelegate> deleGate;

-(void) switchToConfiguration;
-(void) switchToNormalMode;
-(void) switchToEditMode;

@end
