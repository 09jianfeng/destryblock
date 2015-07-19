//
//  GameIntroductionView.m
//  chaigangkuai
//
//  Created by JFChen on 15/7/18.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "GameIntroductionView.h"
#import "GameDataGlobal.h"

@interface GameIntroductionView()
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) NSTimer *timer;
@property(nonatomic,assign) int timeCount;
@end

@implementation GameIntroductionView

-(void)dealloc{
    self.scrollView = nil;
    self.timer = nil;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)gameBeginIntroduction{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    int imageCount = 5;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*5, self.scrollView.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = NO;
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imageView.backgroundColor = [GameDataGlobal getColorInColorType:i+2];
        [self.scrollView addSubview:imageView];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerResponer:) userInfo:nil repeats:YES];
}

-(void)timerResponer:(id)sender{
    _timeCount++;
    if (_timeCount == 5) {
        [self.timer invalidate];
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.alpha = 0.0;
        } completion:^(BOOL isFinish){
            [self removeFromSuperview];
        }];
        return;
    }
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*_timeCount, 0) animated:YES];
}

@end
