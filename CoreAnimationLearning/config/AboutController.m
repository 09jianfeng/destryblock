//
//  AboutController.m
//  LiuHeCaiBaoDian
//
//  Created by JFChen on 17/1/12.
//  Copyright © 2017年 陈建峰. All rights reserved.
//

#import "AboutController.h"
#import "AppDataStorage.h"

@interface AboutController ()
//新葡京
@property(strong, nonatomic) UIActivityIndicatorView *indicator;
@property(strong, nonatomic) UILabel *tips;
@property(strong, nonatomic) UIImageView *imageView;

@end

@implementation AboutController{
    int startLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - 新葡京

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_indicator) {
        return;
    }
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"Default"];
    [self.view addSubview:_imageView];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicator.backgroundColor = [UIColor grayColor];
    _indicator.frame = CGRectMake(0, 0, 50, 50);
    _indicator.layer.cornerRadius = 10.0;
        [self.view addSubview:_indicator];
    [_indicator startAnimating];
    _indicator.center = self.view.center;
    
    _tips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _tips.text = @"loading...";
    _tips.textColor = [UIColor blackColor];
    _tips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tips];
    _tips.center = CGPointMake(_indicator.center.x, _indicator.center.y + 100);
}

@end
