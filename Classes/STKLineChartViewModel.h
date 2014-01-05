//
//  STKLineChartViewModel.h
//  STKCharts
//
//  Created by Rick Roberts on 1/4/14.
//  Copyright (c) 2014 Street Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKLineChartViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *data;

- (id)initWithView:(UIView *)view;
- (void)plotLineChartWithXAxixProperty:(NSString *)xAxisProperty yAxisProperty:(NSString *)yAxisProperty dataArray:(NSMutableArray *)data;
- (void)updateLayout:(BOOL)animated;

@end
