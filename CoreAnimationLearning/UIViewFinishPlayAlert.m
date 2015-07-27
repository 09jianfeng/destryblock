//
//  UIViewFinishPlayAlert.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/27.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "UIViewFinishPlayAlert.h"
#import "GameDataGlobal.h"
#import "SystemInfo.h"
#import "SpriteView2.h"
#import "CustomButton.h"
#import "IndependentVideoManager.h"
#import "macro.h"
#import "CocoBVideo.h"
#import "DMInterstitialAdController.h"
#import "NewWorldSpt.h"

@interface UIViewFinishPlayAlert()<IndependentVideoManagerDelegate,DMInterstitialAdControllerDelegate>
@property(nonatomic,retain) UIDynamicAnimator *ani;
@property(nonatomic,retain) UIGravityBehavior *gravity;
@property(nonatomic,retain) NSMutableArray *arrayImageView;
@property(nonatomic,retain) IndependentVideoManager *independvideo;
//多盟
@property(nonatomic, retain) DMInterstitialAdController *dmController;
@end

@implementation UIViewFinishPlayAlert
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.ani = [[UIDynamicAnimator alloc] init];
        self.gravity = [[UIGravityBehavior alloc] init];
        self.arrayImageView = [[NSMutableArray alloc] init];
        self.isStop = YES;
        [self.ani addBehavior:self.gravity];
        
        self.dmController = [[DMInterstitialAdController alloc] initWithPublisherId:@"56OJzB24uN2iEc0Jh7" placementId:@"16TLmTTlApqv1NUvCls0Cs4s" rootViewController:self.collectionViewController];
        [self.dmController loadAd];
        self.dmController.delegate = self;
    }
    return self;
}


-(void)showView{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    int boarInsert = self.frame.size.width/8;
    if (IsPadUIBlockGame()) {
        boarInsert = self.frame.size.width/6;
    }
    int boarWidth = self.frame.size.width - boarInsert*2;
    int boarHeigh = self.frame.size.height/2 > 284 ? self.frame.size.height/2 : 284;
    UIView *board = [[UIView alloc] initWithFrame:CGRectMake(boarInsert, -self.frame.size.height/2, boarWidth, boarHeigh)];
    board.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
    board.tag = 40000;
    board.layer.cornerRadius = 20;
    
    //上边区域
    if (_isStop) {
        UILabel *lableExit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, board.frame.size.width, board.frame.size.height/3)];
        lableExit.text = @"暂停";
        lableExit.textAlignment = NSTextAlignmentCenter;
        lableExit.textColor = [GameDataGlobal getColorInColorType:1];
        lableExit.font = [UIFont systemFontOfSize:46];
        [board addSubview:lableExit];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self shake:lableExit minAngle:0 angleDuration:M_PI/80 times:16 duration:0.1];
        });
        
    }else if(_isSuccess){
        //星星
        int starLeftRightInsert = board.frame.size.width/16;
        int starInsert = 0;
        int starSize = (board.frame.size.width - starInsert*4 - starLeftRightInsert*2)/3;
        for (int i = 0 ; i < 3 ; i++) {
            UIImageView *imageViewStar = [[UIImageView alloc] initWithFrame:CGRectMake(starLeftRightInsert + starInsert*(i+1) + starSize*i, abs(i-1)*20, starSize, starSize)];
            if (self.starNum > 0) {
                imageViewStar.image = [UIImage imageNamed:@"image_result_star_2"];
                self.starNum--;
                [self.arrayImageView addObject:imageViewStar];
            }else{
                imageViewStar.image = [UIImage imageNamed:@"image_result_star_2"];
            }
            
            [board addSubview:imageViewStar];
        }
    }else{
        UILabel *lableExit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, board.frame.size.width, board.frame.size.height/3)];
        lableExit.text = @"时间到";
        if (!_isTimesup) {
            lableExit.text = @"很遗憾";
        }
        lableExit.textAlignment = NSTextAlignmentCenter;
        lableExit.textColor = [GameDataGlobal getColorInColorType:1];
        lableExit.font = [UIFont systemFontOfSize:46];
        [board addSubview:lableExit];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shake:lableExit minAngle:0 angleDuration:M_PI/80 times:16 duration:0.1];
        });
    }
    
    
    //标题
    UILabel *labelTarget = [[UILabel alloc] initWithFrame:CGRectMake(0, board.frame.size.height/3, board.frame.size.width/2, 30)];
    labelTarget.textAlignment = NSTextAlignmentCenter;
    labelTarget.text = @"目标";
    labelTarget.textColor = [UIColor blackColor];
    [board addSubview:labelTarget];
    UILabel *labelTargetNum = [[UILabel alloc] initWithFrame:CGRectMake(0, labelTarget.frame.origin.y+labelTarget.frame.size.height, board.frame.size.width/2, 30)];
    labelTargetNum.textAlignment = NSTextAlignmentCenter;
    labelTargetNum.text = [NSString stringWithFormat:@"%d",self.target];
    labelTargetNum.textColor = [UIColor blackColor];
    [board addSubview:labelTargetNum];
    
    UILabel *labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(board.frame.size.width/2, board.frame.size.height/3, board.frame.size.width/2, 30)];
    labelTotal.textAlignment = NSTextAlignmentCenter;
    labelTotal.text = @"总共";
    labelTotal.textColor = [UIColor blackColor];
    [board addSubview:labelTotal];
    UILabel *labelTotalNum = [[UILabel alloc] initWithFrame:CGRectMake(board.frame.size.width/2, labelTotal.frame.size.height+labelTotal.frame.origin.y, board.frame.size.width/2, 30)];
    labelTotalNum.textAlignment = NSTextAlignmentCenter;
    labelTotalNum.text = [NSString stringWithFormat:@"%d",self.total];
    labelTotalNum.textColor = [UIColor blackColor];
    [board addSubview:labelTotalNum];
    
    
    int buttonSize = board.frame.size.width/5;
    int buttonInsert = buttonSize*1/3;
    
    UILabel *labelScore = [[UILabel alloc] initWithFrame:CGRectMake(0, labelTargetNum.frame.size.height+labelTargetNum.frame.origin.y + 10, board.frame.size.width, 30)];
    labelScore.textAlignment = NSTextAlignmentCenter;
    labelScore.text = @"当前分数";
    labelScore.textColor = [UIColor blackColor];
    [board addSubview:labelScore];
    UILabel *labelScoreNum = [[UILabel alloc] initWithFrame:CGRectMake(0, labelScore.frame.size.height + labelScore.frame.origin.y,board.frame.size.width, board.frame.size.height - labelScore.frame.size.height - labelScore.frame.origin.y- 10 - buttonSize)];
    labelScoreNum.textAlignment = NSTextAlignmentCenter;
    labelScoreNum.tag = 400001;
    labelScoreNum.text = [NSString stringWithFormat:@"0"];
    labelScoreNum.textColor = [UIColor whiteColor];
    labelScoreNum.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:22];
    [board addSubview:labelScoreNum];
    
    //按钮
    CustomButton *buttonBack = [[CustomButton alloc] initWithFrame:CGRectMake(buttonInsert, board.frame.size.height - buttonSize - 10, buttonSize, buttonSize)];
    buttonBack.backgroundColor = [GameDataGlobal getColorInColorType:2];
    buttonBack.layer.cornerRadius = buttonSize/2;
    [buttonBack setTitle:@"退出" forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(buttonbackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [board addSubview:buttonBack];
    
    CustomButton *buttonReplay = [[CustomButton alloc] initWithFrame:CGRectMake(board.frame.size.width/2 - buttonSize/2, board.frame.size.height - buttonSize - 10, buttonSize, buttonSize)];
    buttonReplay.layer.cornerRadius = buttonSize/2;
    buttonReplay.backgroundColor = [GameDataGlobal getColorInColorType:3];
    [buttonReplay setTitle:@"重玩" forState:UIControlStateNormal];
    [buttonReplay addTarget:self action:@selector(buttonReplayPressed:) forControlEvents:UIControlEventTouchUpInside];
    [board addSubview:buttonReplay];
    
    CustomButton *buttonNext = [[CustomButton alloc] initWithFrame:CGRectMake(board.frame.size.width - buttonSize - buttonInsert, board.frame.size.height - buttonSize - 10, buttonSize, buttonSize)];
    buttonNext.backgroundColor = [GameDataGlobal getColorInColorType:4];
    NSString *conOrNext = @"继续";
    if (!_isStop) {
        conOrNext = @"Next";
        if (_isTimesup && !_isSuccess) {
            conOrNext = @"视频";
        }
    }
    [buttonNext setTitle:conOrNext forState:UIControlStateNormal];
    buttonNext.layer.cornerRadius = buttonSize/2;
    [buttonNext addTarget:self action:@selector(buttonNextLevelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [board addSubview:buttonNext];
    
    //重力效果
    [self.gravity addItem:board];
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:board attachedToAnchor:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [attachmentBehavior setLength:0];
    [attachmentBehavior setDamping:0.3];
    [attachmentBehavior setFrequency:3];
    [self.ani addBehavior:attachmentBehavior];
    [self addSubview:board];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scoreAddingWithTimes:self.score];
    });
    
}

#pragma mark - 分数增加的动画效果
-(void)scoreAddingWithTimes:(int)fallingScore{
    if (fallingScore < 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self beginStarImageAnimator];
        });
        
        return;
    }
    
    int showingNumber = self.score - fallingScore;
    UILabel *scoreNumLabel = (UILabel*)[self viewWithTag:400001];
    scoreNumLabel.text = [NSString stringWithFormat:@"%d",showingNumber];
    scoreNumLabel.textColor = [UIColor whiteColor];
    scoreNumLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:22];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scoreAddingWithTimes:fallingScore-1];
    });
}

#pragma mark - 烟火效果
-(void)beginFireWorkAnimation{
    // 烟火发射器，在底部
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2, viewBounds.size.height);
    fireworksEmitter.emitterSize	= CGSizeMake(5.0, 0.0);
    fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
    fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
    // 烟火弹
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    rocket.name = @"rocketName";
    rocket.birthRate		= 2.0;
    rocket.emissionRange	= 0.05* M_PI;  // some variation in angle，发射角度
    rocket.velocity			= 380;
    rocket.velocityRange	= 100;
    rocket.yAcceleration	= 75;
    rocket.lifetime			= 1.52;	// we cannot set the birthrate < 1.0 for the burst
    
    rocket.contents			= (id) [[UIImage imageNamed:@"image_DazRing"] CGImage];
    rocket.scale			= 0.2;
    rocket.color			= [[UIColor colorWithRed:0.9 green:0.5 blue:0.5 alpha:1.0] CGColor];
    rocket.greenRange		= 1.0;		// different colors
    rocket.redRange			= 1.0;
    rocket.blueRange		= 1.0;
    rocket.spinRange		= M_PI;		// slow spin
    
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    burst.birthRate			= 7.0;		// at the end of travel
    burst.velocity			= 0;
    burst.scale				= 2.5;
    burst.redSpeed			=+1.5;		// shifting
    burst.blueSpeed			=+1.5;		// shifting
    burst.greenSpeed		=+1.0;		// shifting
    burst.lifetime			= 0.2;
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    spark.birthRate			= 100;
    spark.velocity			= 125;
    spark.emissionRange		= 2* M_PI;	// 360 deg
    spark.yAcceleration		= 75;		// gravity
    spark.lifetime			= 3;
    spark.contents			= (id) [[UIImage imageNamed:@"image_snow1"] CGImage];
    spark.scaleSpeed		=-0.2;
    spark.greenSpeed		=0.1;
    spark.redSpeed			= 0.4;
    spark.blueSpeed			=0.1;
    spark.alphaSpeed		=-0.25;
    spark.spin				= 2* M_PI;
    spark.spinRange			= 2* M_PI;
    
    // putting it together
    fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
    rocket.emitterCells				= [NSArray arrayWithObject:burst];
    burst.emitterCells				= [NSArray arrayWithObject:spark];
    [self.layer addSublayer:fireworksEmitter];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [fireworksEmitter setValue:[NSNumber numberWithFloat:0.0] forKeyPath:@"emitterCells.rocketName.birthRate"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int ran = arc4random()%2;
            ran = 0;
            if (ran) {
                [self.dmController present];
                [self.dmController loadAd];
            }else{
                [NewWorldSpt showQQWSPTAction:^(BOOL isClosed){
                    
                }];
            }
        });
    });
}

#pragma mark - 执行星星动画
-(void)beginStarImageAnimator{
    if (self.arrayImageView.count == 0) {
        //过关的话放烟火
        if (_isSuccess) {
            [self beginFireWorkAnimation];
        }
        return;
    }
    
    
    UIImageView *imageView = [self.arrayImageView objectAtIndex:0];
    CALayer *imageLayer = [[CALayer alloc] init];
    imageLayer.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    imageLayer.contents = (__bridge id)([UIImage imageNamed:@"image_result_star"].CGImage);
    [imageView.layer addSublayer:imageLayer];
    
    //透明度渐变
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = [NSNumber numberWithFloat:0.0];
    opacity.toValue = [NSNumber numberWithFloat:1.0];
    opacity.autoreverses = NO;
    opacity.fillMode = kCAFillModeBackwards;
    opacity.repeatCount = 0;
    opacity.duration = 0.3;
    
    //旋转
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:-6.0 * M_PI];
    rotateAnimation.autoreverses = NO;
    rotateAnimation.repeatCount = 0;
    rotateAnimation.duration = 0.3;
    
    //放大缩小
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:4];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1];
    //自动按照原来的轨迹往回播动画
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.duration = 0.3;
    
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.duration = 0.3;
    groupAnnimation.autoreverses = NO;
    groupAnnimation.animations = @[opacity, scaleAnimation,rotateAnimation];
    groupAnnimation.repeatCount = 0;
    
    [imageLayer addAnimation:groupAnnimation forKey:@"scaleAndOpacity"];
    
    
    [self.arrayImageView removeObjectAtIndex:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self beginStarImageAnimator];
    });
}

#pragma mark - 抖动
//maxAngle最小震动幅度，angleDuration递减的角度，times震动次数，duration每次震动的时间
-(void)shake:(UIView *)view minAngle:(CGFloat)minAngle angleDuration:(CGFloat)angleDuration times:(int)times duration:(double)duration{
    if (times <= 0) {
        view.transform = CGAffineTransformIdentity;
        return;
    }
    
    CGFloat angel = minAngle + angleDuration * times/2;
    if (times%2==0) {
        angel = -angel;
    }
    
    times--;
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformMakeRotation(angel);
    } completion:^(BOOL isfinish){
        [self shake:view minAngle:minAngle angleDuration:angleDuration times:times duration:duration];
    }];
}

#pragma mark - 按钮事件
-(void)buttonbackPressed:(id)sender{
    [self.collectionViewController exitTheGame];
}

-(void)buttonReplayPressed:(id)sender{
    [self.ani removeAllBehaviors];
    UIView *board = [self viewWithTag:40000];
    [UIView animateWithDuration:0.3 animations:^{
        board.frame = CGRectMake(board.frame.origin.x, -self.frame.size.height, board.frame.size.width, board.frame.size.height);
    } completion:^(BOOL isFinish){
        [self removeFromSuperview];
        [self.collectionViewController replayGame];
    }];
}

-(void)buttonNextLevelPressed:(id)sender{
    if (self.isStop) {
        [self.ani removeAllBehaviors];
        UIView *board = [self viewWithTag:40000];
        [UIView animateWithDuration:0.3 animations:^{
            board.frame = CGRectMake(board.frame.origin.x, -self.frame.size.height, board.frame.size.width, board.frame.size.height);
        } completion:^(BOOL isFinish){
            [self removeFromSuperview];
            [self.collectionViewController continueGame];
        }];
    }else if(_isSuccess){
        [self.ani removeAllBehaviors];
        UIView *board = [self viewWithTag:40000];
        [UIView animateWithDuration:0.3 animations:^{
            board.frame = CGRectMake(board.frame.origin.x, -self.frame.size.height, board.frame.size.width, board.frame.size.height);
        } completion:^(BOOL isFinish){
            [self removeFromSuperview];
            [self.collectionViewController nextLevel];
        }];
    }else if (_isTimesup){
        int rand = random()%2;
        if (!rand) {
            [CocoBVideo cBVideoInitWithAppID:@"40e2193aeb056059" cBVideoAppIDSecret:@"800b3ab3a9e489b8"];
            [CocoBVideo cBVideoPlay:self.collectionViewController cBVideoPlayFinishCallBackBlock:
             ^(BOOL isFinish){
                 
            } cBVideoPlayConfigCallBackBlock:
             ^(BOOL isLegal){
                 if (isLegal) {
                     //播放视频，然后继续消下去
                     [self.collectionViewController playByWatchVideo];
                     [self removeFromSuperview];
                 }
             }];
            
        }else{
            self.independvideo = [[IndependentVideoManager alloc] initWithPublisherID:@"96ZJ3tqwzex2nwTNt9" andUserID:@"userid"];
            [self.independvideo presentIndependentVideoWithViewController:self.collectionViewController];
            self.independvideo.delegate = self;
        }
    }
}

#pragma mark -多盟的视频代理
/**
 *  开始加载数据。
 *  Independent video starts to fetch info.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidStartLoad:(IndependentVideoManager *)manager{
    HNLOGINFO(@"开始加载数据");
}


/**
 *  加载完成。
 *  Fetching independent video successfully.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidFinishLoad:(IndependentVideoManager *)manager{
    HNLOGINFO(@"加载完成");
}


/**
 *  加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
 *   Failed to load independent video.
 
 *
 *  @param manager IndependentVideoManager
 *  @param error   error
 */
- (void)ivManager:(IndependentVideoManager *)manager
failedLoadWithError:(NSError *)error{
    HNLOGINFO(@"加载失败，%@",error);
}


/**
 *  被呈现出来时，回调该方法。
 *  Called when independent video will be presented.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerWillPresent:(IndependentVideoManager *)manager{
    HNLOGINFO(@"视频呈现出来");
}



/**
 *  页面关闭。
 *  Independent video closed.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidClosed:(IndependentVideoManager *)manager{
    HNLOGINFO(@"视频页面关闭");
}


/**
 *  当视频播放完成后，回调该方法。
 *  Independent video complete play
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerCompletePlayVideo:(IndependentVideoManager *)manager{
    HNLOGINFO(@"视频播放完成");
    //播放视频，然后继续消下去
    [self.collectionViewController playByWatchVideo];
    [self removeFromSuperview];
}



/**
 *  成功获取视频积分
 *  Complete independent video.
 *
 *  @param manager IndependentVideoManager
 *  @param totalPoint
 *  @param consumedPoint
 *  @param currentPoint
 */

- (void)ivCompleteIndependentVideo:(IndependentVideoManager *)manager
                    withTotalPoint:(NSNumber *)totalPoint
                     consumedPoint:(NSNumber *)consumedPoint
                      currentPoint:(NSNumber *)currentPoint{
    HNLOGINFO(@"成功获取视频积分");
}




/**
 *  获取视频积分出错
 *  Uncomplete independent video.
 *
 *  @param manager IndependentVideoManager
 *  @param error
 */

- (void)ivManagerUncompleteIndependentVideo:(IndependentVideoManager *)manager
                                  withError:(NSError *)error{
    HNLOGINFO(@"获取视频积分出错");
}

#pragma mark -多盟插屏代理
#pragma mark -
#pragma mark DMInterstitialAdController Delegate
// 当插屏广告被成功加载后，回调该方法
// This method will be used after the ad has been loaded successfully
- (void)dmInterstitialSuccessToLoadAd:(DMInterstitialAdController *)dmInterstitial
{
    HNLOGINFO(@"[Domob Interstitial] success to load ad.");
}

// 当插屏广告加载失败后，回调该方法
// This method will be used after failed
- (void)dmInterstitialFailToLoadAd:(DMInterstitialAdController *)dmInterstitial withError:(NSError *)err
{
    HNLOGINFO(@"[Domob Interstitial] fail to load ad. %@", err);
}

// 当插屏广告要被呈现出来前，回调该方法
// This method will be used before being presented
- (void)dmInterstitialWillPresentScreen:(DMInterstitialAdController *)dmInterstitial
{
    HNLOGINFO(@"[Domob Interstitial] will present.");
}

// 当插屏广告被关闭后，回调该方法
// This method will be used after Interstitial view  has been closed
- (void)dmInterstitialDidDismissScreen:(DMInterstitialAdController *)dmInterstitial
{
    HNLOGINFO(@"[Domob Interstitial] did dismiss.");
    
    // 插屏广告关闭后，加载一条新广告用于下次呈现
    //prepair for the next advertisement view
    [self.dmController loadAd];
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器。
// When will be showing a Modal View, call this method. Such as open built-in browser
- (void)dmInterstitialWillPresentModalView:(DMInterstitialAdController *)dmInterstitial
{
    HNLOGINFO(@"[Domob Interstitial] will present modal view.");
}

// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
// When presented Modal View is closed, this method will be called. Such as built-in browser is closed
- (void)dmInterstitialDidDismissModalView:(DMInterstitialAdController *)dmInterstitial
{
    HNLOGINFO(@"[Domob Interstitial] did dismiss modal view.");
}

// 当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
// When the result of the user's actions (such as clicking download class advertising, you need to jump to the Store), need to leave the current application, this method will be called
- (void)dmInterstitialApplicationWillEnterBackground:(DMInterstitialAdController *)dmInterstitial
{
    HNLOGINFO(@"[Domob Interstitial] will enter background.");
}


-(void)dealloc{
    self.dmController = nil;
    self.independvideo.delegate = nil;
    self.independvideo = nil;
    self.arrayImageView = nil;
    self.ani = nil;
    self.gravity = nil;
}
@end

