//
//  PhotoGalleryViewController.m
//  PhotoGallery
//
//  Created by Asif Seraje on 1/12/12.
//  Copyright (c) 2012 Asif Seraje. All rights reserved.
//

#import "PGAlbumPicker.h"
#import "PGDataSource.h"
#import "PGThumbsController.h"
#import "PGAlbumCell.h"

@interface PGAlbumPicker ()

@property (nonatomic, strong) IBOutlet UITableView *dataTable;
@property (nonatomic, strong) PGDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UINavigationBar *customNavi;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PGAlbumPicker

//Public
@synthesize delegate = _delegate;
@synthesize tag = _tag;

//Private
@synthesize dataTable = _dataTable;
@synthesize dataSource = _dataSource;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Get a data source
        PGDataSource *newDS = [[PGDataSource alloc] init];
        self.dataSource = newDS;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.naviTitle;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    //Refresh UI
    [self.dataTable reloadData];
}

#pragma mark - UIEvents

- (IBAction)cancelPicker:(id)sender {
    [self.delegate albumPickerDidCancel: self];
}

#pragma mark - UITablewViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfFolders];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITableViewCell";
    
    //Get a working cell
    PGAlbumCell *cell = (PGAlbumCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PGAlbumCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //Label
    NSString *folderName = [self.dataSource folderNameForIndex: indexPath.row];
    cell.pgTitleLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
    
    cell.pgDetailTitlelbl.font = [UIFont fontWithName:@"OpenSans" size:12.0];
    cell.pgTitleLabel.text = folderName;
    
    //Sublabel
    NSDictionary *_dicItem = [self.dataSource numberOfFilesForFolder:folderName];
    int files = [self.dataSource numberOfFilesForDictionary:_dicItem];
    NSString *folderDetails = [self.dataSource getPhotosStringFromNumber: _dicItem];
    cell.pgDetailTitlelbl.text = folderDetails;
    
    //Disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //Left image
    if (files > 0) {
        NSString *thumbFilePath = [self.dataSource getThumbnail110PathForFilename: [self.dataSource fileNameForFolder: folderName Index: files-1]];
        cell.pgImageView.image = [UIImage imageWithContentsOfFile: thumbFilePath];
    } else {
        cell.pgImageView.image = [UIImage imageNamed: @"photogallery"];
    }
    
    UIImage *indicatorImage = [UIImage imageNamed:@"arrow.png"];
    cell.accessoryView =[[UIImageView alloc]initWithImage:indicatorImage];
    
    
    
    //Return cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Deselect
    [tableView deselectRowAtIndexPath: indexPath animated: TRUE];
 
    //Get folder name
    NSString *folderName = [self.dataSource folderNameForIndex: indexPath.row];
    
    //Notify the delegate
    [self.delegate albumPicker: self didSelectAlbumName: folderName];
}

#pragma mark - OS Events

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setDataTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
