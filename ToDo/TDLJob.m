//
//  TDLJob.m
//  ToDo
//
//  Created by Masutangu on 16/4/16.
//  Copyright © 2016年 Masutangu. All rights reserved.
//

#import "TDLJob.h"

@implementation TDLJob

const int unFinishStatus = 0;
const int finishedStatus  = 1;


- (void)awakeFromInsert
{
    NSLog(@"awakeFromInsert");
    [super awakeFromInsert];
    self.createDate = [NSDate date];
    self.status = [NSNumber numberWithInteger: unFinishStatus];
    self.rate = [NSNumber numberWithInteger: 0];
}

- (BOOL)isFinish
{
    return [self.status intValue] == finishedStatus;
}


@end
