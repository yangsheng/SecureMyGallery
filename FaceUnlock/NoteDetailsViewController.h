//
//  NoteDetailsViewController.h
//  PhotoVault
//
//  Created by Asif Seraje on 12/14/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface NoteDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *noteView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDate *creationTime;
@property (nonatomic, strong) NSString *msgBody;
//@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (nonatomic, strong) NSString *noteString;
@property  NSInteger pIndexpath;
@property (strong) NSManagedObject *managedObject;



-(void) updateNote;
-(void) saveNote;
@end
