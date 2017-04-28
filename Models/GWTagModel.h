//
//  GWTagModel.h
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 17/4/28.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GWTagModel : NSObject

@property (nonatomic,copy) NSString * tagTitle;                //标签名
@property (nonatomic,strong) UIFont *normalTitleFont;      //正常(非选中)标签字体
@property (nonatomic,strong) UIFont *selectedTitleFont;    //选中状态标签字体

@property (nonatomic,strong) UIColor *normalTitleColor;   //正常(非选中)标签字体颜色
@property (nonatomic,strong) UIColor *selectedTitleColor; //选中状态标签字体颜色

+ (GWTagModel *)modelWithTagTitle:(NSString *)title
                    andNormalTitleFont:(UIFont *)normalTitleFont
                  andSelectedTitleFont:(UIFont *)selectedTitleFont
                   andNormalTitleColor:(UIColor *)normalTitleColor
                 andSelectedTitleColor:(UIColor *)selectedTitleColor;

@end
