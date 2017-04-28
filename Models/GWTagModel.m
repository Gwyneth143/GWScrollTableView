//
//  GWTagModel.m
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 17/4/28.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import "GWTagModel.h"

@implementation GWTagModel

+(GWTagModel *)modelWithTagTitle:(NSString *)title andNormalTitleFont:(UIFont *)normalTitleFont andSelectedTitleFont:(UIFont *)selectedTitleFont andNormalTitleColor:(UIColor *)normalTitleColor andSelectedTitleColor:(UIColor *)selectedTitleColor{
    GWTagModel * model = [[self alloc]init];
    model.tagTitle = title;
    model.normalTitleFont = normalTitleFont;
    model.selectedTitleFont = selectedTitleFont;
    model.normalTitleColor = normalTitleColor;
    model.selectedTitleColor = selectedTitleColor;
    return model;
}

@end
