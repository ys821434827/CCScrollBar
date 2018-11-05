//
//  HeadScrollView.m
//  exhibition
//
//  Created by 杨茂 on 2018/10/12.
//  Copyright © 2018年 exlink. All rights reserved.
//

#import "HeadScrollView.h"

@interface HeadScrollView ()

//@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *buttonArray;// 按钮组
@property (nonatomic,strong) UIView *bottomLine;// 指示线

@end

@implementation HeadScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureProcess:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapGestureProcess:(UITapGestureRecognizer *)sender{

    CGPoint point = [sender locationInView:self];
    NSInteger index = point.x/_itemWidth;
    [self changeSelectedIndex:index withAnimation:true];
    
    // page翻页
    if (self.hDeledate && [self.hDeledate respondsToSelector:@selector(turnPageWithIndex:)]) {
        [self.hDeledate turnPageWithIndex:index];
    }
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self setUpSubViews];
}

- (void)setUpSubViews{
    NSArray *subviews = self.buttonArray;
    for (int i = 0; i<subviews.count; i++) {
        UIView *view = subviews[i];
        [view removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    [_bottomLine removeFromSuperview];
    
    self.contentSize = CGSizeMake(_itemWidth*self.titleArray.count, self.bounds.size.height);
    [self.titleArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(idx*_itemWidth, 0, _itemWidth, self.bounds.size.height)];
        title.font = [UIFont systemFontOfSize:13];
        title.textAlignment = NSTextAlignmentCenter;
        title.numberOfLines = 2;
        if (idx==_selectedIndex) {
            title.textColor = _titleTintColor;
            
            if (self.hDeledate && [self.hDeledate respondsToSelector:@selector(beginSelectedIndex:WithView:)]) {
                [self.hDeledate beginSelectedIndex:_selectedIndex WithView:title];
            }
        }
        else{
            title.textColor = _titleColor;
        }
        title.text = obj;
        [self.buttonArray addObject:title];
        [self addSubview:title];
        
    }];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = _lineColor ? _lineColor: _titleTintColor;
    [self addSubview:self.bottomLine];
    self.bottomLine.frame = CGRectMake(0, self.bounds.size.height-2, _itemWidth, 2);
}

#pragma mark -- action

- (void)buttonClick:(UIButton *)sender{
    // 指示线移动
    NSInteger index = [self.buttonArray indexOfObject:sender];
    self.bottomLine.frame = CGRectMake(_itemWidth*index, self.bounds.size.height-2, _itemWidth, 2);
    // 标题改颜色
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:_titleColor forState:(UIControlStateNormal)];
    }];
    [sender setTitleColor:_titleTintColor forState:(UIControlStateNormal)];
    // page翻页
    if (self.hDeledate && [self.hDeledate respondsToSelector:@selector(turnPageWithIndex:)]) {
        [self.hDeledate turnPageWithIndex:[self.buttonArray indexOfObject:sender]];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    [self changeSelectedIndex:selectedIndex withAnimation:YES];
}

- (void)changeSelectedIndex:(NSInteger)index withAnimation:(BOOL)yesorno{
    // 指示线移动
    if (index!=_selectedIndex) {
        if (yesorno) {
            // 标题改颜色
            UILabel *preSelectedLab = [self.buttonArray objectAtIndex:_selectedIndex];
            UILabel *selectedLab = [self.buttonArray objectAtIndex:index];
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomLine.frame = CGRectMake(_itemWidth*index, self.bounds.size.height-2, _itemWidth, 2);
                preSelectedLab.textColor = _titleColor;
                selectedLab.textColor = _titleTintColor;
            }];
            
            if (self.hDeledate && [self.hDeledate respondsToSelector:@selector(endSelectedIndex:WithView:)]) {
                [self.hDeledate endSelectedIndex:_selectedIndex WithView:preSelectedLab];
            }
            
            _selectedIndex = index;
            
            if (self.hDeledate && [self.hDeledate respondsToSelector:@selector(beginSelectedIndex:WithView:)]) {
                [self.hDeledate beginSelectedIndex:index WithView:selectedLab];
            }
            
        }
        else{
            // 标题改颜色
            UILabel *preSelectedLab = [self.buttonArray objectAtIndex:_selectedIndex];
            UILabel *selectedLab = [self.buttonArray objectAtIndex:index];
            self.bottomLine.frame = CGRectMake(_itemWidth*index, self.bounds.size.height-2, _itemWidth, 2);
            preSelectedLab.textColor = _titleColor;
            selectedLab.textColor = _titleTintColor;
            
            if (self.hDeledate && [self.hDeledate respondsToSelector:@selector(endSelectedIndex:WithView:)]) {
                [self.hDeledate endSelectedIndex:_selectedIndex WithView:preSelectedLab];
            }
            
            _selectedIndex = index;
            
            if (self.hDeledate && [self.hDeledate respondsToSelector:@selector(beginSelectedIndex:WithView:)]) {
                [self.hDeledate beginSelectedIndex:index WithView:selectedLab];
            }
            
        }
    }
    [self changeVisableViewWithSelectedIndex];
    
    
}

// 滑动page，head滑动
- (void)slideHeadWithIndex:(NSInteger)index{
    // 指示线移动
    UIButton *tempButton = self.buttonArray[index];
//    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(kScale(42), 2));
//        make.centerX.equalTo(tempButton);
//        make.top.equalTo(tempButton.mas_bottom);
//    }];
    self.bottomLine.frame = CGRectMake(_itemWidth*index, self.bounds.size.height-2, _itemWidth, 2);
    // 标题改颜色
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:_titleColor forState:(UIControlStateNormal)];
    }];
    [tempButton setTitleColor:_titleTintColor forState:(UIControlStateNormal)];
}

- (void)changeVisableViewWithSelectedIndex{
   
    CGFloat size = self.contentSize.width;
    if (size<=self.bounds.size.width) {
        return;
    }
    CGFloat x = _itemWidth*_selectedIndex;
    CGFloat offsetx = self.contentOffset.x;
    CGFloat trailDis = offsetx+self.bounds.size.width-x;
    CGFloat leadDis = x-offsetx;
    CGFloat newOffsetx = offsetx;
    if (trailDis/_itemWidth<=2||fabs(leadDis/_itemWidth)<=2) {
        newOffsetx = x-self.bounds.size.width/2;
        if (x+self.bounds.size.width/2>=self.contentSize.width) {
            newOffsetx = self.contentSize.width-self.bounds.size.width;
        }
        else if(newOffsetx<=0){
            newOffsetx = 0;
        }
    }
    
    [self setContentOffset:CGPointMake(newOffsetx, 0) animated:true];
}

#pragma mark -- 懒加载

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

@end

