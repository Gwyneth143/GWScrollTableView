//
//  GWTagCollectionViewCell.m
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 17/4/27.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import "GWTagCollectionViewCell.h"

@implementation GWTagCollectionViewCell

#pragma mark -- 初始化
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}
#pragma mark -- 设置Tag标签的高
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.titleLabel.font =_model.selectedTitleFont;
        self.titleLabel.textColor = _model.selectedTitleColor;
    }else
    {
        self.titleLabel.font = _model.normalTitleFont;
        self.titleLabel.textColor = _model.normalTitleColor;
    }}
#pragma mark -- 标签被选中
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = _model.selectedTitleFont;
        self.titleLabel.textColor = _model.selectedTitleColor;
    }else
    {
        self.titleLabel.font = _model.normalTitleFont;
        self.titleLabel.textColor = _model.normalTitleColor;
    }
}
#pragma mark -- 设置模型数值
- (void)setModel:(GWTagModel *)model
{
    _model = model;
    [self updateUI];
}
#pragma mark -- 更新视图UI
- (void)updateUI
{
    self.titleLabel.text = _model.tagTitle;
    self.titleLabel.font = _model.normalTitleFont;
    self.titleLabel.textColor = _model.normalTitleColor;
}
#pragma mark -- 视图适配
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}


@end
