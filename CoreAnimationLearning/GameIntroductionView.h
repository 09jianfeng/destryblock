//
//  GameIntroductionView.h
//  chaigangkuai
//
//  Created by JFChen on 15/7/18.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface GameIntroductionView : UIView
@property(nonatomic, assign) ViewController *viewController;

-(void)gameBeginIntroduction;
@end
