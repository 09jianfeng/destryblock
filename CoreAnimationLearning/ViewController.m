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

@property(nonatomic, retain) UIView *viewAirplane;
@property(nonatomic, retain) UIView *viewCloud1;
@property(nonatomic, retain) UIView *viewCloud2;
@property(nonatomic, retain) UIView *viewCloud3;
@property(nonatomic, assign) int circleNum;
@property(nonatomic, assign) int beginCircleNum;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayButtons = [[NSMutableArray alloc] initWithCapacity:6];
    radius = self.view.frame.size.width/7.0;
    circleX = self.view.frame.size.width/2 - radius;
    circleY = self.view.frame.size.height/1.5;
    [self addSubViews];
    [self initAnimatorAndGravity];
    [self alwaysMove:self.viewAirplane timeInterval:4];
    [self alwaysMove:self.viewCloud1 timeInterval:6];
    [self alwaysMove:self.viewCloud2 timeInterval:7];
    [self alwaysMove:self.viewCloud3 timeInterval:8];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerResponse:) userInfo:nil repeats:YES];
}

-(void)addSubViews{
    self.viewAirplane = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, 30, 30)];
    self.viewAirplane.backgroundColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.98 alpha:1.0];
    [self.view addSubview:self.viewAirplane];
    
    self.viewCloud1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 40, 40 , 20)];
    self.viewCloud1.backgroundColor = [UIColor colorWithRed:0.32 green:0.41 blue:0.98 alpha:1.0];
    [self.view addSubview:self.viewCloud1];
    
    self.viewCloud2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 70, 50 , 30)];
    self.viewCloud2.backgroundColor = [UIColor colorWithRed:0.22 green:0.21 blue:0.98 alpha:1.0];
    [self.view addSubview:self.viewCloud2];
    
    self.viewCloud3 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 100, 40 , 30)];
    self.viewCloud3.backgroundColor = [UIColor colorWithRed:0.42 green:0.11 blue:0.98 alpha:1.0];
    [self.view addSubview:self.viewCloud3];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(circleX, circleY + radius*2.5, radius*2, 40)];
    self.label.textColor = [UIColor colorWithRed:0.3 green:0.2 blue:0.62 alpha:1.0];
    self.label.text = @"正常";
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
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
#pragma mark 时间循环
-(void)timerResponse:(id)sender{
    self.beginCircleNum++;
    int begincircleLimit = 200;
    if (self.beginCircleNum > begincircleLimit) {
        self.beginCircleNum = begincircleLimit;
        for(UIView *ballView in self.arrayButtons){
            if ([ballView superview] == self.circle) {
                continue;
            }
            
            CGRect rect = [self.view convertRect:ballView.frame toView:self.circle];
            ballView.frame = rect;
            [ballView removeFromSuperview];
            [self.circle addSubview:ballView];
        }
        
        int circleNumDouble = 360*20;
        if (self.circleNum > circleNumDouble) {
            self.circleNum = 0;
        }
        self.circleNum++;
        self.circle.layer.affineTransform = CGAffineTransformMakeRotation(M_PI*2/(circleNumDouble) * _circleNum);
    }
}

-(void)buttonPressed:(id)sender{
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    switch (tag) {
        case 1000:
            self.label.text = @"正常1";
            break;
        case 1001:
            self.label.text = @"正常2";
            break;
        case 1002:
            self.label.text = @"正常3";
            break;
        case 1003:
            self.label.text = @"正常4";
            break;
        case 1004:
            self.label.text = @"正常5";
            break;
        case 1005:
            self.label.text = @"正常6";
            break;
        case 2000:
        {
            UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
            CollectionViewControllerPlay *collecPlay = [[CollectionViewControllerPlay alloc] initWithCollectionViewLayout:flowlayout];
            [self presentViewController:collecPlay animated:YES completion:nil];
        }
            break;
            
        default:
            break;
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
    ViewController *controller = self;
    //球的吸附效果
    NSArray *arrayViews = self.arrayButtons;
    [self.gravityBehaviour setAction:^{
        for (UIView *ballView in arrayViews) {
            if (ballView.frame.origin.y >= circleY - radius) {
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
    int circleRadius = radius*2;
    self.circle = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - circleRadius, circleY - radius, 2 * circleRadius, 2 * circleRadius)];
    self.circle.backgroundColor = [UIColor clearColor];
    self.circle.layer.cornerRadius = circleRadius;
    self.circle.tag = 2000;
    [self.circle addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    ballView.backgroundColor = [UIColor colorWithRed:(234.0 - ballNumber*40.0)/255.0 green:(222.0 - ballNumber*30.0)/255.0 blue:(180.0-ballNumber*20.0)/255.0 alpha:1.0];
    [ballView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ballView.center = CGPointMake(self.view.frame.size.width/2.0, 0);
    ballView.highlighted = YES;
    [self.view addSubview:ballView];
    return ballView;
}

@end
