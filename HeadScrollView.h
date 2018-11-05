//
//  HeadScrollView.h
//  exhibition
//
//  Created by 杨茂 on 2018/10/12.
//  Copyright © 2018年 exlink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HeadScrollViewDelegate <NSObject>

@optional
// 翻页
- (void)turnPageWithIndex:(NSInteger)index;

- (void)beginSelectedIndex:(NSInteger)index WithView:(UIView *)item;

- (void)endSelectedIndex:(NSInteger)index WithView:(UIView *)item;


@end

@interface HeadScrollView : UIScrollView

@property (nonatomic,weak) id<HeadScrollViewDelegate> hDeledate;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIColor *titleTintColor;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) CGFloat itemWidth;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,copy) NSArray *titleArray;
//- (instancetype)initWithTitleArray:(NSArray *)titleArray;

// 滑动page，head滑动
- (void)slideHeadWithIndex:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END
