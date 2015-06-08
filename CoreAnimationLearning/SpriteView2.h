//
//  SpriteView2.h
//  CoreAnimationLearning
//
//  Created by JFChen on 15/6/8.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExplodeCompletion)(void);

@interface SpriteView2 : UIView
@property (nonatomic, copy) ExplodeCompletion completionCallback;

- (void)lp_explode;
- (void)lp_explodeWithCallback:(ExplodeCompletion)callback;
-(void)beginAnimation;
@end
