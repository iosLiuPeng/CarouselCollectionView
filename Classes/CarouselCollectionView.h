//
//  CarouselCollectionView.h
//  FunTest
//
//  Created by 刘鹏i on 2019/3/11.
//  Copyright © 2019 Musjoy. All rights reserved.
//  轮播view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CarouselCollectionViewDelegate <UICollectionViewDelegate>
/* 建议只使用以下协议，不使用父类中的其他协议 */
@optional
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView currentIndexPath:(NSIndexPath *)indexPath;
@end

@protocol CarouselCollectionViewDataSource <UICollectionViewDataSource>
/* 建议只使用以下协议，不使用父类中的其他协议 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CarouselCollectionView : UICollectionView
@property (nonatomic, weak, nullable) IBOutlet id <CarouselCollectionViewDelegate> delegate;
@property (nonatomic, weak, nullable) IBOutlet id <CarouselCollectionViewDataSource> dataSource;

@property (nonatomic, assign) IBInspectable CGFloat duration;///< 自动滚动间隔（默认为0，不自动滚动）

/*
 已知在ios9.0的机型上，使用“@dynamic + IBOutlet id delegate;”有时会出问题，
 系统有时会不走@dynamic的设置器，从而代理对象会设置错误
 此时，请使用下面两各个代理连接所属ViewContriller，而不要使用UICollectionView自带的两个代理
 
@property (nonatomic, weak, nullable) id <CarouselCollectionViewDelegate> myDelegate;
@property (nonatomic, weak, nullable) id <CarouselCollectionViewDataSource> myDataSource;
 
 */
@end

NS_ASSUME_NONNULL_END
