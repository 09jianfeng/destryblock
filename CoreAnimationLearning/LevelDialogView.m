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

@interface LevelDialogView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property(nonatomic, retain) UIDynamicAnimator *theAnimator;
@end

@implementation LevelDialogView
- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initAndAddOtherSubview];
    }
    return self;
}

-(void)dealloc{
    [self.theAnimator removeAllBehaviors];
    self.theAnimator = nil;
}

#pragma mark -
#pragma mark 子视图
-(void)initAndAddOtherSubview{
    UIView* levelBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height*0.8, self.frame.size.width*0.8, self.frame.size.height*0.8)];
    levelBaseView.backgroundColor = [UIColor colorWithRed:0.44 green:0.58 blue:0.91 alpha:1.0];
    levelBaseView.center = CGPointMake(self.frame.size.width/2, 0);
    levelBaseView.layer.cornerRadius = 10.0;
    levelBaseView.layer.masksToBounds = YES;
    levelBaseView.tag = 1000;
    [self addSubview:levelBaseView];
    
    self.theAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[levelBaseView]];
    [self.theAnimator addBehavior:gravityBehaviour];
    
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:levelBaseView attachedToAnchor:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [attachmentBehavior setLength:0];
    [attachmentBehavior setDamping:0.3];
    [attachmentBehavior setFrequency:3];
    [self.theAnimator addBehavior:attachmentBehavior];
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, levelBaseView.bounds.size.width, levelBaseView.bounds.size.height-50)];
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
    UICollectionView* collectionViewLevel1 = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, levelBaseView.bounds.size.width-40, scrollview.bounds.size.height - 40) collectionViewLayout:collectionviewflow];
    collectionViewLevel1.dataSource = self;
    collectionViewLevel1.delegate = self;
    collectionViewLevel1.backgroundColor = [UIColor clearColor];
    //注册CollectionViewCellLevell的identifier
    [collectionViewLevel1 registerClass:[CollectionViewCellLevel class] forCellWithReuseIdentifier:@"collectionidentiferLevel"];
    collectionViewLevel1.tag = 1110;
    [scrollview addSubview:collectionViewLevel1];
    
    UICollectionView* collectionViewLevel2 = [[UICollectionView alloc] initWithFrame:CGRectMake(scrollview.frame.size.width+20, 20, levelBaseView.bounds.size.width-40, scrollview.bounds.size.height - 40) collectionViewLayout:collectionviewflow];
    collectionViewLevel2.dataSource = self;
    collectionViewLevel2.delegate = self;
    collectionViewLevel2.backgroundColor = [UIColor clearColor];
    //注册CollectionViewCellLevell的identifier
    [collectionViewLevel2 registerClass:[CollectionViewCellLevel class] forCellWithReuseIdentifier:@"collectionidentiferLevel"];
    collectionViewLevel2.tag = 1120;
    [scrollview addSubview:collectionViewLevel2];
    
    UICollectionView* collectionViewLevel3 = [[UICollectionView alloc] initWithFrame:CGRectMake(scrollview.frame.size.width*2 +20, 20, levelBaseView.bounds.size.width-40, scrollview.bounds.size.height - 40) collectionViewLayout:collectionviewflow];
    collectionViewLevel3.dataSource = self;
    collectionViewLevel3.delegate = self;
    collectionViewLevel3.backgroundColor = [UIColor clearColor];
    //注册CollectionViewCellLevell的identifier
    [collectionViewLevel3 registerClass:[CollectionViewCellLevel class] forCellWithReuseIdentifier:@"collectionidentiferLevel"];
    collectionViewLevel3.tag = 1130;
    [scrollview addSubview:collectionViewLevel3];
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollview.bounds.size.height - 20,  levelBaseView.bounds.size.width, 20)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = 3;
    pageControl.tag = 1200;
    [levelBaseView addSubview:pageControl];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, levelBaseView.frame.size.height - 50, levelBaseView.bounds.size.width, 50)];
    button.backgroundColor = [UIColor colorWithRed:0.7 green:0.8 blue:0.9 alpha:1.0];
    [button setTitle:@"返回主页" forState:UIControlStateNormal];
    button.tag = 1300;
    [button addTarget:self action:@selector(buttonPressedGoback:) forControlEvents:UIControlEventTouchUpInside];
    [levelBaseView addSubview:button];
}

-(void)buttonPressedGoback:(id)sender{
    [self.theAnimator removeAllBehaviors];
    
    UIView *levelBaseView = (UIView *)[self viewWithTag:0];
    [UIView animateWithDuration:0.3 animations:^{
        levelBaseView.frame = CGRectMake(levelBaseView.frame.origin.x, -levelBaseView.frame.size.height, levelBaseView.frame.size.width, levelBaseView.frame.size.height);
    } completion:^(BOOL isfinish){
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark UIScrollerView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
}

#pragma mark - 
#pragma mark UICollection的代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5*9;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionView *collectionViewLevel = (UICollectionView *)[self viewWithTag:1110];
    int ylen = collectionViewLevel.frame.size.height/9;
    int xlen = collectionViewLevel.frame.size.width/5;
    
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
    int red = arc4random()%100;
    int freen = arc4random()%100;
    int blue = arc4random()%100;
    cell.backgroundColor = [UIColor colorWithRed:red/100.0 green:freen/100.0 blue:blue/100.0 alpha:1.0];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    CollectionViewControllerPlay *collecPlay = [[CollectionViewControllerPlay alloc] initWithCollectionViewLayout:flowlayout];
    collecPlay.gameexterncolorType += (int)indexPath.row;
    collecPlay.view.backgroundColor = [UIColor whiteColor];
    collecPlay.collectionView.backgroundColor = [UIColor whiteColor];
    [self.viewController addChildViewController:collecPlay];
    [self.viewController.view addSubview:collecPlay.view];
    
    [self.theAnimator removeAllBehaviors];
    UIView *levelBaseView = (UIView *)[self viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        levelBaseView.frame = CGRectMake(levelBaseView.frame.origin.x, -levelBaseView.frame.size.height, levelBaseView.frame.size.width, levelBaseView.frame.size.height);
    } completion:^(BOOL isfinish){
        [self removeFromSuperview];
    }];
}
@end
