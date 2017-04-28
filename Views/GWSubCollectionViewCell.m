//
//  GWSubCollectionViewCell.m
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 17/4/27.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import "GWSubCollectionViewCell.h"
#import "GWTagModel.h"
@implementation GWSubCollectionViewCell

- (void)createCellWithController:(UIViewController *)controller{
    controller.view.frame = self.bounds;
    [self.contentView addSubview:controller.view];
}

@end
