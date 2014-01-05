//
//  STKDataPoint.h
//  STKCharts
//
//  Created by Rick Roberts on 1/4/14.
//  Copyright (c) 2014 Street Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface STKDataPoint : NSManagedObject

@property (nonatomic, retain) NSDate * dateTime;
@property (nonatomic, retain) NSNumber * pointValue;

@end
