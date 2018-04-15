//
//  NoteDetailsViewController.m
//  PhotoVault
//
//  Created by Asif Seraje on 12/14/15.
//
//

#import "NoteDetailsViewController.h"

@interface NoteDetailsViewController ()<UITextViewDelegate>{
    
    
    
    NSString *str;
}

@end

@implementation NoteDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.noteView.delegate = self;
        self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.managedObject) {
        
        self.noteView.userInteractionEnabled = NO;
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(updateNote)];
        [self.navigationItem setRightBarButtonItem:editButton];
        
        //[self.testLabel setText:self.noteString];
        //[self.noteView setText:self.noteString];
        if (self.managedObject) {
            [self.noteView setText:[self.managedObject valueForKey:@"body"]];
            
        }
      
    }
    else{
    
        self.noteView.text = @"";
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.noteView becomeFirstResponder];
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote)];
        
                
        [self.navigationItem setRightBarButtonItem:saveButton];
        //self.navigationItem.rightBarButtonItem.enabled = NO;

    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.view endEditing:YES];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Mark--Saving Note 
-(NSManagedObjectContext *) managedObjectContext{

    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate respondsToSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)saveNote{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
   
        
    self.msgBody = self.noteView.text;

    if ([self.msgBody length] ==0) {
      
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Empty Note"
                                              message:@"Write New Note Plz"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        }
    else{
        
        if (self.managedObject) {
            
                // Update existing Note
                
                [self.managedObject setValue:self.msgBody forKey:@"body"];
                self.creationTime = [NSDate date];
                [self.managedObject setValue:self.creationTime forKey:@"date"];
                
            
        }
        else{
            NSManagedObject *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
            [newNote setValue:self.msgBody forKey:@"body"];
            self.creationTime = [NSDate date];
            [newNote setValue:self.creationTime forKey:@"date"];
        }
        
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        
            
            
        }
    }
    
    
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark--updating notes

-(void)updateNote{


    [self.noteView becomeFirstResponder];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-textview Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{

    if ([self.noteView.text length]>0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}




@end
