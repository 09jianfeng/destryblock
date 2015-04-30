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
@property(nonatomic, retain) UIView *levelBaseView;
@property(nonatomic, retain) UIDynamicAnimator *theAnimator;
@property(nonatomic, retain) UICollectionView *collectionViewLevel;
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
    self.levelBaseView = nil;
    self.collectionViewLevel = nil;
}

#pragma mark -
#pragma mark 子视图
-(void)initAndAddOtherSubview{
    self.levelBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.8, self.frame.size.height*0.6)];
    self.levelBaseView.backgroundColor = [UIColor colorWithRed:0.4 green:0.5 blue:0.9 alpha:1.0];
    self.levelBaseView.center = CGPointMake(self.frame.size.width/2, 0);
    self.levelBaseView.layer.cornerRadius = 5.0;
    [self addSubview:self.levelBaseView];
    
    self.theAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[_levelBaseView]];
    [self.theAnimator addBehavior:gravityBehaviour];
    
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:_levelBaseView attachedToAnchor:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [attachmentBehavior setLength:0];
    [attachmentBehavior setDamping:0.5];
    [attachmentBehavior setFrequency:3];
    [self.theAnimator addBehavior:attachmentBehavior];
    
    UICollectionViewFlowLayout *collectionviewflow = [[UICollectionViewFlowLayout alloc] init];
    self.collectionViewLevel = [[UICollectionView alloc] initWithFrame:self.levelBaseView.bounds collectionViewLayout:collectionviewflow];
    _collectionViewLevel.dataSource = self;
    _collectionViewLevel.delegate = self;
    //注册CollectionViewCellLevell的identifier
    [self.collectionViewLevel registerClass:[CollectionViewCellLevel class] forCellWithReuseIdentifier:@"collectionidentiferLevel"];
    [self.levelBaseView addSubview:self.collectionViewLevel];
}

#pragma mark - 
#pragma mark UICollection的代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(50, 50);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
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
    collecPlay.view.backgroundColor = [UIColor whiteColor];
    collecPlay.collectionView.backgroundColor = [UIColor whiteColor];
    [self.viewController addChildViewController:collecPlay];
    [self.viewController.view addSubview:collecPlay.view];
    
    [self removeFromSuperview];
}
@end
