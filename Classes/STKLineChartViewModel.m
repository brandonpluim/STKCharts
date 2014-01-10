//
//  STKLineChartViewModel.m
//  STKCharts
//
//  Created by Rick Roberts on 1/4/14.
//  Copyright (c) 2014 Street Technology, LLC. All rights reserved.
//

#import "STKLineChartViewModel.h"

@interface STKLineChartViewModel ()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSMutableArray *verticalConstraints;
@property (nonatomic, strong) NSMutableArray *horizontalContraints;
@property (nonatomic, strong) NSMutableArray *pointViews;

@property (nonatomic, strong) NSString *yProperty;
@property (nonatomic, strong) NSString *xProperty;

@end

@implementation STKLineChartViewModel

- (id)initWithView:(UIView *)view
{
    if (self = [super init]) {
        NSAssert(view, @"You must init with a view to display the graph data");
        self.view = view;
        self.verticalConstraints = [NSMutableArray array];
        self.data = [NSMutableArray array];
        self.pointViews = [NSMutableArray array];
        self.horizontalContraints = [NSMutableArray array];
    }
    
    return self;
}

- (void)plotLineChartWithXAxixProperty:(NSString *)xAxisProperty yAxisProperty:(NSString *)yAxisProperty dataArray:(NSMutableArray *)data
{
    self.xProperty = xAxisProperty;
    self.yProperty = yAxisProperty;
    self.data = data;
    
    if (! self.dataColor) {
        self.dataColor = [UIColor blackColor];
    }
    
    [self drawPoints];
    
}

- (void)updateData:(NSArray *)data
{
    self.data = [data mutableCopy];
    [[self.view subviews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view removeFromSuperview];
    }];
    [self.pointViews removeAllObjects];
    
    [self drawPoints];
}

- (void)drawPoints
{
    if (! self.maxYValue) {
        self.maxYValue = [[self.data valueForKeyPath:[NSString stringWithFormat:@"@max.%@", self.yProperty]] doubleValue];
    }
    
    [self.data enumerateObjectsUsingBlock:^(id p, NSUInteger idx, BOOL *stop) {
        UIView *pointView = [[UIView alloc] init];
        [pointView setBackgroundColor:self.dataColor];
        [pointView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [pointView.layer setCornerRadius:5.0f];
        [self.view addSubview:pointView];
        [self.pointViews addObject:pointView];
        
        CALayer *layer = pointView.layer;
        layer.sublayerTransform = CATransform3DMakeTranslation(5, 5, 0);
        
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = self.dataColor.CGColor;
        [layer addSublayer:lineLayer];
        
        NSDictionary *dict = NSDictionaryOfVariableBindings(pointView);
        NSString *verticalConstraintsString = [NSString stringWithFormat:@"V:[pointView(10)]-(%f)-|", [self verticalConstraintForPoint:p]];
        NSString *horizontalConstraintsString = [NSString stringWithFormat:@"H:|-(%f)-[pointView(10)]", [self horizontalConstraintForPoint:p]];
        
        NSArray *hCs = [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintsString options:0 metrics:nil views:dict];
//        [self.horizontalContraints addObject:hCs];
        
        NSArray *vCs = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintsString options:0 metrics:nil views:dict];
//        [self.verticalConstraints addObject:vCs];
        
        [self.view addConstraints:vCs];
        [self.view addConstraints:hCs];
        
    }];
    
    [self.view layoutIfNeeded];
    
    [self.pointViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (idx > 0) {
            [CATransaction setDisableActions:YES];
            UIView *v = self.pointViews[idx - 1];
            setLayerToLineFromAToB(view.layer.sublayers[0], v.center, view.center, 1);
            [CATransaction setDisableActions:NO];
        }
    }];
}

- (void)updateLayout:(BOOL)animated
{
    [self.pointViews enumerateObjectsUsingBlock:^(UIView *pointView, NSUInteger idx, BOOL *stop) {
        [self.view removeConstraints:self.verticalConstraints[idx]];
        [self.view removeConstraints:self.horizontalContraints[idx]];
        
        NSDictionary *dict = NSDictionaryOfVariableBindings(pointView);
        NSString *verticalConstraintsString = [NSString stringWithFormat:@"V:[pointView(10)]-(%f)-|", [self verticalConstraintForPoint:self.data[idx]]];
        NSString *horizontalConstraintsString = [NSString stringWithFormat:@"H:|-(%f)-[pointView(10)]", [self horizontalConstraintForPoint:self.data[idx]]];
        
        NSArray *hCs = [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintsString options:0 metrics:nil views:dict];
        [self.horizontalContraints replaceObjectAtIndex:idx withObject:hCs];
        
        NSArray *vCs = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintsString options:0 metrics:nil views:dict];
        [self.verticalConstraints replaceObjectAtIndex:idx withObject:vCs];
        
        [self.view addConstraints:vCs];
        [self.view addConstraints:hCs];        
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self.pointViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (idx > 0) {
            UIView *v = self.pointViews[idx - 1];
            [UIView animateWithDuration:0.4 animations:^{
                setLayerToLineFromAToB(view.layer.sublayers[0], v.center, view.center, 1);
            }];
        }
    }];
}

- (float)verticalConstraintForPoint:(id)point
{
    float percentage = [[point valueForKey:self.yProperty] floatValue] / self.maxYValue;
    return (self.view.frame.size.height * percentage) - 5;
}

- (float)horizontalConstraintForPoint:(id)point
{
    float spacing = self.view.frame.size.width / self.data.count;
    return [self.data indexOfObject:point] * spacing;
}

void setLayerToLineFromAToB(CALayer *layer, CGPoint a, CGPoint b, CGFloat lineWidth)
{
    CGPoint center = { 0.5 * (a.x - b.x), 0.5 * (a.y - b.y) };
    CGFloat length = sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
    CGFloat angle = atan2(a.y - b.y, a.x - b.x);
    
    layer.allowsEdgeAntialiasing = YES;
    layer.position = center;
    layer.bounds = (CGRect) { {0, 0}, { length + lineWidth, lineWidth } };
    layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
}

@end
