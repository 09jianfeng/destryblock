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
#import "ProGressView.h"

@interface CollectionViewControllerPlay ()
@property(nonatomic, retain) AVAudioPlayer *audioplayerCorrect;
@property(nonatomic, retain) AVAudioPlayer *audioplayerError;
@property(nonatomic, retain) GameAlgorithm *gameAlgorithm;
@property(nonatomic, retain) UIDynamicAnimator *animator;
@property(nonatomic, retain) UIGravityBehavior *gravity;
@property(nonatomic, retain) ProGressView *processView;
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, retain) UILabel *labelPoints;
@property(nonatomic, assign) int Allpoints;
@end

@implementation CollectionViewControllerPlay

const float widthNum = 19.0;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
    
    CGFloat width = self.view.frame.size.width/widthNum;
    int heightnum = self.view.frame.size.height/width;
    self.gameAlgorithm = [[GameAlgorithm alloc] initWithWidthNum:widthNum heightNum:heightnum];
    
    //做重力动画的
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    //只能有一个重力系统
    self.gravity = [[UIGravityBehavior alloc] init];
    [self.animator addBehavior:self.gravity];
    
    self.labelPoints = [[UILabel alloc] init];
    self.labelPoints.frame = CGRectMake(self.view.frame.size.width - 50,self.view.frame.size.height - 20, 30, 20);
    self.labelPoints.text = @"0";
    self.labelPoints.font = [UIFont systemFontOfSize:18];
    self.labelPoints.textAlignment = NSTextAlignmentCenter;
    self.labelPoints.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:1.0];
    [self.view addSubview:self.labelPoints];
    
    self.processView = [[ProGressView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-10, 250, 5)];
    self.processView.backgroundColor = [UIColor whiteColor];
    self.processView.alpha = 0.5;
    [self.view addSubview:self.processView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerResponce:) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.collectionView.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark logic
-(void)timerResponce:(id)sender{
    static int seconde = 0;
    seconde++;
    [self.processView setprocess:seconde/60.0];
    
    if (seconde > 60) {
        [self.timer invalidate];
        NSString *message = [NSString stringWithFormat:@"您的总分是：%d",self.Allpoints];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间到" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)playAudioIsCorrect:(BOOL)isCorrect{
    
    NSString *stringCottect = @"";
    if (isCorrect) {
        stringCottect = @"correct.mp3";
    }else{
        stringCottect = @"error.mp3";
    }
    //1.音频文件的url路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:stringCottect withExtension:Nil];
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    self.audioplayerCorrect=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    //3.缓冲
    [self.audioplayerCorrect prepareToPlay];
    [self.audioplayerCorrect play];
}

-(int)numberOfblock{
    CGFloat width = self.view.frame.size.width/widthNum;
    int heightnum = self.view.frame.size.height/width + 1;
    return heightnum*widthNum;
}

-(UIColor *)getColorInColorType:(blockcolor)blockcolorType{
    switch (blockcolorType) {
        case blockcolornone:
            return nil;
            break;
        case blockcolor1:
            return [UIColor colorWithRed:0.43 green:0.82 blue:0.51 alpha:1.0];
            break;
        case blockcolor2:
            return [UIColor colorWithRed:0.49 green:0.62 blue:0.51 alpha:1.0];
            break;
        case blockcolor3:
            return [UIColor colorWithRed:0.50 green:0.42 blue:0.96 alpha:1.0];
            break;
        case blockcolor4:
            return [UIColor colorWithRed:0.48 green:0.49 blue:0.71 alpha:1.0];
            break;
        
        case blockcolor5:
            return [UIColor colorWithRed:0.38 green:0.42 blue:0.61 alpha:1.0];
            break;
        case blockcolor6:
            return [UIColor colorWithRed:0.54 green:0.32 blue:0.72 alpha:1.0];
            break;
        case blockcolor7:
            return [UIColor colorWithRed:0.53 green:0.32 blue:0.61 alpha:1.0];
            break;
        case blockcolor8:
            return [UIColor colorWithRed:0.43 green:0.72 blue:0.51 alpha:1.0];
            break;
        case blockcolor9:
            return [UIColor colorWithRed:0.93 green:0.52 blue:0.51 alpha:1.0];
            break;
        case blockcolor10:
            return [UIColor colorWithRed:0.63 green:0.62 blue:0.41 alpha:1.0];
            break;

        default:
            return nil;
            break;
    }
    return nil;
}

-(void)beginActionAnimatorBehavior:(SpriteUIView *)sprite{
    //给个斜着向上的速度
    [sprite generatePushBehavior];
    int randy = arc4random()%30;
    int randx = arc4random()%60 - 30;
    [sprite.pushBehavior setPushDirection:CGVectorMake(randx/100.0, -1*randy/100.0)];
    sprite.transform = CGAffineTransformMakeRotation(M_PI*(randx/100.0));
    [self.animator addBehavior:sprite.pushBehavior];
    
    [self.gravity addItem:sprite];
    //当物体离开了屏幕范围要移除掉，以免占用cpu资源
    UIDynamicAnimator *anim = self.animator;
    CGRect rect = self.view.bounds;
    self.gravity.action = ^{
        NSArray* items = [anim itemsInRect:rect];
        if (NSNotFound == [items indexOfObject:sprite]) {
            [anim removeBehavior:sprite.pushBehavior];
            [sprite removeFromSuperview];
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
    // Configure the cell
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    if (indexPath.row%2) {
        UIImage *imageBlack = [UIImage imageNamed:@"backgroundwhite.png"];
        cell.layer.contents = (__bridge id)(imageBlack.CGImage);
    }else{
        UIImage *imageBlack = [UIImage imageNamed:@"background.png"];
        cell.layer.contents = (__bridge id)(imageBlack.CGImage);
    }
    
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    SpriteUIView *sprite = (SpriteUIView *)[cell viewWithTag:1001];
    if (!sprite) {
        sprite = [[SpriteUIView alloc] initWithFrame:CGRectMake(1.0, 1.0, cell.frame.size.width - 2, cell.frame.size.height - 2)];
        [cell addSubview:sprite];
        sprite.tag = 1001;
    }
    
    //获取该块的颜色
    int colorType = [self.gameAlgorithm getColorInthisPlace:(int)indexPath.row];
    UIColor *color = [self getColorInColorType:colorType];
    sprite.backgroundColor = color;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = self.view.frame.size.width/widthNum;
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
    [self playAudioIsCorrect:YES];
    
    //获取要remove掉的label
    NSArray *arrayshouldRemoveIndexpath = [self.gameAlgorithm getplacethatShoulddrop:(int)indexPath.row];
    int spritesNumShouldDrop = 0;
    for (NSNumber *num in arrayshouldRemoveIndexpath) {
        int indexpathrow = [num intValue];
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexpathrow inSection:0];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:path];
        SpriteUIView *sprite = (SpriteUIView *)[cell viewWithTag:1001];
        if (sprite) {
            spritesNumShouldDrop++;
            CGRect rect = [sprite convertRect:sprite.frame toView:self.view];
            [sprite removeFromSuperview];
            sprite.frame = rect;
            [self.view addSubview:sprite];
            [self beginActionAnimatorBehavior:sprite];
        }
    }
    
    _Allpoints = _Allpoints + spritesNumShouldDrop*2 - 2;
    self.labelPoints.text = [NSString stringWithFormat:@"%d",_Allpoints];
}

//cell反选时被调用(多选时才生效)
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}
@end
