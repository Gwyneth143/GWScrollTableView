//
//  GWScrollTableViewController.h
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 17/4/26.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWScrollTableViewController : UIViewController

@property (nonatomic,strong) UIFont * normalTitleFont;//正常状态，标签的字体
@property (nonatomic,strong) UIFont * selectedTitleFont;//被选中状态，标签字体

@property (nonatomic,strong) UIColor * normalTitleColor;//正常状态，标签字体
@property (nonatomic,strong) UIColor * selectedTitleColor;//被选中状态，标签字体

@property (nonatomic,strong) UIColor * sliderColor;//滑动条颜色

@property (nonatomic,assign) CGSize sliderSize;//滑动条大小

@property (nonatomic,assign) CGSize tagItemSize;//标签大小

@property (nonatomic,assign) NSTimeInterval cacheTime;//缓存时间间隔

@property (nonatomic,assign) BOOL gapAnimated;//是否开启动画


//初始化设置标签高度
-(instancetype)initWithTagHeight:(CGFloat)height;
//加载数据带参数
-(void)reloadDataWithTags:(NSArray *)tags subViewClasses:(NSArray *)classes;
//加载数据不带参数
-(void)reloadDataWithTags:(NSArray *)tags subViewClasses:(NSArray *)classes WithParams:(NSArray *)params;
//选中某个界面
-(void)selectedIndexDisplayView:(NSInteger)index animated:(BOOL)isAnimated;


@end
