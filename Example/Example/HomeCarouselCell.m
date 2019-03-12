//
//  HomeCarouselCell.m
//  FunTest
//
//  Created by 刘鹏i on 2019/3/12.
//  Copyright © 2019 Musjoy. All rights reserved.
//

#import "HomeCarouselCell.h"

@interface HomeCarouselCell ()
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;

@property (strong, nonatomic) IBOutlet UIImageView *imgTag;

@property (strong, nonatomic) IBOutlet UIImageView *imgBg;
@property (strong, nonatomic) IBOutlet UIView *viewImg;
@property (strong, nonatomic) IBOutlet UIImageView *imgRight;
@end

static UIImage *gifImage = nil;

@implementation HomeCarouselCell
- (void)configCellWithData:(NSDictionary *)dict
{
    _viewImg.hidden = YES;
    
    NSString *typeIndex = dict[@"typeIndex"];
    _imgBg.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_moude%@_top", typeIndex]];
    _imgTag.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_moude%@_tag", typeIndex]];
}


@end
