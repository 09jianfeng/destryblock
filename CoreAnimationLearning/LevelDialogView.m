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
#import "GameDataGlobal.h"
#import "SystemInfo.h"

#define PAGENUM 5

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
    levelBaseView.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
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
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width *PAGENUM, scrollview.frame.size.height);
    scrollview.contentOffset = CGPointMake(0, 0);
    scrollview.tag = 1100;
    scrollview.delegate = self;
    [levelBaseView addSubview:scrollview];
    
    UICollectionViewFlowLayout *collectionviewflow = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView* collectionViewLevel1 = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, scrollview.bounds.size.width-40, scrollview.bounds.size.height - 40) collectionViewLayout:collectionviewflow];
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
    pageControl.numberOfPages = PAGENUM;
    pageControl.tag = 1200;
    [levelBaseView addSubview:pageControl];
    
    int legth = (collectionViewLevel1.frame.size.width/3) < (collectionViewLevel1.frame.size.height/4)? (collectionViewLevel1.frame.size.width/3):(collectionViewLevel1.frame.size.height/4);
    legth = legth*3/4;
    if (IsPadUIBlockGame()) {
        legth = legth*2/3;
    }
    int buttonQuiteSize =legth;
    UIButton *buttonQuiteGame = [[UIButton alloc] initWithFrame:CGRectMake(levelBaseView.frame.size.width/2-buttonQuiteSize, scrollview.frame.size.height + pageControl.frame.size.height*2 + buttonQuiteSize/5,buttonQuiteSize*2, buttonQuiteSize)];
    buttonQuiteGame.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:181.0/255.0 blue:180.0/255.0 alpha:1.0];
    [buttonQuiteGame setTitle:@"经典模式" forState:UIControlStateNormal];
    [buttonQuiteGame setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    buttonQuiteGame.layer.cornerRadius = buttonQuiteSize/4;
    [levelBaseView addSubview:buttonQuiteGame];
    
    int buttonBackSize = (self.frame.size.height - buttonQuiteGame.frame.origin.y - buttonQuiteGame.frame.size.height)/2;
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(levelBaseView.frame.size.width/2-buttonBackSize/2, buttonQuiteGame.frame.origin.y + buttonQuiteGame.frame.size.height + buttonBackSize/2,buttonBackSize, buttonBackSize)];
    [buttonBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    buttonBack.tag = 1300;
    buttonBack.layer.cornerRadius = buttonBackSize/2;
    [buttonBack addTarget:self action:@selector(buttonPressedGoback:) forControlEvents:UIControlEventTouchUpInside];
    [levelBaseView addSubview:buttonBack];
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
    self.currentPage = page >= PAGENUM ? PAGENUM : page ;
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
    
    NSDictionary *dicLevelInfos = [_arrayGuanka objectAtIndex:(indexPath.row + self.currentPage*12)];
    int startNum = [[dicLevelInfos objectForKey:levelinfoStarNum] intValue];
    int levelPoints = [[dicLevelInfos objectForKey:levelinfoScore] intValue];
    UIImage *imageclose = nil;
    UIColor *colorForItem = nil;
    if (levelPoints > 0) {
        imageclose = [UIImage imageNamed:@"lockOpen.png"];
        colorForItem = [UIColor whiteColor];
    }else{
        imageclose = [UIImage imageNamed:@"lockClose.png"];
        colorForItem = [UIColor grayColor];
    }
    
    {//锁上面的视图
        int legth = cell.frame.size.width < cell.frame.size.height?cell.frame.size.width:cell.frame.size.height;
        legth = legth*3/4;
        if (IsPadUIBlockGame()) {
            legth = legth*2/3;
        }
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(collectionView.frame.size.width+cell.frame.origin.x, cell.frame.origin.y, legth, legth)];
        baseView.tag = 5000+indexPath.row;
        cell.tag = 6000+indexPath.row;
        baseView.layer.cornerRadius = legth/4;
        baseView.backgroundColor = colorForItem;
        [collectionView addSubview:baseView];
        
        int imageViewSize = legth;
        UIImageView *imageViewLock = [[UIImageView alloc] initWithImage:imageclose];
        imageViewLock.frame = CGRectMake(legth/2 - imageViewSize/2, 0, imageViewSize, imageViewSize);
        [baseView addSubview:imageViewLock];
        
        int startInsert = 3;
        int startSize = (legth - startInsert*4)/3;
        UIImage *imageStart = nil;
        for (int i = 0; i < 3; i++) {
            if (startNum > 0) {
               imageStart = [UIImage imageNamed:@"result_star"];
                startNum--;
            }else{
                imageStart = [UIImage imageNamed:@"result_star_2"];
            }
            
            UIImageView *imageViewStar = [[UIImageView alloc] initWithImage:imageStart];
            imageViewStar.frame = CGRectMake(startInsert*(i+1) + startSize*i, imageViewSize, startSize, startSize);
            [baseView addSubview:imageViewStar];
        }
        
        UILabel *uilabelSerial = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewSize+startSize, legth, cell.frame.size.height - imageViewSize - startSize)];
        uilabelSerial.font = [UIFont systemFontOfSize:12];
        if (IsPadUIBlockGame()) {
            uilabelSerial.font = [UIFont systemFontOfSize:22];
        }
        uilabelSerial.textColor = [UIColor whiteColor];
        uilabelSerial.text = [NSString stringWithFormat:@"%td",12*self.currentPage + indexPath.row+1];
        uilabelSerial.textAlignment = NSTextAlignmentCenter;
        [baseView addSubview:uilabelSerial];
    }
    
    return cell;
}

-(void)diguiAnimation{
    int tag = 5000+_cellImageNum;
    int celltag = 6000 + _cellImageNum;
    _cellImageNum++;
    UIImageView *imageview = (UIImageView*)[self viewWithTag:tag];
    UICollectionView *collectionview = (UICollectionView *)[self viewWithTag:1110];
    CollectionViewCellLevel *cell = (CollectionViewCellLevel *)[collectionview viewWithTag:celltag];
    int legth = cell.frame.size.width < cell.frame.size.height?cell.frame.size.width:cell.frame.size.height;
    legth = legth*3/4;
    if (IsPadUIBlockGame()) {
        legth = legth*2/3;
    }
    
    if (imageview && cell) {
        [UIView animateWithDuration:0.05 animations:^{
            imageview.frame = CGRectMake(cell.frame.origin.x+(cell.frame.size.width-legth)/2, cell.frame.origin.y, legth, legth);
        } completion:^(BOOL isfinish){
            [imageview removeFromSuperview];
            imageview.frame = CGRectMake((cell.frame.size.width-legth)/2,0, legth, legth);
            [cell addSubview:imageview];
            [self diguiAnimation];
        }];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    CollectionViewControllerPlay *collecPlay = [[CollectionViewControllerPlay alloc] initWithCollectionViewLayout:flowlayout];
    NSDictionary *dicLevels = [_arrayGuanka objectAtIndex:(indexPath.row + self.currentPage*12)];
    //每一关的参数设置
    int widthNum = [[dicLevels objectForKey:levelinfoWidthNum] intValue];
    int colorNum = [[dicLevels objectForKey:levelinfoColorNum] intValue];
    
    collecPlay.gameLevelIndex = (int)indexPath.row + self.currentPage*12;
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
