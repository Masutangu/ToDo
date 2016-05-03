//
//  TDLJobDetailsViewController.h
//  ToDo
//
//  Created by Masutangu on 16/4/23.
//  Copyright © 2016年 Masutangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDLJob.h"

@interface TDLJobDetailsViewController : UITableViewController <UITextFieldDelegate>

- (instancetype)initForNew:(BOOL)isNew;

@property (nonatomic, strong) TDLJob *job;

@end
