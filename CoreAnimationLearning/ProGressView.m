//
//  ProGressView.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/26.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "ProGressView.h"

@interface ProGressView()
@property(nonatomic, retain) UIView *innerView;
@end

@implementation ProGressView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.innerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, frame.size.height)];
        [self addSubview:_innerView];
        self.innerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:1.0];
        
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 2.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

//process是％分制的
-(void)setprocess:(float)process{
    float width = self.frame.size.width * process;
    self.innerView.frame = CGRectMake(0.0, 0.0, width, self.frame.size.height);
}
@end
