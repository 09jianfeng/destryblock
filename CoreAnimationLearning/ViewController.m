//
//  ViewController.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/19.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewControllerPlay.h"
#import <sys/stat.h>
#import <dlfcn.h>
#import "BallView.h"
#import "LevelDialogView.h"
#import "SystemInfo.h"
#import "WebViewGifPlayer.h"
#import "GameResultData.h"

extern NSString *playingViewExitNotification;

@interface ViewController (){
    float radius;
    float circleX;
    float circleY;
    int ballNumber;
}

@property(nonatomic, retain) UIDynamicAnimator *theAnimator;
@property(nonatomic, retain) UIGravityBehavior *gravityBehaviour;
@property(nonatomic, retain) NSArray *backgroundArray;
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIButton *circle;
@property(nonatomic, retain) NSMutableArray *arrayButtons;

@property(nonatomic, assign) int circleNum;
@property(nonatomic, assign) int beginCircleNum;
@end

@implementation ViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:playingViewExitNotification object:nil];
    [self.theAnimator removeAllBehaviors];
    self.theAnimator = nil;
    self.gravityBehaviour = nil;
    self.backgroundArray = nil;
    self.label = nil;
    self.circle = nil;
    self.arrayButtons = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayButtons = [[NSMutableArray alloc] initWithCapacity:6];
    radius = self.view.frame.size.width/8.0;
    circleX = self.view.frame.size.width/2 - radius;
    circleY = self.view.frame.size.height - radius*3.5;
    [self addSubViews];
}

-(void)addSubViews{
    UIImage *manuBackground = [UIImage imageNamed:@"manu_background.png"];
    self.view.layer.contents = (__bridge id)(manuBackground.CGImage);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-radius*7/2, 50, radius*7, radius*3)];
    imageView.image = [UIImage imageNamed:@"image_title.png"];
    imageView.layer.cornerRadius = 10.0;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    UIButton *beginPlayButton = [[UIButton alloc] initWithFrame:CGRectMake(-self.view.frame.size.width, imageView.frame.origin.y+imageView.frame.size.height+radius, radius*4, radius*1.5)];
    [beginPlayButton setImage:[UIImage imageNamed:@"image_begin.png"] forState:UIControlStateNormal];
    beginPlayButton.backgroundColor = [UIColor clearColor];
    [beginPlayButton addTarget:self action:@selector(buttonPlayPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageView];
    [self.view addSubview:beginPlayButton];
    [UIView animateWithDuration:1.0 animations:^{
        beginPlayButton.frame = CGRectMake(self.view.frame.size.width/2-radius*2, imageView.frame.origin.y+imageView.frame.size.height+radius, radius*4, radius*1.5);
    } completion:^(BOOL isFinish){
        [self beginAnimation:beginPlayButton];
    }];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(circleX, circleY + radius*2.5, radius*2, 40)];
    self.label.textColor = [UIColor colorWithRed:0.3 green:0.2 blue:0.62 alpha:1.0];
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.text = @"微信";
    self.label.alpha = 0.0;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    [self addCircle];
    
    WebViewGifPlayer *gifPlayer = [[WebViewGifPlayer alloc] initWithFrame:CGRectMake(circleX + radius, circleY - radius*3, 200, 200)];
    [gifPlayer beginPlayGifWithPath:[[NSBundle mainBundle] pathForResource:@"hudie" ofType:@"gif"]];
    [self.view addSubview:gifPlayer];
    self.view.backgroundColor = [UIColor clearColor];
    gifPlayer.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    UILabel *allPointsButton = [[UILabel alloc] initWithFrame:CGRectMake(2*self.view.frame.size.width, imageView.frame.origin.y+imageView.frame.size.height+radius + beginPlayButton.frame.size.height+radius, radius*4, radius*1.5)];
    allPointsButton.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    int numbers = [GameResultData getAllBlockenBlocks];
    allPointsButton.textColor = [UIColor redColor];
    allPointsButton.text = [NSString stringWithFormat:@"您共拆了%d砖块",numbers];
    allPointsButton.textAlignment = NSTextAlignmentCenter;
    allPointsButton.tag = 1103;
    [self.view addSubview:allPointsButton];
    [UIView animateWithDuration:1.0 animations:^{
        allPointsButton.frame = CGRectMake(self.view.frame.size.width/2-radius*2, imageView.frame.origin.y+imageView.frame.size.height+radius+ beginPlayButton.frame.size.height+radius, radius*4, radius*1.5);
    } completion:^(BOOL isfinish){
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingViewExitNotificationResponseControl:) name:playingViewExitNotification object:nil];
}

- (void)addCircle {
    int circleRadius = radius*1.5;
    self.circle = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - circleRadius, circleY - radius/2.0, 2 * circleRadius, 2 * circleRadius)];
    [self.circle setTitle:@"分享" forState:UIControlStateNormal];
    [self.circle setTitleColor:[UIColor colorWithRed:0.9 green:0.2 blue:0.2 alpha:0.9] forState:UIControlStateNormal];
    self.circle.layer.cornerRadius = circleRadius;
    self.circle.tag = 2000;
    [self.circle addTarget:self action:@selector(buttonPressedCircle:) forControlEvents:UIControlEventTouchUpInside];
    [self beginAnimation:self.circle];
    [self.view addSubview:self.circle];
}

- (void)dropBall {
    if(ballNumber > 5) return;
    for(int i = 0;i<6;i++){
        UIView *ballView = [self addBallView];
        [self.gravityBehaviour addItem:ballView];
        [self.arrayButtons addObject:ballView];
        ballNumber++;
    }
}

- (UIView *)addBallView {
    BallView *ballView = [[BallView alloc] initWithRadius:radius];
    ballView.tag = 1000+ballNumber;
    [ballView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ballView.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height);
    NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_7.png"];
    if (ballNumber == 0) {
        buttonImageName = @"circlebutton_3.png";
    }
    
    [ballView setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
    [self.view addSubview:ballView];
    return ballView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 事件
-(void)playingViewExitNotificationResponseControl:(id)send{
    UILabel *allPointsShowView = (UILabel *)[self.view viewWithTag:1103];
    int numbers = [GameResultData getAllBlockenBlocks];
    allPointsShowView.text = [NSString stringWithFormat:@"您共拆了%d砖块",numbers];
}

-(void)buttonPressed:(id)sender{
    [self changeBallViewBackground];
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    switch (tag) {
        case 1000:
        {
            self.label.text = @"微信";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1001:
        {
            self.label.text = @"微博";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1002:
        {
            self.label.text = @"QQ";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1003:
        {
            self.label.text = @"QQ空间";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1004:
        {
            self.label.text = @"facebook";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1005:
        {
            self.label.text = @"twitter";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;            
        default:
            break;
    }
}

-(void)buttonPlayPressed:(id)sender{
    LevelDialogView *levelDialogView = [[LevelDialogView alloc] initWithFrame:self.view.bounds];
    levelDialogView.viewController = self;
    levelDialogView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:levelDialogView];
}

-(void)buttonPressedCircle:(id)sender{
    static int a = 0;
    if (!a) {
        a=1;
        [self.theAnimator removeAllBehaviors];
        [self initAnimatorAndGravity];
        [self dropBall];
        [UIView animateWithDuration:0.3 animations:^{
            self.label.alpha = 1.0;
        }];
    }else{
        a=0;
        [self.theAnimator removeAllBehaviors];
        for (BallView *ballView in self.arrayButtons) {
            UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:ballView
                                                                    snapToPoint:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+radius)];
            [snapBehavior setAction:^{
                
            }];
            [self.theAnimator addBehavior:snapBehavior];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.label.alpha = 0.0;
        }];
    }
    
}

-(void)changeBallViewBackground{
    for (int i = 0; i<6; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+i];
        [button setImage:[UIImage imageNamed:@"circlebutton_7.png"] forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark 一直循环执行的动画效果
-(void)alwaysMove:(UIView *)view timeInterval:(int)timeInterval{
    [UIView animateWithDuration:timeInterval animations:^{
        view.frame = CGRectMake(-view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    } completion:^(BOOL isFinish){
        view.frame = CGRectMake(self.view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        [self alwaysMove:view timeInterval:timeInterval];
    }];
}

#pragma mark -
#pragma mark 球的吸附效果
-(void)initAnimatorAndGravity{
    if (!self.theAnimator) {
        self.theAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    if (!self.gravityBehaviour) {
     self.gravityBehaviour = [[UIGravityBehavior alloc] init];
    }
    self.gravityBehaviour.gravityDirection = CGVectorMake(0, -1);
    ViewController *controller = self;
    //球的吸附效果
    NSArray *arrayViews = self.arrayButtons;
    [self.gravityBehaviour setAction:^{
        for (UIView *ballView in arrayViews) {
            if (ballView.frame.origin.y <= circleY + radius*4) {
                UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:ballView
                                                                        snapToPoint:CGPointMake([controller getPositionXFor:(ballView.tag-1000) * M_PI / 3], [controller getPositionYFor:(ballView.tag-1000) * M_PI / 3])];
                [snapBehavior setAction:^{
                    
                }];
                [controller.theAnimator addBehavior:snapBehavior];
            }
            
        }
    }];
    [self.theAnimator addBehavior:self.gravityBehaviour];
}

- (double)getPositionYFor:(double)radian {
    int y = circleY + radius + radius * sin(radian);
    return y;
}

- (double)getPositionXFor:(double)radian {
    double x = circleX + radius + radius * cos(radian);
    return x;
}
#pragma mark -
#pragma mark 动画
-(void)beginAnimation:(UIButton *)bt{
    //1.绕中心圆移动 Circle move   没添加进去先
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = false;
    pathAnimation.repeatCount = MAXFLOAT;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(bt.frame, bt.frame.size.width/2-3, bt.frame.size.width/2-3);
    CGPathAddEllipseInRect(curvedPath, nil, circleContainer);
    pathAnimation.path = curvedPath;
    float randNumP = (arc4random()%5 + 20)/10.0;
    pathAnimation.duration = randNumP;
    
    //x方向伸缩
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.values = @[@1.0,@1.1,@1.0];
    scaleX.keyTimes = @[@0.0,@0.5,@1.0];
    scaleX.repeatCount = MAXFLOAT;
    scaleX.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    float randNumx = (arc4random()%5 + 20)/10.0;
    scaleX.duration = randNumx;
    
    //y方向伸缩
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.values = @[@1.0,@1.1,@1.0];
    scaleY.keyTimes = @[@0.0,@0.5,@1.0];
    scaleY.repeatCount = MAXFLOAT;
    scaleY.autoreverses = YES;
    scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    float randNumy = (arc4random()%5 + 20)/10.0;
    scaleY.duration = randNumy;
    
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.autoreverses = YES;
    groupAnnimation.duration = (arc4random()%30 + 30)/10.0;
    groupAnnimation.animations = @[scaleX, scaleY];
    groupAnnimation.repeatCount = MAXFLOAT;
    //开演
    [bt.layer addAnimation:groupAnnimation forKey:@"groupAnnimation"];
}
@end
