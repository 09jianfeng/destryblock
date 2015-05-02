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
#import "LevelDialogView.h"
#import <Accelerate/Accelerate.h>

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
    circleY = radius*4;
    [self addSubViews];
//    [self alwaysMove:self.viewAirplane timeInterval:4];
//    [self alwaysMove:self.viewCloud1 timeInterval:6];
//    [self alwaysMove:self.viewCloud2 timeInterval:7];
//    [self alwaysMove:self.viewCloud3 timeInterval:8];
    
    UIImage *image = [UIImage imageNamed:@"91.png"];
    UIImage *image1 = [self blurryImage:image withBlurLevel:0.8];
    self.view.layer.contents = (__bridge id)(image1.CGImage);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerResponse:) userInfo:nil repeats:YES];
}

//加模糊效果，image是图片，blur是模糊度
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    //模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)) {
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    NSLog(@"boxSize:%i",boxSize);
    //图像处理
    CGImageRef img = image.CGImage;
    //需要引入#import <Accelerate/Accelerate.h>
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
//    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


-(void)addSubViews{
    self.viewAirplane = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, 30, 30)];
//    self.viewAirplane.backgroundColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.98 alpha:1.0];
    self.viewAirplane.layer.contents = (__bridge id)([UIImage imageNamed:@"10.png"].CGImage);
//    [self.view addSubview:self.viewAirplane];
    
    self.viewCloud1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 40, 30 , 30)];
//    self.viewCloud1.backgroundColor = [UIColor colorWithRed:0.32 green:0.41 blue:0.98 alpha:1.0];
    self.viewCloud1.layer.contents = (__bridge id)([UIImage imageNamed:@"11.png"].CGImage);
//    [self.view addSubview:self.viewCloud1];
    
    self.viewCloud2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 70, 30 , 30)];
//    self.viewCloud2.backgroundColor = [UIColor colorWithRed:0.22 green:0.21 blue:0.98 alpha:1.0];
    self.viewCloud2.layer.contents = (__bridge id)([UIImage imageNamed:@"12.png"].CGImage);
//    [self.view addSubview:self.viewCloud2];
    
    self.viewCloud3 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 100, 30 , 30)];
    self.viewCloud3.layer.contents = (__bridge id)([UIImage imageNamed:@"9.png"].CGImage);
//    self.viewCloud3.backgroundColor = [UIColor colorWithRed:0.42 green:0.11 blue:0.98 alpha:1.0];
//    [self.view addSubview:self.viewCloud3];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(circleX, circleY + radius*2.5, radius*2, 40)];
    self.label.textColor = [UIColor colorWithRed:0.3 green:0.2 blue:0.62 alpha:1.0];
    self.label.text = @"1";
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
//    int collecplaywidth = 200;
//    int collecplayheiht = 120;
//    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
//    CollectionViewControllerPlay *collecPlay = [[CollectionViewControllerPlay alloc] initWithCollectionViewLayout:flowlayout];
//    collecPlay.view.backgroundColor = [UIColor clearColor];
//    collecPlay.collectionView.backgroundColor = [UIColor clearColor];
//    collecPlay.noBackgroundImage = YES;
//    collecPlay.widthNum = 9;
//    collecPlay.view.frame = CGRectMake(self.view.frame.size.width/2 - collecplaywidth/2, radius*4, collecplaywidth, collecplayheiht);
//    [self addChildViewController:collecPlay];
//    [self.view addSubview:collecPlay.view];
    
    [self initAnimatorAndGravity];
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
#pragma mark 时间循环与按钮事件
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
//        self.circle.layer.affineTransform = CGAffineTransformMakeRotation(M_PI*2/(circleNumDouble) * _circleNum);
    }
}

-(void)buttonPressed:(id)sender{
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    switch (tag) {
        case 1000:
            self.label.text = @"1";
            break;
        case 1001:
            self.label.text = @"2";
            break;
        case 1002:
            self.label.text = @"3";
            break;
        case 1003:
            self.label.text = @"4";
            break;
        case 1004:
            self.label.text = @"5";
            break;
        case 1005:
            self.label.text = @"6";
            break;
        case 2000:
        {
            LevelDialogView *levelDialogView = [[LevelDialogView alloc] initWithFrame:self.view.bounds];
            levelDialogView.viewController = self;
            levelDialogView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:levelDialogView];
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
    int circleRadius = radius;
    self.circle = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - circleRadius, circleY, 2 * circleRadius, 2 * circleRadius)];
    self.circle.layer.contents = (__bridge id)([UIImage imageNamed:@"playbegin.jpg"].CGImage);
//    self.circle.backgroundColor = [UIColor blackColor];
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
    ballView.backgroundColor = [UIColor colorWithRed:(224.0 - ballNumber*30.0)/255.0 green:(224.0 - ballNumber*30.0)/255.0 blue:(224.0-ballNumber*30.0)/255.0 alpha:1.0];
    [ballView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ballView.center = CGPointMake(self.view.frame.size.width/2.0, 0);
    ballView.highlighted = YES;
    ballView.layer.shadowColor = [UIColor colorWithRed:0.4 green:0.7 blue:0.3 alpha:1.0].CGColor;
//    ballView.layer.shadowOffset = CGSizeMake(-5, 5);
    ballView.layer.shadowOpacity = 0.5;
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, ballView.bounds);
    ballView.layer.shadowPath = circlePath; CGPathRelease(circlePath);
    [self.view addSubview:ballView];
    return ballView;
}

@end
