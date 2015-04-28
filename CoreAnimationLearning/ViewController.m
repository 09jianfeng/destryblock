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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    radius = 60;
    circleX = self.view.frame.size.width/2 - radius;
    circleY = 100;
    [self initAnimatorAndGravity];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(circleX, circleY + 200, radius*2, 80)];
    self.label.textColor = [UIColor colorWithRed:0.3 green:0.2 blue:0.62 alpha:1.0];
    self.label.text = @"正常";
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerResponse:) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated{
//    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
//    CollectionViewControllerPlay *collecPlay = [[CollectionViewControllerPlay alloc] initWithCollectionViewLayout:flowlayout];
//    [self addChildViewController:collecPlay];
//    [self.view addSubview:collecPlay.view];
//    
    
////    //切换child view controller
//    [self transitionFromViewController:nil toViewController:collecPlay duration:4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//    }  completion:^(BOOL finished) {
//        //......
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 时间循环
-(void)timerResponse:(id)sender{
    if (ballNumber <= 5) {
        [self dropBall];
    }
}

-(void)buttonPressed:(id)sender{
    UIButton *button = (UIButton*)sender;
    int tag = button.tag;
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
#pragma mark 球的吸附效果
-(void)initAnimatorAndGravity{
    self.theAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravityBehaviour = [[UIGravityBehavior alloc] init];
    UIDynamicAnimator *animator = self.theAnimator;
    CGRect rect = self.view.bounds;
    ViewController *controller = self;
    //球的吸附效果
    [self.gravityBehaviour setAction:^{
        NSArray *arrayViews = [animator itemsInRect:rect];
        for (UIView *ballView in arrayViews) {
            if (ballView.frame.origin.y >= 400) {
                UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:ballView
                                                                        snapToPoint:CGPointMake([controller getPositionXFor:(ballView.tag-1000) * M_PI / 3], [controller getPositionYFor:(ballView.tag-1000) * M_PI / 3])];
                [controller.theAnimator addBehavior:snapBehavior];
            }
            
        }
    }];
    [self.theAnimator addBehavior:self.gravityBehaviour];
    [self addCircle];
}

- (void)addCircle {
    UIButton *circle = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - radius, circleY, 2 * radius, 2 * radius)];
    circle.backgroundColor = [UIColor grayColor];
    circle.layer.cornerRadius = radius;
    circle.tag = 2000;
    [circle addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:circle];
}

- (void)dropBall {
    if (ballNumber > 5) {
        return;
    }
    UIView *ballView = [self addBallView];
    [self.gravityBehaviour addItem:ballView];
    ballNumber++;
}

- (double)getPositionYFor:(double)radian {
    return circleY + radius + radius * sin(radian);
}

- (double)getPositionXFor:(double)radian {
    return circleX + radius + radius * cos(radian);
}

- (UIView *)addBallView {
    BallView *ballView = [[BallView alloc] initWithRadius:radius];
    ballView.tag = 1000+ballNumber;
    ballView.backgroundColor = [UIColor colorWithRed:(234.0 - ballNumber*40.0)/255.0 green:(222.0 - ballNumber*30.0)/255.0 blue:(180.0-ballNumber*20.0)/255.0 alpha:1.0];
    [ballView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ballView.center = CGPointMake(50, 100);
    ballView.highlighted = YES;
    [self.view addSubview:ballView];
    return ballView;
}

@end
