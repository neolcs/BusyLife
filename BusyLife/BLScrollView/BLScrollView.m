//
//  InfiniteScrollView.m
//  ScrollInfinite
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLScrollView.h"
#import "UIView+Common.h"

@interface BLScrollView()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isDecelerating;
@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, strong) NSMutableArray* inuseCellArray;
@property (nonatomic, strong) NSMutableArray* backupCellArray;

- (void)_setup;

- (void)_resumeTimer;
- (void)_suspendTimer;

- (void)_pushCell:(UIView *)cell;
- (void)_enqueueCell:(UIView *)cell;

- (void)_panMe:(UIPanGestureRecognizer *)pan;
- (void)_translateView:(CGPoint)point;

@end

@implementation BLScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)reloadData {
    for (UIView* subView in self.inuseCellArray){
        [subView removeFromSuperview];
    }
    [self.inuseCellArray removeAllObjects];
    
    if (!self.topCellInfo) return;
    
    BLCellInfo* current = self.topCellInfo;
    BLCellView* cellView = [self.dataSource cellForInfo:current];
    [self _pushCell:cellView];
    while (cellView.bottom < self.height) {
        current = [current next];
        cellView = [self.dataSource cellForInfo:current];
        [self _pushCell:cellView];
    }
}

#pragma mark - Private Method
- (void)_setup {
    self.inuseCellArray = [NSMutableArray array];
    self.backupCellArray = [NSMutableArray array];
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panMe:)];
    [self addGestureRecognizer:pan];
    
    [self _setupTimer];
}

#pragma mark - Timer Method
- (void)_setupTimer{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 5 * NSEC_PER_MSEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        if (fabs(self.velocity.y) < 1) {
            self.velocity = CGPointZero;
            [self _suspendTimer];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _translateView:self.velocity];
        });
        self.velocity = CGPointMake(self.velocity.x, self.velocity.y / 1.1);
        NSLog(@"dispatch event handled. velocity x:%.2f, y:%.2f", self.velocity.x, self.velocity.y);
    });
}

- (void)_resumeTimer{
    if (self.isDecelerating) {
        return;
    }
    self.isDecelerating = YES;
    dispatch_resume(self.timer);
}

- (void)_suspendTimer {
    if (!self.isDecelerating) {
        return;
    }
    self.isDecelerating = NO;
    dispatch_suspend(self.timer);
}

#pragma mark - Cell Management
- (void)_pushCell:(UIView *)cell {
    if (!cell) return;
    if ([self.inuseCellArray count] > 0){
        UIView* lastCell = [self.inuseCellArray lastObject];
        cell.top = lastCell.bottom;
    }
    [self addSubview:cell];
    [self.inuseCellArray addObject:cell];
}

- (void)_enqueueCell:(UIView *)cell{
    if (!cell) return;
    
    if ([self.inuseCellArray count] > 0) {
        UIView* topCell = [self.inuseCellArray objectAtIndex:0];
        cell.bottom = topCell.top;
    }
    [self addSubview:cell];
    [self.inuseCellArray insertObject:cell atIndex:0];
}

#pragma mark - Pan Guesture Event Handler
- (void)_panMe:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self];
    CGPoint velocity = [pan velocityInView:self];
    NSLog(@"translation x:%.2f, y:%.2f", point.x, point.y);
    NSLog(@"velocity x:%.2f, y:%.2f", velocity.x, velocity.y);
    NSLog(@"state:%ld", (long)pan.state);
    
    [self _translateView:point];
    
    CGFloat vy = 20;
    if (velocity.y < 0) {
        vy = -20;
    }
    self.velocity = CGPointMake(velocity.x, vy);
    
    if (pan.state == UIGestureRecognizerStateEnded && fabs(velocity.y) > 0) {
        [self _resumeTimer];
    }
    else{
        [self _suspendTimer];
    }
    [pan setTranslation:CGPointZero inView:self];
}

- (void)_translateView:(CGPoint)point{
    if ([self.inuseCellArray count] <= 0) {
        return;
    }
    
    NSMutableArray* toRemoveArray = [NSMutableArray array];
    for (BLCellView* cell in self.inuseCellArray){
        cell.top = cell.top + point.y;
        
        if (!CGRectIntersectsRect(self.bounds, cell.frame)) {
            [cell removeFromSuperview];
            [self.delegate cellWillBeRemoved:cell];
            [toRemoveArray addObject:cell];
        }
    }
    [self.inuseCellArray removeObjectsInArray:toRemoveArray];
    
    BLCellView* topCell = [self.inuseCellArray objectAtIndex:0];
    while (topCell.top > 0) {
        topCell = [self.dataSource cellForInfo:[topCell.cellInfo previous]];
        [self _enqueueCell:topCell];
    }
    
    BLCellView* lastCell = [self.inuseCellArray lastObject];
    while (lastCell.bottom < self.height){
        lastCell = [self.dataSource cellForInfo:[lastCell.cellInfo next]];
        [self _pushCell:lastCell];
    }
}

@end
