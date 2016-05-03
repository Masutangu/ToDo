//
//  TDLJob+CoreDataProperties.h
//  ToDo
//
//  Created by Masutangu on 16/4/23.
//  Copyright © 2016年 Masutangu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TDLJob.h"

NS_ASSUME_NONNULL_BEGIN

@interface TDLJob (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSNumber *rate;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *tags;

@end

NS_ASSUME_NONNULL_END
