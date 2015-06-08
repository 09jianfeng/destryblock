//
//  LevelDialogView+UsingAnimation.h
//  BasicClassLibrary
//
//  Created by DoubleZ on 13-11-14.
//  Copyright (c) 2013年 陈建峰. All rights reserved.
//

#import "LevelDialogView.h"
#import "CollectionViewCellLevel.h"
#import "CollectionViewControllerPlay.h"
#import "LevelAndUserInfo.h"
#import "GameResultData.h"

extern NSString *levelinfo;
extern NSString *levelinfoScore;
extern NSString *levelinfoTime;
extern NSString *levelinfoStarNum;
extern NSString *levelinfoWidthNum;
extern NSString *levelinfoColorNum;
extern NSString *playingViewExitNotification;

@interface LevelDialogView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property(nonatomic, assign) int count;
@property(nonatomic, assign) int cellImageNum;
@property(nonatomic, assign) NSArray *arrayGuanka;
@property(nonatomic, assign) int currentPage;
@end

@implementation LevelDialogView
- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initAndAddOtherSubview];
        _arrayGuanka = [[LevelAndUserInfo shareInstance] arrayLevelInfos];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingViewExitNotificationResponse:) name:playingViewExitNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:playingViewExitNotification object:nil];
}

#pragma mark -
#pragma mark 子视图
-(void)initAndAddOtherSubview{
    UIView* levelBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    levelBaseView.backgroundColor = [GameResultData getMainScreenBackgroundColor];
    levelBaseView.tag = 1000;
    [self addSubview:levelBaseView];
    
    int scrollViewInsertWidth = 30;
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewInsertWidth, 0, levelBaseView.bounds.size.width - scrollViewInsertWidth*2, levelBaseView.bounds.size.height *2 /3)];
    scrollview.pagingEnabled = YES;
    scrollview.scrollEnabled = YES;
    scrollview.bounces = YES;
    scrollview.clipsToBounds = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.scrollsToTop = NO;
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width *3, scrollview.frame.size.height);
    scrollview.contentOffset = CGPointMake(0, 0);
    scrollview.tag = 1100;
    scrollview.delegate = self;
    [levelBaseView addSubview:scrollview];
    
    UICollectionViewFlowLayout *collectionviewflow = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView* collectionViewLevel1 = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, scrollview.bounds.size.width-40, scrollview.bounds.size.height) collectionViewLayout:collectionviewflow];
    collectionViewLevel1.dataSource = self;
    collectionViewLevel1.delegate = self;
    collectionViewLevel1.backgroundColor = [UIColor clearColor];
    //注册CollectionViewCellLevell的identifier
    [collectionViewLevel1 registerClass:[CollectionViewCellLevel class] forCellWithReuseIdentifier:@"collectionidentiferLevel"];
    collectionViewLevel1.tag = 1110;
    [scrollview addSubview:collectionViewLevel1];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self diguiAnimation];
    });
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollview.bounds.size.height,  levelBaseView.bounds.size.width, 20)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.numberOfPages = 3;
    pageControl.tag = 1200;
    [levelBaseView addSubview:pageControl];
    
    int buttonBackSize = levelBaseView.frame.size.width/4.0;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(levelBaseView.frame.size.width/2-buttonBackSize/2, scrollview.frame.size.height + pageControl.frame.size.height*2,buttonBackSize, buttonBackSize)];
    button.backgroundColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    button.tag = 1300;
    button.layer.cornerRadius = buttonBackSize/2;
    [button addTarget:self action:@selector(buttonPressedGoback:) forControlEvents:UIControlEventTouchUpInside];
    [levelBaseView addSubview:button];
}

-(void)buttonPressedGoback:(id)sender{
    UIView *levelBaseView = (UIView *)[self viewWithTag:0];
    [UIView animateWithDuration:0.3 animations:^{
        levelBaseView.alpha = 0.0;
    } completion:^(BOOL isfinish){
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark UIScrollerView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    UIPageControl *pageview = (UIPageControl *)[self viewWithTag:1200];
    pageview.currentPage = page;
    self.currentPage = page;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UICollectionView *collection = (UICollectionView *)[self viewWithTag:1110];
    if (collection) {
        [collection removeFromSuperview];
    }
    
    _cellImageNum = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    UICollectionViewFlowLayout *collectionviewflow = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView* collectionViewLevel1 = [[UICollectionView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width*page + 20, 20, scrollView.bounds.size.width-40, scrollView.bounds.size.height - 40) collectionViewLayout:collectionviewflow];
    collectionViewLevel1.dataSource = self;
    collectionViewLevel1.delegate = self;
    collectionViewLevel1.backgroundColor = [UIColor clearColor];
    //注册CollectionViewCellLevell的identifier
    [collectionViewLevel1 registerClass:[CollectionViewCellLevel class] forCellWithReuseIdentifier:@"collectionidentiferLevel"];
    collectionViewLevel1.tag = 1110;
    [scrollView addSubview:collectionViewLevel1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self diguiAnimation];
    });
}

#pragma mark -
#pragma mark UICollection的代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionView *collectionViewLevel = (UICollectionView *)[self viewWithTag:1110];
    int ylen = collectionViewLevel.frame.size.height/4;
    int xlen = collectionViewLevel.frame.size.width/3;
    
    return CGSizeMake(xlen, ylen);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCellLevel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionidentiferLevel" forIndexPath:indexPath];
    
    NSDictionary *dicLevelInfos = [_arrayGuanka objectAtIndex:(indexPath.row * (self.currentPage +1))];
    int startNum = [[dicLevelInfos objectForKey:levelinfoStarNum] intValue];
    UIImage *imageclose = nil;
    UIColor *colorForItem = nil;
    if (startNum > 0) {
        imageclose = [UIImage imageNamed:@"guankaopen.png"];
        colorForItem = [GameResultData getUnLockColor];
    }else{
        imageclose = [UIImage imageNamed:@"guankaclose.png"];
        colorForItem = [GameResultData getLockColor];
    }
    
    int imageViewSize = cell.frame.size.width*3/4;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(collectionView.frame.size.width+cell.frame.origin.x, cell.frame.origin.y, imageViewSize, imageViewSize)];
    imageview.tag = 5000+indexPath.row;
    cell.tag = 6000+indexPath.row;
//    imageview.image = imageclose;
    imageview.layer.cornerRadius = imageViewSize/4;
    imageview.backgroundColor = colorForItem;
    [collectionView addSubview:imageview];
    return cell;
}

-(void)diguiAnimation{
    int tag = 5000+_cellImageNum;
    int celltag = 6000 + _cellImageNum;
    _cellImageNum++;
    UIImageView *imageview = (UIImageView*)[self viewWithTag:tag];
    UICollectionView *collectionview = (UICollectionView *)[self viewWithTag:1110];
    CollectionViewCellLevel *cell = (CollectionViewCellLevel *)[collectionview viewWithTag:celltag];
    int imageViewSize = cell.frame.size.width*3/4;
    if (imageview && cell) {
        [UIView animateWithDuration:0.05 animations:^{
            imageview.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, imageViewSize, imageViewSize);;
        } completion:^(BOOL isfinish){
            [imageview removeFromSuperview];
            imageview.frame = CGRectMake(0, 0, imageViewSize, imageViewSize);
            [cell addSubview:imageview];
            [self diguiAnimation];
        }];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    CollectionViewControllerPlay *collecPlay = [[CollectionViewControllerPlay alloc] initWithCollectionViewLayout:flowlayout];
    NSDictionary *dicLevels = [_arrayGuanka objectAtIndex:(indexPath.row * (self.currentPage +1))];
    //每一关的参数设置
    int timeLimit = [[dicLevels objectForKey:levelinfoTime] intValue];
    int widthNum = [[dicLevels objectForKey:levelinfoWidthNum] intValue];
    int colorNum = [[dicLevels objectForKey:levelinfoColorNum] intValue];
    
    collecPlay.timeLimit = timeLimit;
    collecPlay.gameLevelIndex = (int)indexPath.row;
    collecPlay.widthNum = widthNum;
    collecPlay.gameInitTypeNum = colorNum;
    
    [self.viewController addChildViewController:collecPlay];
    [self.viewController.view addSubview:collecPlay.view];
    collecPlay.view.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        collecPlay.view.alpha = 1.0;
    }];
}

#pragma mark - notification
-(void)playingViewExitNotificationResponse:(id)sender{
    UIScrollView *scrollview = (UIScrollView *)[self viewWithTag:1100];
    [self scrollViewDidEndDecelerating:scrollview];
}
@end
