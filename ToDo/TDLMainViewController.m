//
//  TDLMainViewController.m
//  ToDo
//
//  Created by Masutangu on 16/4/23.
//  Copyright © 2016年 Masutangu. All rights reserved.
//  icon from http://flaticons.net/category.php?c=Office
//

#import "TDLMainViewController.h"
#import "TDLJobListViewController.h"

@interface TDLMainViewController ()

//array of uilabel
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lableInSectionOne;
@end

@implementation TDLMainViewController

- (void)viewDidLoad {
    NSLog(@"view did load");
    [super viewDidLoad];
    self.navigationItem.title = @"Dewdrop";
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *selectLable;
    if (indexPath.section == 0)
    {
        selectLable = self.lableInSectionOne[indexPath.row];
        //NSLog(@"title=%@", cell.textLabel.text);
    }
    
    NSLog(@"title=%@", selectLable.text);
    TDLJobListViewController *jobListViewController =
    [[TDLJobListViewController alloc] initWithTitle:selectLable.text];
   
    [self.navigationController pushViewController:jobListViewController
                                         animated:YES];
}



@end
