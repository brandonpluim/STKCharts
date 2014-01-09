//
//  STKViewController.m
//  STKCharts
//
//  Created by Rick Roberts on 1/4/14.
//  Copyright (c) 2014 Street Technology, LLC. All rights reserved.
//

#import "STKViewController.h"
#import "STKDataPoint.h"

#import <STKLineChartViewModel.h>

@interface STKViewController ()

@property (nonatomic, weak) IBOutlet UIView *chartView;
@property (nonatomic, strong) STKLineChartViewModel *viewModel;

@end

@implementation STKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSMutableArray *data = [[STKDataPoint MR_findAllSortedBy:@"dateTime" ascending:YES] mutableCopy];
    
    self.viewModel = [[STKLineChartViewModel alloc] initWithView:self.chartView];
    [self.viewModel setMaxYValue:15];
    [self.viewModel plotLineChartWithXAxixProperty:@"dateTime" yAxisProperty:@"pointValue" dataArray:data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.viewModel updateLayout:NO];
}

@end
