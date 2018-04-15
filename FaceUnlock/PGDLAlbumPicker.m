//
//  PGDLAlbumPicker.m
//  Foxbrowser
//
//  Created by Twinbit2 on 3/30/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "PGDLAlbumPicker.h"
#import "PGDataSource.h"
#import "PGThumbsController.h"
#import "PGAlbumCell.h"

@interface PGDLAlbumPicker ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *dataTable;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) PGDataSource *dataSource;
@end

@implementation PGDLAlbumPicker

@synthesize delegate = _delegate;
@synthesize tag = _tag;

@synthesize dataTable = _dataTable;
@synthesize dataSource = _dataSource;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Get a data source
        PGDataSource *newDS = [[PGDataSource alloc] initWithCaller];
        self.dataSource = newDS;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataTable.delegate = self;
    self.dataTable.dataSource = self;
    self.titleLabel.text = self.naviTitle;
    
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    //Refresh UI
    [self.dataTable reloadData];
}

#pragma mark - UIEvents

- (IBAction)cancelPicker:(id)sender {
    [self.delegate dlAlbumPickerDidCancel: self];
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
    [self.delegate dlAlbumPicker: self didSelectAlbumName: folderName];
}


@end
