//
//  CollectionViewControllerPlay.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/24.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "CollectionViewControllerPlay.h"
#import <AVFoundation/AVFoundation.h>
#import "GameAlgorithm.h"
#import "SpriteUIView.h"
#import "UIViewProgress.h"
#import "SystemInfo.h"
#import "LevelAndUserInfo.h"
#import "UIViewFinishPlayAlert.h"
#import "GameDataGlobal.h"
#import "SpriteView2.h"
#import "macro.h"

#define AllblockNumpercent 0.65

extern NSString *levelinfo;
extern NSString *levelinfoScore;
extern NSString *levelinfoTime;
extern NSString *levelinfoStarNum;
extern NSString *levelinfoWidthNum;
extern NSString *levelinfoColorNum;
extern NSString *playingViewExitNotification;

NSString *playingViewExitNotification = @"playingViewExitNotification";

@interface CollectionViewControllerPlay ()<UIAlertViewDelegate,UIViewFinishPlayAlertDelegate>
{
   int seconde;
}

@property(nonatomic, retain) UIDynamicAnimator *animator;
@property(nonatomic, retain) UIGravityBehavior *gravity;
@property(nonatomic, retain) UIViewProgress *processView;
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, retain) UILabel *labelPoints;
@property(nonatomic, assign) int Allpoints;
//mutArraySprites 存储正在动的sprites
@property(nonatomic, strong) NSMutableArray *mutArraySprites;
@property(nonatomic, assign) int starNum;
@property(nonatomic, assign) BOOL isWatchVideoContinue;

@end

@implementation CollectionViewControllerPlay

static NSString * const reuseIdentifier = @"Cell";

-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.widthNum = 11.0;
        self.timeLimit = 50;
        self.gameInitTypeNum = 3.0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLabelEnergy) name:NotificationShouldRefreshEnergyLabel object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationShouldRefreshEnergyLabel object:nil];
    self.mutArraySprites = nil;
    self.gameAlgorithm = nil;
    self.animator = nil;
    self.gravity = nil;
    self.processView = nil;
    self.timer = nil;
    self.labelPoints = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.timer) {
        return;
    }
    
    [super viewWillAppear:animated];
    seconde = 0;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
    
    //如果是ipad 横向右13.0个方块
    if (IsPadUIBlockGame()) {
        _widthNum +=2;
    }
    
    
    CGFloat width = self.view.frame.size.width/_widthNum;
    int heightnum = self.view.frame.size.height/width-1;
    
    self.gameAlgorithm = [[GameAlgorithm alloc] initWithWidthNum:_widthNum heightNum:heightnum gamecolorexternNum:self.gameInitTypeNum allblockNumpercent:AllblockNumpercent];
    //时间根据总块数生成
    _timeLimit = [_gameAlgorithm getAllValueBlockNum]/2 - [_gameAlgorithm getAllValueBlockNum]/15 + _gameLevelIndex/10;
    
    //做重力动画的
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    //只能有一个重力系统
    self.gravity = [[UIGravityBehavior alloc] init];
    self.gravity.magnitude = 2;
    [self.animator addBehavior:self.gravity];
    
    int imageEnergyWidth = 30;
    int imageEnergyHeigh = 30;
    int imageEnergyInsertRight = 10;
    int imageEnergyInsertTop = -1;
    
    if(IsPadUIBlockGame()){
        imageEnergyWidth *= 2;
        imageEnergyHeigh*=2;
        imageEnergyInsertRight*=2;
        imageEnergyInsertTop *=2;
    }
    UIImageView *imageViewEnergy = [[UIImageView alloc] initWithFrame:CGRectMake(imageEnergyInsertRight, self.view.frame.size.height- imageEnergyHeigh -imageEnergyInsertTop, imageEnergyWidth, imageEnergyHeigh)];
    imageViewEnergy.image = [UIImage imageNamed:@"image_main_energy.png"];
    [self.view addSubview:imageViewEnergy];
    
    
    int labelEnergyWidth = 50;
    int labelEnergyHeigh = 20;
    int labelEnergyInsert = 0;
    int labelEnergyLabelFont = 20;
    
    if(IsPadUIBlockGame()){
        labelEnergyWidth*=2;
        labelEnergyHeigh*=2;
        labelEnergyInsert*=2;
        labelEnergyLabelFont *=2;
    }
    UILabel *labelEnergy = [[UILabel alloc] initWithFrame:CGRectMake(imageViewEnergy.frame.origin.x + imageViewEnergy.frame.size.width, self.view.frame.size.height - labelEnergyHeigh - labelEnergyInsert, labelEnergyWidth, labelEnergyHeigh)];
    labelEnergy.tag = 10001;
    labelEnergy.text = [NSString stringWithFormat:@"X %d",[GameDataGlobal getGameRestEnergy]];
    labelEnergy.textColor = [GameDataGlobal getColorInColorType:5];
    labelEnergy.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:labelEnergyLabelFont];
    [self.view addSubview:labelEnergy];
    
    
    int processViewWidth = 120;
    int processViewInsertBottom= 10;
    int processViewInsertRight = 10;
    int processViewHeigh = 5;
    if (IsPadUIBlockGame()) {
        processViewWidth = 400;
        processViewInsertBottom = 50;
        processViewHeigh = 40;
    }
    self.processView = [[UIViewProgress alloc] initWithFrame:CGRectMake(labelEnergy.frame.origin.x + labelEnergy.frame.size.width + processViewInsertRight, self.view.frame.size.height - processViewInsertBottom + processViewHeigh, processViewWidth, processViewHeigh)];
    self.processView.alpha = 0.5;
    self.processView.progress = 0;
    self.processView.trackColor = [UIColor grayColor];
    self.processView.progressColor = [GameDataGlobal getColorInColorType:5];
    self.processView.progressWidth = 5.0;
    if (!_noBackgroundImage) {
        [self.view addSubview:self.processView];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerResponce:) userInfo:nil repeats:YES];
    }
    
    int buttonInsertRight = 5;
    int buttonInsertBottom = 20;
    int buttonWidth = 50;
    int buttonHeigh = 20;
    if (IsPadUIBlockGame()) {
        buttonWidth*=2;
        buttonHeigh*=2;
        buttonInsertBottom*=2;
    }
    
    UIButton *buttonStop = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonStop.frame = CGRectMake(self.processView.frame.origin.x + self.processView.frame.size.width + buttonInsertRight,self.view.frame.size.height - buttonInsertBottom, buttonWidth, buttonHeigh);
    [buttonStop addTarget:self action:@selector(buttonStopPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonStop setImage:[UIImage imageNamed:@"image_pause"] forState:UIControlStateNormal];
    [self.view addSubview:buttonStop];
    
    int labelPointsWidth = 50;
    if (IsPadUIBlockGame()) {
        
    }
    self.labelPoints = [[UILabel alloc] init];
    self.labelPoints.frame = CGRectMake(buttonStop.frame.origin.x+buttonStop.frame.size.width - 20,self.view.frame.size.height - buttonInsertBottom, labelPointsWidth, buttonHeigh);
    self.labelPoints.text = @"0";
    self.labelPoints.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:labelEnergyLabelFont];
    self.labelPoints.textAlignment = NSTextAlignmentCenter;
    self.labelPoints.textColor = [GameDataGlobal getColorInColorType:5];
    if (!_noBackgroundImage) {
        [self.view addSubview:self.labelPoints];
    }
}

-(void)refreshLabelEnergy{
    UILabel *labelEnergy = (UILabel *)[self.view viewWithTag:10001];
    labelEnergy.text = [NSString stringWithFormat:@"X %d",[GameDataGlobal getGameRestEnergy]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 事件
-(void)timerResponce:(id)sender{
    seconde++;
    self.processView.progress = seconde/_timeLimit;
    
    if (seconde > _timeLimit) {
        [self endTheGame];
    }
}

-(void)buttonStopPressed:(id)sender{
    [GameDataGlobal playAudioSwitch];
    [self.timer invalidate];
    UIViewFinishPlayAlert *finish = [[UIViewFinishPlayAlert alloc] initWithFrame:self.view.bounds];
    finish.target = [_gameAlgorithm getAllValueBlockNum];
    finish.score = self.Allpoints;
    finish.total = [GameDataGlobal getAllBlockenBlocks];
    finish.isStop = YES;
    finish.gameIndex = _gameLevelIndex;
    finish.tag = 3000;
    [self.view addSubview:finish];
    finish.delegate = self;
    [finish showView];
}

#pragma mark - 动画
-(void)addScoreNumImageVew:(int)score frame:(CGRect)frame{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"image_+%d.png",score]]];
    int imageViewSize = self.view.frame.size.width/20;
    imageView.frame = CGRectMake(frame.origin.x + frame.size.width/2 - imageViewSize/2, frame.origin.y + frame.size.height/2 - imageViewSize/2, imageViewSize, imageViewSize);
    [self.view addSubview:imageView];
    [UIView animateWithDuration:1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(1.5, 1.5);
        imageView.transform = transform;
        imageView.alpha = 0.0;
    } completion:^(BOOL isfinish){
        [imageView removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark logic
//看视频重新玩的
-(void)playByWatchVideo{
    self.isWatchVideoContinue = YES;
}

-(void)endTheGame{
    [self.timer invalidate];
    [GameDataGlobal gameResultAddBrockenBlocks:self.Allpoints];
    
    //
    [GameDataGlobal playAudioSwitch];
    
    UIViewFinishPlayAlert *finish = [[UIViewFinishPlayAlert alloc] initWithFrame:self.view.bounds];
    finish.target = [_gameAlgorithm getAllValueBlockNum];
    finish.score = self.Allpoints;
    finish.total = [GameDataGlobal getAllBlockenBlocks];
    finish.gameIndex = _gameLevelIndex;
    // !!!: 成功过关
    if (self.Allpoints >= [_gameAlgorithm getAllValueBlockNum]) {
        [LevelAndUserInfo passLevel:_gameLevelIndex points:_Allpoints startNum:self.starNum];
        [LevelAndUserInfo passLevel:_gameLevelIndex+1 points:1 startNum:-1];
        finish.isSuccess = YES;
        [GameDataGlobal gameResultGuoguan:_gameLevelIndex+1];
    }else{
        [LevelAndUserInfo passLevel:_gameLevelIndex points:_Allpoints startNum:-1];
        finish.isSuccess = NO;
    }
    
    finish.isStop = NO;
    finish.starNum = self.starNum;
    finish.tag = 3000;
    [self.view addSubview:finish];
    finish.delegate = self;
    if (seconde > _timeLimit) {
        finish.isTimesup = YES;
    }
    [finish showView];
}

-(void)replayGame{
    self.Allpoints = 0;
    self.processView.progress = 0;
    seconde = 0;
    self.isWatchVideoContinue = NO;
    CGFloat width = self.view.frame.size.width/_widthNum;
    int heightnum = self.view.frame.size.height/width - 1;
    self.starNum = 0;
    self.gameAlgorithm = [[GameAlgorithm alloc] initWithWidthNum:_widthNum heightNum:heightnum gamecolorexternNum:self.gameInitTypeNum allblockNumpercent:AllblockNumpercent];
    [self.collectionView reloadData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerResponce:) userInfo:nil repeats:YES];
}

-(void)nextLevel{
    NSArray* _arrayGuanka = [[LevelAndUserInfo shareInstance] arrayLevelInfos];
    NSDictionary *dicLevels = [_arrayGuanka objectAtIndex:_gameLevelIndex+1];
    //每一关的参数设置
    int widthNum = [[dicLevels objectForKey:levelinfoWidthNum] intValue];
    int colorNum = [[dicLevels objectForKey:levelinfoColorNum] intValue];
    _gameLevelIndex += 1;
    _widthNum = widthNum;
    _gameInitTypeNum = colorNum;
    
    self.starNum = 0;
    self.Allpoints = 0;
    self.processView.progress = 0;
    self.isWatchVideoContinue = NO;
    seconde = 0;
    CGFloat width = self.view.frame.size.width/_widthNum;
    int heightnum = self.view.frame.size.height/width - 1;
    self.gameAlgorithm = [[GameAlgorithm alloc] initWithWidthNum:_widthNum heightNum:heightnum gamecolorexternNum:self.gameInitTypeNum allblockNumpercent:AllblockNumpercent];
    //时间根据时间生成
    _timeLimit = [_gameAlgorithm getAllValueBlockNum]/2 - [_gameAlgorithm getAllValueBlockNum]/10 + _gameLevelIndex/10;
    
    [self.collectionView reloadData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerResponce:) userInfo:nil repeats:YES];
}

-(int)numberOfblock{
    CGFloat width = self.view.frame.size.width/_widthNum;
    int heightnum = self.view.frame.size.height/width + 1;
    return heightnum*_widthNum;
}

//SpriteUIView被拆的动画效果
-(void)beginActionAnimatorBehavior:(__weak NSMutableArray *)arraySprites{
    for(SpriteUIView *sprite in arraySprites){
        if (sprite.pushBehavior) {
            //正在执行动画，下一个
            continue;
        }
        
        //给个斜着向上的速度
        [sprite generateBehaviorAndAdd:self.animator];
        [self.gravity addItem:sprite];
    }
    
    __weak UIGravityBehavior *gravity = self.gravity;
    //当物体离开了屏幕范围要移除掉，以免占用cpu资源
    __weak UIDynamicAnimator *anim = self.animator;
    CGRect rect = self.view.bounds;
    self.gravity.action = ^{
        NSArray* items = [anim itemsInRect:rect];
        for(int i = 0;i < arraySprites.count;i++){
            SpriteUIView *sprite2 = [arraySprites objectAtIndex:i];
            if (NSNotFound == [items indexOfObject:sprite2] && [sprite2 superview]) {
                [sprite2 removeBehaviorWithAnimator:anim];
                [gravity removeItem:sprite2];
                [sprite2 removeFromSuperview];
                [sprite2 setTimeInvilade];
                [arraySprites removeObjectAtIndex:i];
                i--;
            }
        }
    };
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfblock];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row%2) {
        if (!_noBackgroundImage) {
            UIImage *imageBlack = [UIImage imageNamed:@"image_playing_cellbackground"];
            cell.layer.contents = (__bridge id)(imageBlack.CGImage);
        }
        
    }else{
        if (!_noBackgroundImage) {
            UIImage *imageBlack = [UIImage imageNamed:@"image_playing_cellbackground"];
            cell.layer.contents = (__bridge id)(imageBlack.CGImage);
        }
    }
    
    //获取该块的颜色
    int colorType = [self.gameAlgorithm getColorInthisPlace:(int)indexPath.row];
    UIColor *color = [GameDataGlobal getColorInColorType:colorType];
    SpriteView2 *sprite = (SpriteView2 *)[cell viewWithTag:1001];
    if (color) {
        int spritSize = cell.frame.size.width*6/7;
        int insert = cell.frame.size.width/10;
        if (!sprite) {
            sprite = [[SpriteView2 alloc] init];
            [cell addSubview:sprite];
            sprite.tag = 1001;
        }
        sprite.frame = CGRectMake(insert, insert, spritSize, spritSize);
        sprite.layer.cornerRadius = spritSize/4.0;
        sprite.backgroundColor = color;
//        [sprite beginAnimation];
    }
    else if(sprite){
        [sprite removeFromSuperview];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = self.view.frame.size.width/_widthNum;
    return CGSizeMake(width, width);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.3 animations:^{
        cell.alpha = 0.5;
    } completion:^(BOOL finish){
        cell.alpha = 1;
    }];
    
    NSMutableArray *mutableShoulUpdate = nil;
    //获取要remove掉的label
    NSArray *arrayshouldRemoveIndexpath = [self.gameAlgorithm getplacethatShoulddrop:(int)indexPath.row  placeShouldUpdate:&mutableShoulUpdate];
    //显示路径
    for (NSNumber *numIndex in mutableShoulUpdate) {
        int indexpathrow = [numIndex intValue];
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexpathrow inSection:0];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
        UIView *pointsImageView = [[UIView alloc]initWithFrame:cell.bounds];
        pointsImageView.layer.contents = (__bridge id)([UIImage imageNamed:@"image_back_point.png"].CGImage);
        pointsImageView.alpha = 0.5;
        [cell addSubview:pointsImageView];
        [UIView animateWithDuration:0.3 animations:^{
            pointsImageView.alpha = 0.0;
        } completion:^(BOOL isfinish){
            [pointsImageView removeFromSuperview];
        }];
    }
    
    
    int spritesNumShouldDrop = 0;
    if (!self.mutArraySprites) {
        self.mutArraySprites = [[NSMutableArray alloc] init];
    }
    for (NSNumber *num in arrayshouldRemoveIndexpath) {
        int indexpathrow = [num intValue];
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexpathrow inSection:0];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
        SpriteView2 *sprite = (SpriteView2 *)[cell viewWithTag:1001];
        if (sprite) {
            spritesNumShouldDrop++;
            CGRect rect = [sprite convertRect:sprite.frame toView:self.view];
            [sprite removeFromSuperview];
            sprite.frame = rect;
            [self.view addSubview:sprite];
//            [self.mutArraySprites addObject:sprite];
            [sprite lp_explode];
        }
    }
//    [self beginActionAnimatorBehavior:self.mutArraySprites];
    
    if (!self.isWatchVideoContinue) {
        _Allpoints = _Allpoints + spritesNumShouldDrop*2 - 2;
    }
    
    [self addScoreNumImageVew:spritesNumShouldDrop*2 - 2 frame:cell.frame];
    if (spritesNumShouldDrop > 1) {
        [GameDataGlobal playAudioIsCorrect:spritesNumShouldDrop-1];
    }else{
        [GameDataGlobal playAudioIsCorrect:4];
    }
    
    //根据4个的爆破数来决定星星的多少
    if (spritesNumShouldDrop >= 4) {
        self.starNum++;
    }
    
    self.labelPoints.text = [NSString stringWithFormat:@"%d",_Allpoints];
    
    [_gameAlgorithm isHaveBlockToDestroy:^(BOOL isHave){
        if (!isHave) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endTheGame];
            });
        }
    }];
}

//cell反选时被调用(多选时才生效)
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark -
#pragma mark alertviewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 2000) {
            [self continueGame];
        }else{
          [self replayGame];
        }
    }else if(buttonIndex == 0){
        [self exitTheGame];
    }
}

-(void)exitTheGame{
    [GameDataGlobal gameResultAddBrockenBlocks:self.Allpoints];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL isFinish){
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:playingViewExitNotification object:nil userInfo:nil];
}

-(void)continueGame{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerResponce:) userInfo:nil repeats:YES];
}

#pragma mark - UIViewFinishAlertDelegate
-(void)buttonPressedExitTheGame{
    [self exitTheGame];
}

-(void)buttonPressedReplayTheGame{
    [self replayGame];
    [self refreshLabelEnergy];
}

-(void)buttonPressedContineTheGame{
    [self continueGame];
}

-(void)buttonPressedNextLevel{
    [self nextLevel];
    [self refreshLabelEnergy];
}

@end
