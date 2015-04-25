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

#define widthnumber 50

@interface ViewController ()
@property(nonatomic, retain) NSArray *backgroundArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    CollectionViewControllerPlay *collecPlay = [[CollectionViewControllerPlay alloc] initWithCollectionViewLayout:flowlayout];
    [self addChildViewController:collecPlay];
    [self.view addSubview:collecPlay.view];
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

@end
