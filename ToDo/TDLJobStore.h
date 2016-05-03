//
//  TDLJobStore.h
//  ToDo
//
//  Created by Masutangu on 16/4/16.
//  Copyright © 2016年 Masutangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDLJob.h"

@interface TDLJobStore : NSObject


// Notice that this is a class method and prefixed with a + instead of a -
+ (instancetype)sharedStore;

- (BOOL)saveChanges;

- (TDLJob *) newJobWithTitle:(NSString *)title
                         Tag:(NSString *)tags
                     Summary:(NSString *)summary
                   StartDate:(NSDate *)startDate
                     EndDate:(NSDate *)endDate;
- (NSArray *) unFinishJobs;
- (NSArray *) finishedJobs;
- (NSArray *) deadlineJobs;
- (void)removeJob:(TDLJob *)job;

@end
