//
//  GCImageScrollView.m
//  GCImageScrollView
//
//  Created by sunflower on 2018/11/8.
//  Copyright © 2018 sunflower. All rights reserved.
//

#import "GCImageScrollView.h"

@interface GCImageScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, assign) NSInteger curIndex;

@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, assign) NSTimeInterval scrollDuration;

@end

@implementation GCImageScrollView

- (instancetype)initWithFrame:(CGRect)frame scrollDuration:(NSTimeInterval)duration
{
    if (self = [super initWithFrame:frame]) {
        self.scrollDuration = 0.f;
        [self addObservers];
        [self setupViews];
        if (duration > 0.f) {
            self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:(self.scrollDuration = duration)
                                                                target:self
                                                              selector:@selector(scrollTimerDidFired:)
                                                              userInfo:nil
                                                               repeats:YES];
            [self.scrollTimer setFireDate:[NSDate distantFuture]];
        }
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollDuration = 0.f;
        [self addObservers];
        [self setupViews];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObservers];
    
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

#pragma mark - setupViews
- (void)setupViews {
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageLabel];
    
    [self placeSubviews];
}

- (void)placeSubviews {
    self.scrollView.frame = self.bounds;
    
    CGFloat imageWidth = CGRectGetWidth(self.scrollView.bounds);
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    self.leftImageView.frame    = CGRectMake(imageWidth * 0, 0, imageWidth, imageHeight);
    self.middleImageView.frame  = CGRectMake(imageWidth * 1, 0, imageWidth, imageHeight);
    self.rightImageView.frame   = CGRectMake(imageWidth * 2, 0, imageWidth, imageHeight);
    self.scrollView.contentSize = CGSizeMake(imageWidth * 3, 0);
    
    self.pageLabel.frame = CGRectMake(imageWidth-50, imageHeight-30, 40, 20);
    
    [self setScrollViewContentOffsetCenter];
}

#pragma mark - set scrollView contentOffset to center
- (void)setScrollViewContentOffsetCenter {
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
}

#pragma mark - kvo
- (void)addObservers {
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self caculateCurIndex];
    }
}

#pragma mark - getters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
    }
    
    return _leftImageView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [UIImageView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [_middleImageView addGestureRecognizer:tap];
        _middleImageView.userInteractionEnabled = YES;
    }
    
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
    }
    return _rightImageView;
}

- (UILabel *)pageLabel{
    if(!_pageLabel){
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.layer.cornerRadius = 8;
        _pageLabel.clipsToBounds = YES;
        _pageLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        _pageLabel.font = [UIFont systemFontOfSize:14];
        _pageLabel.textColor = [UIColor whiteColor];
    }
    return _pageLabel;
}


#pragma mark - setters
- (void)setGc_imageURLStringArray:(NSArray *)gc_imageURLStringArray {
    
    if (_gc_imageURLStringArray) {
        _gc_imageURLStringArray = gc_imageURLStringArray;
        self.curIndex = 0;
        
        if (gc_imageURLStringArray.count > 1) {
            // auto scroll
            [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollDuration]];
            self.pageLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)gc_imageURLStringArray.count];
        } else {
            [self.leftImageView removeFromSuperview];
            [self.rightImageView removeFromSuperview];
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), 0);
        }
    }
}

- (void)setCurIndex:(NSInteger)curIndex {
    
    if (_curIndex >= 0) {
        _curIndex = curIndex;
        
        NSInteger imageCount = self.gc_imageURLStringArray.count;
        NSInteger leftIndex = (curIndex + imageCount - 1) % imageCount;
        NSInteger rightIndex= (curIndex + 1) % imageCount;
        
        
        NSURL *leftImageUrl = [NSURL URLWithString:self.gc_imageURLStringArray[leftIndex]];
        NSURL *curImageUrl = [NSURL URLWithString:self.gc_imageURLStringArray[curIndex]];
        NSURL *rightImageUrl = [NSURL URLWithString:self.gc_imageURLStringArray[rightIndex]];
        
        if(self.gc_imageViewLoad){
            
            self.gc_imageViewLoad(self.leftImageView, leftImageUrl);
            self.gc_imageViewLoad(self.middleImageView, curImageUrl);
            self.gc_imageViewLoad(self.rightImageView, rightImageUrl);
            
        }else{
            
            if([_delegate respondsToSelector:@selector(gc_imageLoadWithImageView:withImageUrl:)]){
                [_delegate gc_imageLoadWithImageView:self.leftImageView withImageUrl:leftImageUrl];
                [_delegate gc_imageLoadWithImageView:self.middleImageView withImageUrl:curImageUrl];
                [_delegate gc_imageLoadWithImageView:self.rightImageView withImageUrl:rightImageUrl];
            }
            
        }
        
        [self setScrollViewContentOffsetCenter];
        
        self.pageLabel.text = [NSString stringWithFormat:@"%li/%lu", (long)curIndex+1, (unsigned long)_gc_imageURLStringArray.count];
    }
}

#pragma mark - caculate curIndex
- (void)caculateCurIndex {
    
    if (self.gc_imageURLStringArray && self.gc_imageURLStringArray.count > 0) {
        CGFloat pointX = self.scrollView.contentOffset.x;
        
        CGFloat criticalValue = .2f;
        
        if (pointX > 2 * CGRectGetWidth(self.scrollView.bounds) - criticalValue) {
            self.curIndex = (self.curIndex + 1) % self.gc_imageURLStringArray.count;
        } else if (pointX < criticalValue) {
            self.curIndex = (self.curIndex + self.gc_imageURLStringArray.count - 1) % self.gc_imageURLStringArray.count;
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.gc_imageURLStringArray.count > 1) {
        [self.scrollTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.gc_imageURLStringArray.count > 1) {
        [self.scrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollDuration]];
    }
}

#pragma mark - button actions
- (void)imageClicked:(UITapGestureRecognizer *)tap {
    
    if(self.gc_imageDidClick){
        
        self.gc_imageDidClick(self.curIndex);
        
    }else{
        
        if([_delegate respondsToSelector:@selector(gc_imageDidClickWithIndex:)]){
            [_delegate gc_imageDidClickWithIndex:self.curIndex];
        }
        
    }
    
}

#pragma mark - timer action
- (void)scrollTimerDidFired:(NSTimer *)timer {
    
    CGFloat criticalValue = .2f;
    if (self.scrollView.contentOffset.x < CGRectGetWidth(self.scrollView.bounds) - criticalValue || self.scrollView.contentOffset.x > CGRectGetWidth(self.scrollView.bounds) + criticalValue) {
        [self setScrollViewContentOffsetCenter];
    }
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

@end
