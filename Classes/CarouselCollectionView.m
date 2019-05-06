//
//  CarouselCollectionView.m
//  FunTest
//
//  Created by 刘鹏i on 2019/3/11.
//  Copyright © 2019 Musjoy. All rights reserved.
//

#import "CarouselCollectionView.h"

@interface CarouselCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak, nullable) id <CarouselCollectionViewDelegate> carouselDelegate;
@property (nonatomic, weak, nullable) id <CarouselCollectionViewDataSource> carouselDataSource;

@property (nonatomic, assign) NSInteger itemCount;///< 元素个数
@property (nonatomic, assign) BOOL onceToken;///< 第一次显示
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CarouselCollectionView
@dynamic delegate;
@dynamic dataSource;

#pragma mark - Life Cycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self viewConfig];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_onceToken == NO) {
        _onceToken = YES;

        if (self.itemCount > 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            });
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Subjoin
- (void)viewConfig
{
    super.delegate = self;
    super.dataSource = self;
    
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewLayout = layout;

    _currentIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - Set & Get
- (void)setDelegate:(id<CarouselCollectionViewDelegate>)delegate
{
    _carouselDelegate = delegate;
}

- (id<CarouselCollectionViewDelegate>)delegate
{
    return _carouselDelegate;
}

- (void)setDataSource:(id<CarouselCollectionViewDataSource>)dataSource
{
    _carouselDataSource = dataSource;
}

- (id<CarouselCollectionViewDataSource>)dataSource
{
    return _carouselDataSource;
}

- (void)setDuration:(CGFloat)duration
{
    _duration = duration;
    
    if (duration <= 0) {
        return;
    }
    
    if (_timer == nil) {
        _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:duration] interval:duration target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - Private
/// 当前indexPath转为外面实际数据源的indexPath
- (NSIndexPath *)toUserIndexPath:(NSIndexPath *)indexPath
{
    if (_itemCount == 0) {
        return [NSIndexPath indexPathForItem:0 inSection:0];
    }
    
    NSIndexPath *userIndex = nil;
    if (indexPath.row == 0) {
        userIndex = [NSIndexPath indexPathForItem:_itemCount - 3 inSection:0];
    } else if (indexPath.row == _itemCount - 1) {
        userIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    } else {
        userIndex = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0];
    }
    return userIndex;
}

/// 改变indexPath
- (void)indexPathChange
{
    NSInteger index = self.contentOffset.x / self.bounds.size.width;
    _currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
 
    if (_currentIndexPath.row == 0) {
        _currentIndexPath = [NSIndexPath indexPathForItem:_itemCount - 2 inSection:0];
        [self scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } else if (_currentIndexPath.row == _itemCount - 1) {
        _currentIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    NSIndexPath *userIndexPath = [self toUserIndexPath:_currentIndexPath];
    if ([_carouselDelegate respondsToSelector:@selector(collectionView:currentIndexPath:)]) {
        [_carouselDelegate collectionView:self currentIndexPath:userIndexPath];
    }
}

#pragma mark - Action
- (void)timerAction:(NSTimer *)timer
{
    if (_currentIndexPath.row + 1 >= _itemCount) {
        return;
    }
    
    NSInteger index = _currentIndexPath.row + 1;
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        [self indexPathChange];
    }
    
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_duration]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self indexPathChange];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self indexPathChange];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *userIndexPath = [self toUserIndexPath:indexPath];
    if ([_carouselDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [_carouselDelegate collectionView:collectionView didSelectItemAtIndexPath:userIndexPath];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [_carouselDataSource collectionView:collectionView numberOfItemsInSection:section];
    if (count <= 0) {
        _itemCount = 0;
    } else {
        _itemCount = count + 2;
    }
    return _itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *userIndexPath = [self toUserIndexPath:indexPath];
    return [_carouselDataSource collectionView:collectionView cellForItemAtIndexPath:userIndexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

#pragma mark - Notification
- (void)orientationDidChange
{
    [self.collectionViewLayout invalidateLayout];
    
    if (_itemCount > 0) {
        [self scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}
@end
