//
//  TDLJobDetailsViewController.m
//  ToDo
//
//  Created by Masutangu on 16/4/23.
//  Copyright © 2016年 Masutangu. All rights reserved.
//

#import "TDLJobDetailsViewController.h"
#import "TDLJobStore.h"
#import "TDLJob.h"

@interface TDLJobDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *jobTitle;
@property (weak, nonatomic) IBOutlet UITextField *jobSummary;
@property (weak, nonatomic) IBOutlet UITextField *jobStartDate;
@property (weak, nonatomic) IBOutlet UITextField *jobEndDate;
@property (weak, nonatomic) IBOutlet UITextField *jobTags;

@property (strong, nonatomic) UITextField *currentEditTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSDateFormatter *formatter;
@property (nonatomic) BOOL isNew;

@end

@implementation TDLJobDetailsViewController

#pragma mark initializer
- (instancetype)initForNew:(BOOL)isNew
{
    // Call the superclass's designated initializer
    self = [[UIStoryboard storyboardWithName:@"TDLJobDetailsViewController" bundle:nil] instantiateInitialViewController];
    
    //self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithTitle:@"加入"
                                         style:UIBarButtonItemStyleDone
                                         target:self
                                         action:@selector(addJob:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@"取消"
                                           style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
            self.navigationItem.rightBarButtonItem.enabled = NO;
            self.navigationItem.title = @"新建任务";
        }
        self.isNew = isNew;
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNew:"
                                 userInfo:nil];
    return nil;
}


# pragma mark view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobTitle.delegate = self;
    self.jobSummary.delegate = self;
    self.jobStartDate.delegate = self;
    self.jobEndDate.delegate = self;
    self.jobTags.delegate = self;
    
    self.datePicker = [[UIDatePicker alloc]init];
    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.locale = datelocale;
    self.datePicker.timeZone = [NSTimeZone localTimeZone];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // cancel button for date picker
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                           action:@selector(canceldatePicker)];
    //inorder to make "done" button on the right side
    UIBarButtonItem * dummy = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    // done button for date picker
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                         action:@selector(donedatePicker)];
    toolBar.items = @[cancel, dummy, done];
    [self.jobStartDate setInputAccessoryView:toolBar];
    [self.jobEndDate setInputAccessoryView:toolBar];
    self.jobStartDate.inputView = self.datePicker;
    self.jobEndDate.inputView = self.datePicker;
    
    [self.jobTitle addTarget:self
                      action:@selector(jobTitleDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isNew) {
        self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
        if (![self.jobStartDate.text length]) {
            NSDate *currentDate = [NSDate date];
            self.jobStartDate.text = [self.formatter stringFromDate:currentDate];
            NSTimeInterval secondsInOneHours = 1 * 60 * 60;
            self.jobEndDate.text = [self.formatter stringFromDate:[currentDate dateByAddingTimeInterval:secondsInOneHours]];
        }
    } else {
        self.jobTitle.text = self.job.title;
        self.jobSummary.text = self.job.summary;
        self.jobTags.text = self.job.tags;
        self.jobStartDate.text = [self.formatter stringFromDate: self.job.startDate];
        self.jobEndDate.text = [self.formatter stringFromDate: self.job.endDate];
    }
}

# pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    if (textField == self.jobStartDate ||
        textField == self.jobEndDate)
    {
        [self.datePicker setDate:[self.formatter dateFromString:textField.text]];
        self.currentEditTextField = textField;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    [textField resignFirstResponder];
    return YES;
}

# pragma mark target-action
-(void) canceldatePicker
{
    NSLog(@"canceldatePicker");
    //self.datePicker.hidden = YES;
    [self.currentEditTextField resignFirstResponder];
}

-(void) donedatePicker
{
    NSLog(@"donedatePicker");
    self.currentEditTextField.text = [self.formatter stringFromDate:self.datePicker.date];
    if ([self.formatter dateFromString:self.jobStartDate.text] > [self.formatter dateFromString:self.jobEndDate.text]) {
        NSTimeInterval secondsInOneHours = 1 * 60 * 60;
        NSDate *adjustEndDate = [[self.formatter dateFromString:self.jobStartDate.text] dateByAddingTimeInterval:secondsInOneHours];
        self.jobEndDate.text = [self.formatter stringFromDate:adjustEndDate];
    }
    [self.currentEditTextField resignFirstResponder];
}

-(void)jobTitleDidChange:(UITextField *)sender
{
    if (sender == self.jobTitle) {
        if ([self.jobTitle.text length]) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.hidesBackButton = NO;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            self.navigationItem.hidesBackButton = YES;
        }
    }
}

-(void)addJob:(UIBarButtonItem *)sender
{
    NSLog(@"add job");
    // Create a new BNRItem and add it to the store
    [[TDLJobStore sharedStore] newJobWithTitle:self.jobTitle.text
                                           Tag:self.jobTags.text
                                       Summary:self.jobSummary.text
                                     StartDate:[self.formatter dateFromString:self.jobStartDate.text]
                                       EndDate:[self.formatter dateFromString:self.jobEndDate.text]];
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

-(void)cancel:(UIBarButtonItem *)sender
{
    NSLog(@"cancel ");
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

# pragma mark setter & getter
- (void)setJob:(TDLJob *)job
{
    _job = job;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"view will disapper");
    [super viewWillDisappear:animated];
    // Clear first responder
    [self.view endEditing:YES];
    // "Save" changes to item
    if (!self.isNew && [self.jobTitle.text length]) {
        self.job.title = self.jobTitle.text;
        self.job.summary = self.jobSummary.text;
        self.job.tags = self.jobTags.text;
        self.job.startDate = [self.formatter dateFromString: self.jobStartDate.text];
        self.job.endDate = [self.formatter dateFromString: self.jobEndDate.text];
    }
}


@end
