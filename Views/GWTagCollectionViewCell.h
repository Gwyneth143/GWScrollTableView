//
//  GWTagCollectionViewCell.h
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 17/4/27.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWTagModel.h"

@interface GWTagCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property(nonatomic,strong)GWTagModel * model;

@end
