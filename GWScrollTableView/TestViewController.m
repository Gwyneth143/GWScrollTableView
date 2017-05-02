//
//  TestViewController.m
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 2017/5/2.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import "TestViewController.h"
#import "SubViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController
//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagHeight:80])
    {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/4, 80);
    self.selectedTitleColor = [UIColor blueColor];
    self.selectedTitleFont = [UIFont systemFontOfSize:14];
    self.sliderColor = [UIColor blueColor];
    self.sliderSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/4, 4);
    self.normalTitleColor = [UIColor blackColor];
    self.normalTitleFont = [UIFont systemFontOfSize:14];
//    //    self.graceTime = 15;
//    //    self.gapAnimated = YES;
    self.view.backgroundColor = [UIColor whiteColor];
//
    NSArray *titleArray = @[
                            @"全部订单",
                            @"待支付",
                            @"已支付",
                            @"已完成"
                            ];
    NSArray *classNames = @[
                            [SubViewController class],
                            [SubViewController class],
                            [SubViewController class],
                            [SubViewController class]
                            ];
    NSArray *params = @[
                        @"0",
                        @"1",
                        @"2",
                        @"3"
                        ];
    [self reloadDataWithTags:titleArray subViewClasses:classNames WithParams:params];
    [self selectedIndexDisplayView:0 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
