//
//  InfiniteScrollView.m
//  ScrollInfinite
//
//  Created by ChuanLi on 2018/4/25.
//  Copyright © 2018 ChuanLi. All rights reserved.
//

#import "BLScrollView.h"
#import "UIView+Common.h"
#import "BLCalendarSetionInfo.h"
#import "NSDate+Helper.h"

@interface BLScrollView()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isDecelerating;
@property (nonatomic, strong) NSMutableDictionary* sectionViewDict;
//TODO: make use of backupCellArray 
@property (nonatomic, strong) NSMutableArray* backupCellArray;

@property (nonatomic, assign) CGPoint targetOffset;
@property (nonatomic, assign) BOOL autoScroll;

- (void)_setup;

- (void)_resumeTimer;
- (void)_suspendTimer;

- (void)_panMe:(UIPanGestureRecognizer *)pan;

//It will make the performance much better to deal with header and non-header sections seperately.
//We shall find a better way to tackle it together
- (void)_translateView:(CGPoint)point;

- (void)_scrollStarted;
- (void)_scrollStopped;

@end

@implementation BLScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)setTopSectionInfo:(id<BLSectionInfo>)topSectionInfo {
    if ([[self currentSection] isEqual:topSectionInfo]) {
        return;
    }
    BOOL shouldAutoReload = _topSectionInfo != nil;
    _topSectionInfo = topSectionInfo;
    if (shouldAutoReload) {
        [self reloadData];
    }
}

- (id<BLSectionInfo>)currentSection {
    if ([self.sectionViewArray count] <= 0) {
        return nil;
    }
    BLSectionView* sectionView = [self.sectionViewArray objectAtIndex:0];
    return sectionView.sectionInfo;
}

- (void)reloadData {
    for (UIView* subView in self.sectionViewArray){
        [subView removeFromSuperview];
    }
    [self.sectionViewArray removeAllObjects];
    
    if (!self.topSectionInfo) return;
    
    id<BLSectionInfo> current = self.topSectionInfo;
    BLSectionView* sectionView = [self sectionViewFor:current];
    [self addSubview:sectionView];
    [self.sectionViewArray addObject:sectionView];
    while (sectionView.bottom < self.height) {
        current = [current next];
        CGFloat bottom = sectionView.bottom;
        sectionView = [self sectionViewFor:current];
        sectionView.top = bottom;
        [self addSubview:sectionView];
        [self.sectionViewArray addObject:sectionView];
    }
    
}

- (BLSectionView *)sectionViewFor:(id<BLSectionInfo>)sectionInfo{
    if (nil == sectionInfo) {
        return nil;
    }
    BLSectionView* sectionView = [self.sectionViewDict objectForKey:sectionInfo];
    if (sectionView) {
        return sectionView;
    }
    sectionView = [[BLSectionView alloc] initWithFrame:CGRectZero];
    sectionView.width = self.width;
    sectionView.accessibilityIdentifier = @"sectionView";
    sectionView.sectionInfo = sectionInfo;
    
    NSMutableArray* cellArray = [NSMutableArray array];
    
    for (id cellInfo in sectionInfo.cellInfoArray){
        UIView* cell = [self.dataSource scrollView:self cellForInfo:cellInfo];
        cell.width = self.width;
        cell.height = [self.dataSource scrollView:self cellHeightForInfo:cellInfo];
        [sectionView addSubview:cell];
        [cellArray addObject:cell];
    }
    sectionView.cellArray = cellArray;
    
    if ([self.dataSource respondsToSelector:@selector(scrollView:headerForInfo:)]) {
        UIView* header = [self.dataSource scrollView:self headerForInfo:sectionInfo];
        if (header) {
            [sectionView addSubview:header];
            sectionView.header = header;
        }
    }
    
    [sectionView renderCells];
    
    return sectionView;
}

- (void)scrollOffset:(CGPoint)offset animated:(BOOL)animated {
    float distance = fabs(offset.y);
    if (distance <= 0.f) {
        return;
    }
    
    float speed = distance / ceil(distance);
    if (offset.y < 0) {
        speed = -speed;
    }
    
    self.velocity = CGPointMake(self.velocity.x, speed);
    self.targetOffset = offset;
    self.autoScroll = true;
    [self _resumeTimer];
}

#pragma mark - Private Method
- (void)_setup {
    self.sectionViewArray = [NSMutableArray array];
    self.sectionViewDict = [NSMutableDictionary dictionary];
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
        if (self.autoScroll) {
            if (self.targetOffset.y * self.velocity.y > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self _translateView:self.velocity];
                    self.targetOffset = CGPointMake(0, self.targetOffset.y - self.velocity.y);
                });
            }
            else {
                self.autoScroll = false;
                [self _suspendTimer];
            }
        }
        else {
            if (fabs(self.velocity.y) < 1) {
                self.velocity = CGPointZero;
                [self _suspendTimer];
                 [self _scrollStopped];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self _translateView:self.velocity];
                });
                self.velocity = CGPointMake(self.velocity.x, self.velocity.y / 1.05);
            }
        }
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

#pragma mark - Pan Guesture Event Handler
- (void)_panMe:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self _scrollStarted];
    }
    
    CGPoint rawPoint = [pan translationInView:self];
    CGPoint rawVelocity = [pan velocityInView:self];
    
    CGPoint point = CGPointMake(floor(rawPoint.x), floor(rawPoint.y));
    CGPoint velocity = CGPointMake(floor(rawVelocity.x), floor(rawVelocity.y));
    [self _translateView:point];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat vy = floor(sqrt(fabs(velocity.y)));
        if (velocity.y < 0) {
            vy = -vy;
        }
        if (fabs(vy) > 10.f) {
            self.velocity = CGPointMake(velocity.x, vy);
            self.autoScroll = false;
            [self _resumeTimer];
        }
        else {
            [self _scrollStopped];
        }
    }
    else{
        [self _suspendTimer];
    }
    [pan setTranslation:CGPointZero inView:self];
}

- (void)_translateView:(CGPoint)point{
    if ([self.sectionViewArray count] <= 0) {
        return;
    }
    
    NSMutableArray* toRemoveArray = [NSMutableArray array];
    for (BLSectionView* sectionView in self.sectionViewArray){
        sectionView.top = sectionView.top + point.y;
        if (!CGRectIntersectsRect(self.bounds, sectionView.frame)) {
            [sectionView removeFromSuperview];
            [toRemoveArray addObject:sectionView];
            continue;
        }
    }
    [self.sectionViewArray removeObjectsInArray:toRemoveArray];
    if ([self.delegate respondsToSelector:@selector(scrollView:sectionWillBeRemoved:)]) {
        for (BLSectionView* sectionView in toRemoveArray){
            [self.delegate scrollView:self sectionWillBeRemoved:sectionView.sectionInfo];
        }
    }
    
    BLSectionView* topSection = [self.sectionViewArray objectAtIndex:0];
    [topSection accomodate];
    while (topSection.top > 0) {
        CGFloat topSpace = topSection.top;
        topSection = [self sectionViewFor:[topSection.sectionInfo previous]];
        topSection.bottom = topSpace;
        [topSection accomodate];
        [self addSubview:topSection];
        [self.sectionViewArray insertObject:topSection atIndex:0];
    }
    
    BLSectionView* lastSection = [self.sectionViewArray lastObject];
    while (lastSection.bottom < self.height){
        CGFloat bottom = lastSection.bottom;
        lastSection = [self sectionViewFor:[lastSection.sectionInfo next]];
        lastSection.top = bottom;
        [self addSubview:lastSection];
        [self.sectionViewArray addObject:lastSection];
    }
    
    if ([self.sectionViewArray count] > 0) {
        BLSectionView* sectionView = [self.sectionViewArray objectAtIndex:0];
        if (![_topSectionInfo isEqual:sectionView.sectionInfo]) {
            _topSectionInfo = sectionView.sectionInfo;
            
            if ([self.delegate respondsToSelector:@selector(scrollView:topSectionChanged:)]) {
                [self.delegate scrollView:self topSectionChanged:self.topSectionInfo];
            }
        }
    }
}

- (void)_scrollStarted {
    if (_scrolling) {
        return;
    }

    _scrolling = true;
    if ([self.delegate respondsToSelector:@selector(scrollViewDidStartScroll:)]) {
        [self.delegate scrollViewDidStartScroll:self];
    }
}

- (void)_scrollStopped{
    _scrolling = false;
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidStopScroll:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate scrollViewDidStopScroll:self];
        });
    }
}

@end
