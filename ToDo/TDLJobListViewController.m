//
//  TDLJobListViewController.m
//  ToDo
//
//  Created by Masutangu on 16/4/16.
//  Copyright © 2016年 Masutangu. All rights reserved.
//

#import "TDLJobListViewController.h"
#import "TDLJob.h"
#import "TDLJobStore.h"
#import "TDLJobDetailsViewController.h"
#import "TDLJobListViewCell.h"

@interface TDLJobListViewController ()

@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation TDLJobListViewController

NSString * const TDLJobCellIdentifier = @"TDLJobListViewCell";


#pragma mark initializer
- (instancetype)initWithTitle:(NSString *)title
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        // Create a new bar button item that will send
        // addNewJob: to TDLMainViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewJob:)];
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        navItem.title = title;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initWithTitle:"
                                 userInfo:nil];
    return nil;

}

# pragma mark view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:TDLJobCellIdentifier bundle:nil];
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib
         forCellReuseIdentifier:TDLJobCellIdentifier];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self jobList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDLJobListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TDLJobCellIdentifier forIndexPath:indexPath];
    TDLJob *job = self.jobList[indexPath.row];
    cell.jobTitle.text = job.title;
    cell.jobTags.text = job.tags;
    if ([job isFinish]) {
        cell.jobEndDate.text = [NSString stringWithFormat:@"于%@完成", [self.formatter stringFromDate: job.endDate]];
    } else {
        cell.jobEndDate.text = [NSString stringWithFormat:@"%@截止", [self.formatter stringFromDate: job.endDate]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDLJobListViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TDLJobCellIdentifier];
    return cell.frame.size.height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TDLJob *job = self.jobList[indexPath.row];
        [[TDLJobStore sharedStore] removeJob:job];
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDLJobDetailsViewController *detailViewController = [[TDLJobDetailsViewController alloc] initForNew:NO];
    // Give detail view controller a pointer to the job object in row
    detailViewController.job = self.jobList[indexPath.row];;
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];

}

#pragma mark - Table view delegate
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                       title:@"删除"
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [[TDLJobStore sharedStore] removeJob: self.jobList[indexPath.row]];
            [tableView setEditing:NO animated:YES];
            [tableView reloadData];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *finishAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"已完成" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        TDLJob *selectJob = self.jobList[indexPath.row];
        selectJob.status = [NSNumber numberWithInteger:finishedStatus];
        [tableView setEditing:NO animated:YES];
        [tableView reloadData];
    }];
    finishAction.backgroundColor = [UIColor greenColor];
    
    NSArray *arr = @[deleteAction, finishAction];
    return arr;
}

#pragma mark Target-Action
- (IBAction)addNewJob:(id)sender
{
    
    NSLog(@"add New Job");
    // Create a new BNRItem and add it to the store
    //TDLJob *newJobs = [[TDLJobStore sharedStore] createJob];
    [self.tableView reloadData];
    TDLJobDetailsViewController *detailViewController = [[TDLJobDetailsViewController alloc] initForNew:TRUE];
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark helper
- (NSArray *)jobList
{
    if ([self.navigationItem.title isEqualToString: @"待完成"]) {
        return [[TDLJobStore sharedStore] unFinishJobs];
    } else if ([self.navigationItem.title isEqualToString: @"已完成"]) {
        return [[TDLJobStore sharedStore] finishedJobs];
    } else if ([self.navigationItem.title isEqualToString: @"今日截止"]) {
        return [[TDLJobStore sharedStore] deadlineJobs];
    } else {
        NSLog(@"unexpected title [%@]", self.title);
        return @[];
    }
}


@end
