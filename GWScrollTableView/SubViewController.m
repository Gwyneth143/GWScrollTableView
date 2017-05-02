//
//  SubViewController.m
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 2017/5/2.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import "SubViewController.h"

@interface SubViewController ()

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch ([_GWParam intValue]) {
        case 0:
            self.view.backgroundColor = [UIColor cyanColor];
            break;
        case 1:
            self.view.backgroundColor = [UIColor redColor];
            break;
        case 2:
            self.view.backgroundColor = [UIColor yellowColor];
            break;
        case 3:
            self.view.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
