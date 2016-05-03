//
//  TDLJob.h
//  ToDo
//
//  Created by Masutangu on 16/4/23.
//  Copyright © 2016年 Masutangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

extern const int unFinishStatus;
extern const int finishedStatus;

@interface TDLJob : NSManagedObject

- (BOOL)isFinish;

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "TDLJob+CoreDataProperties.h"
