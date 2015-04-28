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

#define widthnumber 50

@interface ViewController (){
    float radius;
    float circleCenterX;
    float circleCenterY;
    int count;
    int ballNumber;
    UIButton *dropBallButton;
}

@property(nonatomic, retain) UIDynamicAnimator *theAnimator;
@property(nonatomic, retain) UIGravityBehavior *gravityBehaviour;
@property(nonatomic, retain) NSArray *backgroundArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    radius = 40;
    circleCenterX = 120;
    circleCenterY = 200;
    self.theAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self addCircle];
    [self addButton];
}

- (void)viewDidAppear:(BOOL)animated{
//    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
//    CollectionViewControllerPlay *collecPlay = [[CollectionViewControllerPlay alloc] initWithCollectionViewLayout:flowlayout];
//    [self addChildViewController:collecPlay];
//    [self.view addSubview:collecPlay.view];
    
    
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
- (void)addCircle {
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(120, 200, 2 * radius, 2 * radius)];
    circle.backgroundColor = [UIColor blackColor];
    circle.layer.cornerRadius = 40;
    [self.view addSubview:circle];
}

- (void)addButton {
    dropBallButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dropBallButton setFrame:CGRectMake(110, 400, 100, 20)];
    [dropBallButton setTitle:@"Drop ball" forState:UIControlStateNormal];
    [dropBallButton addTarget:self action:@selector(dropBall) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:dropBallButton];
}

- (void)dropBall {
    [self resetStatus];
    UIView *ballView = [self addBallView];
    [self addDynamicBehaviour:ballView];
    ballNumber++;
}

- (void)addDynamicBehaviour:(UIView *)ballView {
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[ballView]];
    [gravityBehaviour setAction:^{
        count++;
        if (count == 50) {
            UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:ballView
                                                                    snapToPoint:CGPointMake([self getPositionXFor:ballNumber * M_PI / 3], [self getPositionYFor:ballNumber * M_PI / 3])];
            [self.theAnimator addBehavior:snapBehavior];
            [dropBallButton setEnabled:ballNumber != 6];
        }
    }];
    [self.theAnimator addBehavior:gravityBehaviour];
}

- (void)resetStatus {
    count = 0;
    [self.theAnimator removeAllBehaviors];
    [dropBallButton setEnabled:NO];
}

- (double)getPositionYFor:(double)radian {
    return circleCenterY + radius + radius * sin(radian);
}

- (double)getPositionXFor:(double)radian {
    return circleCenterX + radius + radius * cos(radian);
}

- (UIView *)addBallView {
    UIView *ballView = [[BallView alloc] init];
    ballView.center = CGPointMake(50, 100);
    [self.view addSubview:ballView];
    return ballView;
}

@end
