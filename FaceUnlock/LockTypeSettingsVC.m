//
//  LockTypeSettingsVC.m
//  Foxbrowser
//
//  Created by Asif Seraje on 2/11/16.
//  Copyright © 2016 Asif Seraje. All rights reserved.
//

#import "LockTypeSettingsVC.h"
#import "LockTypeSettingsCell.h"

#define APP_BG_COLOR [UIColor colorWithRed:20.0/255.0 green:26.0/255.0 blue:32.0/255.0 alpha:1.0]
#define CELL_SEP_COLOR [UIColor colorWithRed:32.0/255.0 green:39.0/255.0 blue:52.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR [UIColor colorWithRed:30.0/255.0 green:37.0/255.0 blue:45.0/255.0 alpha:1.0]
#define CELL_SEL_COLOR [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]

@interface LockTypeSettingsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *settingsTypeArray;

@end

@implementation LockTypeSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.navigationItem.title = @"Lock type setting";
    self.lockTypeSettingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.translucent = NO;

    self.lockTypeSettingsTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    //    [self.settingsTableView setSeparatorColor:[UIColor colorWithRed:(157/256) green:(157/256) blue:(157/256) alpha:1.0]];
    [self.lockTypeSettingsTable setBackgroundView:nil];
    [self.lockTypeSettingsTable setBackgroundColor:[UIColor clearColor]];
    self.settingsTypeArray = [[NSMutableArray alloc]init];
    NSArray *menuInFirstSection = @[@"Alphabetical",@"Numerical",@"Pattern",@"Calculator",@"None",@"Change passcode"];
    NSDictionary *firstSectionDict = @{@"menuList" : menuInFirstSection};
    
    NSArray *menuInSecondSection = @[@"Break-in reports"];
    NSDictionary *secondSectionDict = @{@"menuList" : menuInSecondSection};
    
    [self.settingsTypeArray addObject:firstSectionDict];
    [self.settingsTypeArray addObject:secondSectionDict];
    [self.lockTypeSettingsTable setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];

}

#pragma mark-TableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.settingsTypeArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *dictionary = self.settingsTypeArray[section];
    NSArray *array = dictionary[@"menuList"];
    return [array count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"SimpleTableCell";
    
    LockTypeSettingsCell *cell = (LockTypeSettingsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LockTypeSettingsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.highlightedTextColor = [UIColor blackColor];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
                cell.reportSwitch.hidden = YES;
                
                NSDictionary *dictionary = self.settingsTypeArray[indexPath.section];
                NSArray *array = dictionary[@"menuList"];
                NSString *cellvalue = array[indexPath.row];
                cell.backgroundColor = [UIColor clearColor];
                cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
//            cell.titleLabel.textColor = [UIColor colorWithRed:(217/256.0) green:(217/256.0) blue:(217/256.0) alpha:(1.0)];
            
                
                
                cell.titleLabel.text = cellvalue;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = CELL_SEL_COLOR;
            [cell setSelectedBackgroundView:bgColorView];
                return  cell;
            
        }
        else if(indexPath.row == 1){
            cell.reportSwitch.hidden = YES;
            
            NSDictionary *dictionary = self.settingsTypeArray[indexPath.section];
            NSArray *array = dictionary[@"menuList"];
            NSString *cellvalue = array[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
//            cell.titleLabel.textColor = [UIColor colorWithRed:(217/256.0) green:(217/256.0) blue:(217/256.0) alpha:(1.0)];
//            cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];
            
            
            cell.titleLabel.text = cellvalue;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = CELL_SEL_COLOR;
            [cell setSelectedBackgroundView:bgColorView];
            return  cell;
            
        }
        else if(indexPath.row == 2){
            cell.reportSwitch.hidden = YES;
            
            NSDictionary *dictionary = self.settingsTypeArray[indexPath.section];
            NSArray *array = dictionary[@"menuList"];
            NSString *cellvalue = array[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
//            cell.titleLabel.textColor = [UIColor colorWithRed:(217/256.0) green:(217/256.0) blue:(217/256.0) alpha:(1.0)];
//            cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];
            
            
            cell.titleLabel.text = cellvalue;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = CELL_SEL_COLOR;
            [cell setSelectedBackgroundView:bgColorView];
            
            return  cell;
            
        }
        else if(indexPath.row == 3){
            cell.reportSwitch.hidden = YES;
            
            NSDictionary *dictionary = self.settingsTypeArray[indexPath.section];
            NSArray *array = dictionary[@"menuList"];
            NSString *cellvalue = array[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
//            cell.titleLabel.textColor = [UIColor colorWithRed:(217/256.0) green:(217/256.0) blue:(217/256.0) alpha:(1.0)];
//            cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];
            
            
            cell.titleLabel.text = cellvalue;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = CELL_SEL_COLOR;
            [cell setSelectedBackgroundView:bgColorView];
            return  cell;
            
        }
        else if(indexPath.row == 4){
            cell.reportSwitch.hidden = YES;
            
            NSDictionary *dictionary = self.settingsTypeArray[indexPath.section];
            NSArray *array = dictionary[@"menuList"];
            NSString *cellvalue = array[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
//            cell.titleLabel.textColor = [UIColor colorWithRed:(217/256.0) green:(217/256.0) blue:(217/256.0) alpha:(1.0)];
           // cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];
            
            
            cell.titleLabel.text = cellvalue;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = CELL_SEL_COLOR;
            [cell setSelectedBackgroundView:bgColorView];
            return  cell;
            
        }
        else if(indexPath.row == 5){
            cell.reportSwitch.hidden = YES;
            
            NSDictionary *dictionary = self.settingsTypeArray[indexPath.section];
            NSArray *array = dictionary[@"menuList"];
            NSString *cellvalue = array[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
//            cell.titleLabel.textColor = [UIColor colorWithRed:(217/256.0) green:(217/256.0) blue:(217/256.0) alpha:(1.0)];
//            cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];
            
            cell.separetorLabel.hidden = YES;
            cell.titleLabel.text = cellvalue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = CELL_SEL_COLOR;
            [cell setSelectedBackgroundView:bgColorView];
            return  cell;
            
        }
    }else{
    
        cell.reportSwitch.hidden = NO;
        
        NSDictionary *dictionary = self.settingsTypeArray[indexPath.section];
        NSArray *array = dictionary[@"menuList"];
        NSString *cellvalue = array[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
//        cell.titleLabel.textColor = [UIColor colorWithRed:(217/256.0) green:(217/256.0) blue:(217/256.0) alpha:(1.0)];
//        cell.titleLabel.highlightedTextColor = [UIColor colorWithRed:(248/256.0) green:(53/256.0) blue:(52/256.0) alpha:1.0];
        
        
        cell.titleLabel.text = cellvalue;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = CELL_SEL_COLOR;
        [cell setSelectedBackgroundView:bgColorView];
        return  cell;
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 55)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, tableView.frame.size.width, 20)];
    [label setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16]];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.textColor = [UIColor colorWithRed:(110/256.0) green:(110/256.0) blue:(112/256.0) alpha:(1.0)];
    
    /* Section header is in 0th index... */
    //[label setText:@"Header"];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]]; //your background color...
    UIView *lineViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 45, tableView.frame.size.width, 1)] ;
    lineViewBottom.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
    UIView *lineViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)] ;
    lineViewTop.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
    [view addSubview:lineViewBottom];
    [view addSubview:lineViewTop];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  45.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        NSString *header = @"Lock type";
        
        return header;
    }
    
    else{
        
        NSString *header = @"";
        return header;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    if ((indexPath.section == 0)&& (indexPath.row == 5)) {
        
        //Take User to the change passcode page

    }
    else if ((indexPath.section == 1)&& (indexPath.row == 0)){
    
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

    }
}



-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
