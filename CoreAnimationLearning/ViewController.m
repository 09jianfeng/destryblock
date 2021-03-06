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

@interface ViewController (){
    float radius;
    float circleX;
    float circleY;
    int ballNumber;
}

@property(nonatomic, retain) UIDynamicAnimator *theAnimator;
@property(nonatomic, retain) UIGravityBehavior *gravityBehaviour;
@property(nonatomic, retain) NSArray *backgroundArray;
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIButton *circle;
@property(nonatomic, retain) NSMutableArray *arrayButtons;

@property(nonatomic, assign) int circleNum;
@property(nonatomic, assign) int beginCircleNum;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayButtons = [[NSMutableArray alloc] initWithCapacity:6];
    radius = self.view.frame.size.width/6.0;
    circleX = self.view.frame.size.width/2 - radius;
    circleY = self.view.frame.size.height - radius*3.5;
    [self addSubViews];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerResponse:) userInfo:nil repeats:YES];
}

-(void)addSubViews{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(circleX, circleY + radius*2.5, radius*2, 40)];
    self.label.textColor = [UIColor colorWithRed:0.3 green:0.2 blue:0.62 alpha:1.0];
    self.label.text = @"1";
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
    [self initAnimatorAndGravity];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self dropBall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 时间循环与按钮事件
-(void)timerResponse:(id)sender{
}

-(void)buttonPressed:(id)sender{
    [self changeBallViewBackground];
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    switch (tag) {
        case 1000:
        {
            self.label.text = @"1";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1001:
        {
            self.label.text = @"2";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1002:
        {
            self.label.text = @"3";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1003:
        {
            self.label.text = @"4";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1004:
        {
            self.label.text = @"5";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;
        case 1005:
        {
            self.label.text = @"6";
            NSString *buttonImageName = [NSString stringWithFormat:@"circlebutton_3.png"];
            [button setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        }
            break;            
        default:
            break;
    }
}

-(void)buttonPressedCircle:(id)sender{
    LevelDialogView *levelDialogView = [[LevelDialogView alloc] initWithFrame:self.view.bounds];
    levelDialogView.viewController = self;
    levelDialogView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:levelDialogView];
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
    self.theAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravityBehaviour = [[UIGravityBehavior alloc] init];
    self.gravityBehaviour.gravityDirection = CGVectorMake(0, -1);
    ViewController *controller = self;
    //球的吸附效果
    NSArray *arrayViews = self.arrayButtons;
    [self.gravityBehaviour setAction:^{
        for (UIView *ballView in arrayViews) {
            if (ballView.frame.origin.y <= circleY - radius) {
                UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:ballView
                                                                        snapToPoint:CGPointMake([controller getPositionXFor:(ballView.tag-1000) * M_PI / 3], [controller getPositionYFor:(ballView.tag-1000) * M_PI / 3])];
                [snapBehavior setAction:^{
                    
                }];
                [controller.theAnimator addBehavior:snapBehavior];
            }
            
        }
    }];
    [self.theAnimator addBehavior:self.gravityBehaviour];
    [self addCircle];
}

- (void)addCircle {
    int circleRadius = radius*1.5;
    self.circle = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - circleRadius, circleY - radius/2.0, 2 * circleRadius, 2 * circleRadius)];
    self.circle.layer.contents = (__bridge id)([UIImage imageNamed:@"play.png"].CGImage);
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

- (double)getPositionYFor:(double)radian {
    int y = circleY + radius + radius * sin(radian);
    return y;
}

- (double)getPositionXFor:(double)radian {
    double x = circleX + radius + radius * cos(radian);
    return x;
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


#pragma mark -
#pragma mark 动画
-(void)beginAnimation:(UIButton *)bt{
    //1.绕中心圆移动 Circle move   没用先
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
