//
//  ViewController.m
//  Example
//
//  Created by 刘鹏i on 2019/3/12.
//  Copyright © 2019 wuhan.musjoy. All rights reserved.
//

#import "ViewController.h"
#import "HomeCarouselCell.h"
#import "CarouselCollectionView.h"

@interface ViewController () <CarouselCollectionViewDelegate, CarouselCollectionViewDataSource>
@property (strong, nonatomic) IBOutlet CarouselCollectionView *carouselView;
@property (nonatomic, strong) NSArray *arrData;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewConfig];
    
    [self dataConfig];
}

- (void)viewConfig
{
    [_carouselView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCarouselCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HomeCarouselCell class])];
}

- (void)dataConfig {
    _arrData = @[@{@"typeIndex": @"1"},
                 @{@"typeIndex": @"2"},
                 @{@"typeIndex": @"3"},
                 @{@"typeIndex": @"4"}];
    
    _pageControl.numberOfPages = _arrData.count;
    
    [_carouselView reloadData];
}


#pragma mark - CarouselCollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath: %@", indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView currentIndexPath:(NSIndexPath *)indexPath
{
    _pageControl.currentPage = indexPath.row;
}

#pragma mark - CarouselCollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCarouselCell class]) forIndexPath:indexPath];
    [cell configCellWithData:_arrData[indexPath.row]];
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
