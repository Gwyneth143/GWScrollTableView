//
//  GWScrollTableViewController.m
//  GWScrollTableView
//
//  Created by Gwyneth Gan on 17/4/26.
//  Copyright © 2017年 Gwyneth. All rights reserved.
//

#import "GWScrollTableViewController.h"
#import "GWSubCollectionViewCell.h"
#import "GWTagCollectionViewCell.h"
#import "GWTagModel.h"

#define GWTagCellResuseIdentifier @"GWTagCollectionViewCellIdentifier"
#define GWViewCellResuseIdentifier @"GWViewCollectionViewCellIdentifier"
#define GWControllerCache @"GWControllerCacheName"
#define GWCacheDate @"GWCacheDate"

@interface GWScrollTableViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,assign) CGFloat tagItemHeight; //标签高度
@property (nonatomic,strong) UICollectionView * tagCollectionView;//标签区域
@property (nonatomic,strong) UICollectionView * viewCollectionView;//子视图展示区域
@property (nonatomic,strong) NSMutableArray * tagsTitle;//标签标题
@property (nonatomic,assign) NSInteger selectedIndex;//被选中的视图下标
@property (nonatomic,strong) NSArray * subViews;//子视图
@property (nonatomic,strong) NSMutableDictionary * controllerCache;//试图控制器缓存
@property (nonatomic,strong) NSMutableDictionary * sizeCache;//size缓存
@property (nonatomic,strong) NSArray * params;//参数
@property (nonatomic,strong) NSTimer * Timer;//缓存时间器
@property (nonatomic,strong) UIView * sliderView;//滑动指示器

@end

@implementation GWScrollTableViewController

#pragma mark -- 构造便利器，设置标签高
-(instancetype)initWithTagHeight:(CGFloat)height{
    if (self == [super init]) {
        _tagItemHeight = height;
        [self setDefaultProperity];
        [self createSubViewControllers];
    }
    return self;
}
#pragma mark -- 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.tagsTitle.count!=0) {
        [self resetSelectedIndex];
    }
}
#pragma mark -- 视图布局调整
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tagCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.tagItemHeight);
    self.viewCollectionView.frame = CGRectMake(0, self.tagItemHeight, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - self.tagItemHeight);
}
#pragma mark -- 视图销毁
- (void)dealloc
{
    if (self.Timer != 0) {
        [self.Timer invalidate];
        self.Timer = nil;
    }
}
#pragma mark -- 初始化相关属性
-(void)setDefaultProperity{
    //标签正常的字体
    self.normalTitleFont = [UIFont systemFontOfSize:14];
    //标签被选中的字体
    self.selectedTitleFont = [UIFont systemFontOfSize:16];
    //标签正常情况下的字体颜色
    self.normalTitleColor = [UIColor darkGrayColor];
    //标签被选中状态下的字体颜色
    self.selectedTitleColor = [UIColor redColor];
    //滑动条颜色
    self.sliderColor = [UIColor redColor];
    //标签大小
    self.tagItemSize = CGSizeZero;
    //    self.tagItemGap = 10.f;
    //被选中的标签下标
    self.selectedIndex = -1;
}
#pragma mark -- 创建标签视图区域和子视图区域
-(void)createSubViewControllers{
    //初始化标签布局
    UICollectionViewFlowLayout *tagFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    tagFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    tagFlowLayout.minimumLineSpacing = 0;
    tagFlowLayout.minimumInteritemSpacing = 0;
    
    //初始化标签CollectionView
    _tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:tagFlowLayout];
    [_tagCollectionView registerClass:[GWTagCollectionViewCell class] forCellWithReuseIdentifier:GWTagCellResuseIdentifier];
    _tagCollectionView.backgroundColor = [UIColor whiteColor];
    _tagCollectionView.showsHorizontalScrollIndicator = NO;
    _tagCollectionView.dataSource = self;
    _tagCollectionView.delegate = self;
    [self.view addSubview:_tagCollectionView];
    
    //初始化页面布局
    UICollectionViewFlowLayout *viewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    viewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    viewFlowLayout.minimumLineSpacing = 0;
    viewFlowLayout.minimumInteritemSpacing = 0;
    
    //初始化页面CollectionView
    _viewCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:viewFlowLayout];
    [_viewCollectionView registerClass:[GWSubCollectionViewCell class] forCellWithReuseIdentifier:GWViewCellResuseIdentifier];
    _viewCollectionView.backgroundColor = [UIColor whiteColor];
    _viewCollectionView.showsHorizontalScrollIndicator = NO;
    _viewCollectionView.dataSource = self;
    _viewCollectionView.delegate = self;
    _viewCollectionView.pagingEnabled = YES;
    [self.view addSubview:_viewCollectionView];
}
#pragma mark -- delegateForCollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _tagsTitle.count != 0?_tagsTitle.count:0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //标签视图
    if (collectionView == _tagCollectionView) {
        GWTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:GWTagCellResuseIdentifier forIndexPath:indexPath];
        GWTagModel * model = _tagsTitle[indexPath.item];
        cell.model = model;
        [cell setSelected:(NSInteger)_selectedIndex == (NSInteger)indexPath.item ? YES:NO];
        cell.backgroundColor = self.view.backgroundColor;
        return cell;
    }
    //子页面视图
    else{
        GWSubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GWViewCellResuseIdentifier forIndexPath:indexPath];
        //更新页面状态
        Class displayClass = (self.subViews.count == 1)?[self.subViews firstObject]:self.subViews[indexPath.item];
        //获取缓存视图控制器
        UIViewController *cacheController = [self getCachedVCByIndexPath:indexPath];
        if(!cacheController){
            cacheController = [[displayClass alloc]init];
        }
        if (self.params.count != 0) {
            if (![cacheController valueForKeyPath:@"GWParam"]) {
                [cacheController setValue:self.params[indexPath.item] forKeyPath:@"GWParam"];
            }
        }
        [self addChildViewController:cacheController];
        [cell createCellWithController:cacheController];
        return cell;
    }
    return nil;
}
#pragma mark - UICollectionViewDelegateFlowLayout Protocol Methods
//sizeForItemAtIndexPath 只调用一次,一次性计算所有cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    GWTagModel * model = _tagsTitle[indexPath.item];
     if (collectionView == _tagCollectionView) {//标签
        if (CGSizeEqualToSize(CGSizeZero, self.tagItemSize)) { //如果用户没有手动设置tagItemSize
            CGSize titleSize = [self sizeForTitle:model.tagTitle withFont:((model.normalTitleFont.pointSize >= model.selectedTitleFont.pointSize)?model.normalTitleFont:model.selectedTitleFont)];
            return CGSizeMake(titleSize.width, _tagItemHeight);  //+ self.tagItemGap * 0.5
        }else
        {
            return self.tagItemSize;
        }
        
    }else
    {
        return collectionView.frame.size;
    }
}
#pragma mark - UICollectionViewDelegate Protocol Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == _tagCollectionView) {                     //选中某个标签
        [collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:YES];
        
        NSInteger gap = indexPath.item - _selectedIndex;
        
        self.selectedIndex = indexPath.item;
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (!cell) {
            if ([self isZeroSize:_tagItemSize]) {//是否手动设置了大小
                GWTagModel * model = _tagsTitle[0];
                CGSize tagSize = [self sizeForTitle:model.tagTitle withFont:((model.normalTitleFont.pointSize >= model.selectedTitleFont.pointSize)?model.normalTitleFont:model.selectedTitleFont)];
                CGRect frame = _sliderView.frame;
                frame.size.width = tagSize.width;
                _sliderView.frame = frame;
            }else
            {
                CGRect frame = _sliderView.frame;
                frame.size.width = _tagItemSize.width;
                _sliderView.frame = frame;
            }
        }
        else if(self.sliderView.center.x != cell.center.x) {
            //             [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            //                 [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            //                     self.selectionIndicator.x = cell.x;
            //                 }];
            //
            //                 [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            //                     self.selectionIndicator.width = cell.width;
            //                 }];
            //
            //             } completion:^(BOOL finished) {
            //
            //             }];
            
        }
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.viewCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:labs(gap)>1?_gapAnimated:YES];
        [self.viewCollectionView reloadData];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _tagCollectionView) {          //tag，无需考虑缓存
        
    }
    else{                                               //page
        //从缓存中取出instaceController
        UIViewController *cachedViewController = [self getCachedVCByIndexPath:indexPath];
        if (!cachedViewController) {
            return;
        }
        //更新缓存时间
        [self saveCachedVC:cachedViewController ByIndexPath:indexPath];
        //从父控制器中移除
        [cachedViewController removeFromParentViewController];
        [cachedViewController.view removeFromSuperview];
    }
}
#pragma - mark UIScrollerViewDelegate
- (void)scrollViewDidEndDecelerating:(UICollectionView *)scrollView
{
    if (scrollView == self.viewCollectionView) {
        [scrollView reloadData];
        int index = scrollView.contentOffset.x / self.viewCollectionView.frame.size.width;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self collectionView:self.tagCollectionView didSelectItemAtIndexPath:indexPath];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.viewCollectionView) {
        if (![self isZeroSize:self.tagItemSize]) {
            CGRect frame = _sliderView.frame;
            frame.origin.x = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width) * _tagItemSize.width;
            _sliderView.frame = frame;
        }
    }
}
#pragma - mark publicMethod
- (void)reloadDataWithTags:(NSArray *)tags subViewClasses:(NSArray *)classes
{
    [self convertKeyValue2Model:tags];
    self.subViews = classes;
    [self.tagCollectionView reloadData];
    [self.viewCollectionView reloadData];
    
    [self resetSelectedIndex];
    
}
- (void)reloadDataWithTags:(NSArray *)tags subViewClasses:(NSArray *)classes WithParams:(NSArray *)params
{
    [self convertKeyValue2Model:tags];
    self.subViews = classes;
    [self.tagCollectionView reloadData];
    [self.viewCollectionView reloadData];
    self.params = params;
    [self resetSelectedIndex];
}

-(void)selectedIndexDisplayView:(NSInteger)index animated:(BOOL)isAnimated
{
    self.selectedIndex = index;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tagCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:isAnimated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        [self.viewCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:isAnimated];    });
}
- (void)resetSelectedIndex
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self collectionView:self.tagCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
}

- (void)updateViewControllersCaches
{
    NSDate *currentDate = [NSDate date];
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *tempDic = self.controllerCache;
    [self.controllerCache enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSDictionary *obj, BOOL *stop) {
        UIViewController *vc = [obj objectForKey:GWControllerCache];
        NSDate *cachedTime = [obj objectForKey:GWCacheDate];
        NSInteger keyInteger = [key integerValue];
        NSInteger selectionInteger = weakSelf.selectedIndex;
        
        if (keyInteger != selectionInteger) {         //当前不是当前正在展示的cell
            NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:cachedTime];
            if (timeInterval >= weakSelf.cacheTime) {
                //宽限期到了销毁控制器
                [tempDic removeObjectForKey:key];
                [vc.view removeFromSuperview];
                [vc removeFromParentViewController];
            }
        }
    }];
    self.controllerCache = tempDic;
}

- (void)convertKeyValue2Model:(NSArray *)titleArray
{
    [_tagsTitle removeAllObjects];
    for (int i = 0; i < titleArray.count; i++) {
        GWTagModel * model = [GWTagModel modelWithTagTitle:titleArray[i] andNormalTitleFont:self.normalTitleFont andSelectedTitleFont:self.selectedTitleFont andNormalTitleColor:self.normalTitleColor andSelectedTitleColor:self.selectedTitleColor];
        [_tagsTitle addObject:model];
    }
}

- (UIViewController *)getCachedVCByIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cachedDic = [self.controllerCache objectForKey:@(indexPath.item)];
    UIViewController *cachedViewController = [cachedDic objectForKey:GWControllerCache];
    return cachedViewController;
}
- (void)saveCachedVC:(UIViewController *)viewController ByIndexPath:(NSIndexPath *)indexPath
{
    NSDate *newTime =[NSDate date];
    NSDictionary *newCacheDic = @{GWCacheDate:newTime,
                                  GWControllerCache:viewController};
    [self.controllerCache setObject:newCacheDic forKey:@(indexPath.item)];
    
}
- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}
- (BOOL)isZeroSize:(CGSize)size
{
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        return YES;
    }
    return NO;
}
#pragma - mark getter&setter
- (NSMutableArray *)tagsTitle
{
    if (!_tagsTitle) {
        _tagsTitle = [NSMutableArray arrayWithCapacity:0];
    }
    return _tagsTitle;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.tagCollectionView.backgroundColor = backgroundColor;
}
- (NSMutableDictionary *)controllerCache
{
    if (!_controllerCache) {
        _controllerCache = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _controllerCache;
}
- (void)setCacheTime:(NSTimeInterval)cacheTime
{
    _cacheTime = cacheTime;
    [self.cacheTimer setFireDate:[NSDate distantPast]];
}
- (NSTimer *)cacheTimer
{
    if (self.Timer) {
        if (!_Timer) {
            _Timer = [NSTimer timerWithTimeInterval:5.f target:self selector:@selector(updateViewControllersCaches) userInfo:nil repeats:YES];
            [_Timer setFireDate:[NSDate distantFuture]];
            [[NSRunLoop mainRunLoop] addTimer:_Timer forMode:NSDefaultRunLoopMode];
        }
        return _Timer;
    }
    return nil;
}
- (NSMutableDictionary *)sizeCache
{
    if (!_sizeCache) {
        _sizeCache = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _sizeCache;
}

- (UIView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[UIView alloc]init];
        _sliderView.backgroundColor = [UIColor clearColor];
        
        //1.使用固定的tagItemSize
        if (![self isZeroSize:_tagItemSize]) {
            if ([self isZeroSize:_sliderSize]) { //如果未手动设定指示条宽高,则设置默认值
                _sliderSize = CGSizeMake(self.tagItemSize.width, 2);
            }
            _sliderView.frame = CGRectMake(0, _tagItemHeight - _sliderSize.height, _tagItemSize.width, _sliderSize.height);
        }
        //2.使用自由文本宽度,默认设为第一个自由文本的size
        else{
            GWTagModel * model = _tagsTitle[0];
            CGSize tagSize = [self sizeForTitle:model.tagTitle withFont:((model.normalTitleFont.pointSize >= model.selectedTitleFont.pointSize)?model.normalTitleFont:model.selectedTitleFont)];
            
            if ([self isZeroSize:_sliderSize]) { //如果未手动设定指示条宽高,则设置默认值
                _sliderSize = CGSizeMake(tagSize.width, 8);
            }
            _sliderView.frame = CGRectMake(0, _tagItemHeight - _sliderSize.height, tagSize.width, _sliderSize.height);
        }
        
        UIView *sub = [[UIView alloc]init];
        sub.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        sub.backgroundColor = _sliderColor;
        sub.frame = CGRectMake(0, 0, _sliderSize.width, _sliderSize.height);
        CGPoint point = sub.center;
        point.x = _sliderView.center.x;
        sub.center = point;
        [_sliderView addSubview:sub];
        [self.tagCollectionView addSubview:_sliderView];
    }
    return _sliderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
