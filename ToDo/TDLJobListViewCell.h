//
//  TDLJobListViewCell.h
//  ToDo
//
//  Created by Masutangu on 16/4/23.
//  Copyright © 2016年 Masutangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDLJobListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *jobTags;
@property (weak, nonatomic) IBOutlet UILabel *jobEndDate;
@end
