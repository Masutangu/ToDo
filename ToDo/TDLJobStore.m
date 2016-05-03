//
//  TDLJobStore.m
//  ToDo
//
//  Created by Masutangu on 16/4/16.
//  Copyright © 2016年 Masutangu. All rights reserved.
//

@import CoreData;
#import "TDLJobStore.h"

@interface TDLJobStore()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation TDLJobStore

#pragma mark initializer
+ (instancetype)sharedStore
{
    static TDLJobStore *sharedStore = nil;
    // Do I need to create a sharedStore?
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        // Read in Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        // Where does the SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
    }
    return self;
}


// If a programmer calls [[BNRItemStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[TDLJobStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

#pragma mark inner implementation
- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"TDLJobStore.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (NSArray *)fetchJobsWithPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"TDLJob"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    request.predicate = predicate;
    NSSortDescriptor *sd = [NSSortDescriptor
                            sortDescriptorWithKey:@"createDate"
                            ascending:NO];
    request.sortDescriptors = @[sd];
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return [[NSMutableArray alloc] initWithArray:result];

}


#pragma mark crud interface
- (NSArray *)unFinishJobs
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status = %d",
                            unFinishStatus];
    return [self fetchJobsWithPredicate:predicate];
}

- (NSArray *)finishedJobs
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status = %d",
                            finishedStatus];
    return [self fetchJobsWithPredicate:predicate];
}


- (NSArray *)deadlineJobs
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //gather date components from date
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    //set date components
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];

    NSDate *startDate = [calendar dateFromComponents:dateComponents];
    NSTimeInterval secondsInOneDay = 24 * 60 * 60;
    NSDate *endDate = [startDate dateByAddingTimeInterval:secondsInOneDay];
    

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status = %d AND endDate >= %@ AND endDate <= %@", unFinishStatus, startDate, endDate];
    return [self fetchJobsWithPredicate:predicate];
}

- (TDLJob *) newJobWithTitle:(NSString *)title
                         Tag:(NSString *)tags
                     Summary:(NSString *)summary
                   StartDate:(NSDate *)startDate
                     EndDate:(NSDate *)endDate
{
    
    TDLJob *job = [NSEntityDescription insertNewObjectForEntityForName:@"TDLJob"
                                                inManagedObjectContext:self.context];
    job.title = title;
    job.tags = tags;
    job.startDate = startDate;
    job.endDate = endDate;
    job.summary = summary;
    return job;
}

- (void)removeJob:(TDLJob *)job
{
    [self.context deleteObject:job];
}

@end
