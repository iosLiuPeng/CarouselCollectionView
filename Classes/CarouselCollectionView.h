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
 ⚠️ ipod机型上有严重BUG ⚠️
 已知在ipod机型上，设置dataSource代理时，不会走当前view的numberOfItemsInSection方法。
 1.只有dataSource会出问题，delegate是正常的
 2.和设置delegate = self、dataSource = self的顺序无关
 3.只有走numberOfItemsInSection方法时，dataSource的代理对象是错误的，之后执行cellForItemAtIndexPath方法时代理对象恢复正常
 
 如果需要考虑ipod机型：
 1.注释上面的delegate、dataSource属性
 2.使用下面的carouselDelegate、carouselDataSource（取消注释）
 3.注释.m文件中的carouselDelegate、carouselDataSource
 4.注释.m文件中的delegate、dataSource的设置器和访问器方法
 5.xib、sb中连接代理对象时，使用carouselDelegate、carouselDataSource，不使用delegate、dataSource
*/
//@property (nonatomic, weak, nullable) IBOutlet id <CarouselCollectionViewDelegate> carouselDelegate;
//@property (nonatomic, weak, nullable) IBOutlet id <CarouselCollectionViewDataSource> carouselDataSource;


@end

NS_ASSUME_NONNULL_END
