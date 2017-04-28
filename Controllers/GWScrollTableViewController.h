//
//  GWScrollTableViewController.h
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 17/4/26.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWScrollTableViewController : UIViewController

@property (nonatomic,strong) UIFont * normalTitleFont;
@property (nonatomic,strong) UIFont * selectedTitleFont;

@property (nonatomic,strong) UIColor * normalTitleColor;
@property (nonatomic,strong) UIColor * selectedTitleColor;

@property (nonatomic,strong) UIColor * sliderColor;

@property (nonatomic,assign) CGSize sliderSize;

@property (nonatomic,assign) CGSize tagItemSize;

@property (nonatomic,assign) NSTimeInterval cacheTime;

@property (nonatomic,assign) BOOL gapAnimated;


-(instancetype)initWithTagHeight:(CGFloat)height;
-(void)reloadDataWithTags:(NSArray *)tags subViewClasses:(NSArray *)classes;
-(void)reloadDataWithTags:(NSArray *)tags subViewClasses:(NSArray *)classes WithParams:(NSArray *)params;
-(void)selectedIndexDisplayView:(NSInteger)index animated:(BOOL)isAnimated;


@end
