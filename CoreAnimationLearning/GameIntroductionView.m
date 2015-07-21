//
//  GameIntroductionView.m
//  chaigangkuai
//
//  Created by JFChen on 15/7/18.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "GameIntroductionView.h"
#import "GameDataGlobal.h"

@interface GameIntroductionView()<UIScrollViewDelegate>
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIPageControl *pageControl;
@property(nonatomic,retain) UIImageView *headerImageView;
@property(nonatomic,assign) int currentPage;
@end

@implementation GameIntroductionView

-(void)dealloc{
    self.pageControl = nil;
    self.headerImageView = nil;
    self.scrollView = nil;
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
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
    self.pageControl.numberOfPages = 5;
    [self addSubview:self.pageControl];
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    int imageViewSize = 200;
    for (int i = 0; i < imageCount; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        view.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 - imageViewSize/2, height*3/7 - imageViewSize/2, imageViewSize, imageViewSize)];
        imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_intro_%d",i+1]];
        [view addSubview:imageview];
        
        int imageviewfondheight = 140;
        UIImageView *imageviewwfond = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 - imageViewSize/2,imageview.frame.origin.y + imageview.frame.size.height + (height- imageview.frame.origin.y - imageview.frame.size.height- imageviewfondheight)/2, imageViewSize, imageviewfondheight)];
        imageviewwfond.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_intro_detail_%d",i+1]];
        [view addSubview:imageviewwfond];
        
        [self.scrollView addSubview:view];
    }
    
    int headerWidth = 180;
    int headerHeight = 60;
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 - headerWidth/2, (height*3/7 - imageViewSize/2)/2 - headerHeight/2, headerWidth, headerHeight)];
    self.headerImageView.image = [UIImage imageNamed:@"image_intro_header"];
    [self addSubview:self.headerImageView];
    
    self.backgroundColor = [GameDataGlobal getMainScreenBackgroundColor];
}

#pragma mark - scrollview的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPage = page;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*self.currentPage, 0) animated:YES];
    [self.pageControl setCurrentPage:self.currentPage];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{    
    if (self.scrollView.contentOffset.x > scrollView.frame.size.width*4) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL isFinish){
            [self removeFromSuperview];
        }];
    }
    
}

@end
