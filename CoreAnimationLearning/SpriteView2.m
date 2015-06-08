//
//  SpriteView2.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/6/8.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "SpriteView2.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "macro.h"

@interface LPParticleLayer : CALayer
@property (nonatomic, strong) UIBezierPath *particlePath;
@end

@implementation LPParticleLayer
@end


@implementation SpriteView2
@dynamic completionCallback;

-(void)beginAnimation{
    //1.绕中心圆移动 Circle move   没添加进去先
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = false;
    pathAnimation.repeatCount = MAXFLOAT;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.frame, self.frame.size.width/2-3, self.frame.size.width/2-3);
    CGPathAddEllipseInRect(curvedPath, nil, circleContainer);
    pathAnimation.path = curvedPath;
    float randNumP = (arc4random()%5 + 20)/10.0;
    pathAnimation.duration = randNumP;
    
    //x方向伸缩
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.values = @[@1.0,@0.9,@1.0];
    scaleX.keyTimes = @[@0.0,@0.5,@1.0];
    scaleX.repeatCount = MAXFLOAT;
    scaleX.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    float randNumx = (arc4random()%20 + 20)/10.0;
    scaleX.duration = randNumx;
    
    //y方向伸缩
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.values = @[@1.0,@0.9,@1.0];
    scaleY.keyTimes = @[@0.0,@0.5,@1.0];
    scaleY.repeatCount = MAXFLOAT;
    scaleY.autoreverses = YES;
    scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    float randNumy = (arc4random()%20 + 20)/10.0;
    scaleY.duration = randNumy;
    
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.autoreverses = YES;
    groupAnnimation.duration = (arc4random()%30 + 30)/10.0;
    groupAnnimation.animations = @[scaleX, scaleY];
    groupAnnimation.repeatCount = MAXFLOAT;
    //开演
    [self.layer addAnimation:groupAnnimation forKey:@"groupAnnimation"];
}



-(void)dealloc{
    HNLOGINFO(@"shifang");
}

- (void)setCompletionCallback:(ExplodeCompletion)completionCallback
{
    [self willChangeValueForKey:@"completionCallback"];
    objc_setAssociatedObject(self, @selector(completionCallback), completionCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"completionCallback"];
}

- (ExplodeCompletion)completionCallback
{
    // obj assoc
    id object = objc_getAssociatedObject(self,@selector(completionCallback));
    return object;
}


float randomFloat()
{
    return (float)rand()/(float)RAND_MAX;
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (void)lp_explodeWithCallback:(ExplodeCompletion)callback
{
    
    self.userInteractionEnabled = NO;
    
    if (callback)
    {
        self.completionCallback = callback;
    }
    
    float size = self.frame.size.width/5;
    CGSize imageSize = CGSizeMake(size, size);
    
    CGFloat cols = self.frame.size.width / imageSize.width ;
    CGFloat rows = self.frame.size.height /imageSize.height;
    
    int fullColumns = floorf(cols);
    int fullRows = floorf(rows);
    
    CGFloat remainderWidth = self.frame.size.width  -
    (fullColumns * imageSize.width);
    CGFloat remainderHeight = self.frame.size.height -
    (fullRows * imageSize.height );
    
    
    if (cols > fullColumns) fullColumns++;
    if (rows > fullRows) fullRows++;
    
    CGRect originalFrame = self.layer.frame;
    CGRect originalBounds = self.layer.bounds;
    
    
    CGImageRef fullImage = [self imageFromLayer:self.layer].CGImage;
    
    //if its an image, set it to nil
    if ([self isKindOfClass:[UIImageView class]])
    {
        [(UIImageView*)self setImage:nil];
    }
    
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int y = 0; y < fullRows; ++y)
    {
        for (int x = 0; x < fullColumns; ++x)
        {
            CGSize tileSize = imageSize;
            
            if (x + 1 == fullColumns && remainderWidth > 0)
            {
                // Last column
                tileSize.width = remainderWidth;
            }
            if (y + 1 == fullRows && remainderHeight > 0)
            {
                // Last row
                tileSize.height = remainderHeight;
            }
            
            CGRect layerRect = (CGRect){{x*imageSize.width, y*imageSize.height},
                tileSize};
            
            CGImageRef tileImage = CGImageCreateWithImageInRect(fullImage,layerRect);
            
            LPParticleLayer *layer = [LPParticleLayer layer];
            layer.frame = layerRect;
            layer.contents = (__bridge id)(tileImage);
            layer.borderWidth = 0.0f;
            layer.borderColor = [UIColor blackColor].CGColor;
            layer.particlePath = [self pathForLayer:layer parentRect:originalFrame];
            [self.layer addSublayer:layer];
            
            CGImageRelease(tileImage);
        }
    }
    
    [self.layer setFrame:originalFrame];
    [self.layer setBounds:originalBounds];
    
    
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    NSArray *sublayersArray = [self.layer sublayers];
    [sublayersArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        LPParticleLayer *layer = (LPParticleLayer *)obj;
        
        //Path
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = layer.particlePath.CGPath;
        moveAnim.removedOnCompletion = YES;
        moveAnim.fillMode=kCAFillModeForwards;
        NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],nil];
        [moveAnim setTimingFunctions:timingFunctions];
        
        float r = randomFloat();
        
        NSTimeInterval speed = 2.35*r;
        
        CAKeyframeAnimation *transformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        CATransform3D startingScale = layer.transform;
        CATransform3D endingScale = CATransform3DConcat(CATransform3DMakeScale(randomFloat(), randomFloat(), randomFloat()), CATransform3DMakeRotation(M_PI*(1+randomFloat()), randomFloat(), randomFloat(), randomFloat()));
        
        NSArray *boundsValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:startingScale],
                                 
                                 [NSValue valueWithCATransform3D:endingScale], nil];
        [transformAnim setValues:boundsValues];
        
        NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:speed*.25], nil];
        [transformAnim setKeyTimes:times];
        
        
        timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                           nil];
        [transformAnim setTimingFunctions:timingFunctions];
        transformAnim.fillMode = kCAFillModeForwards;
        transformAnim.removedOnCompletion = NO;
        
        //alpha
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0f];
        opacityAnim.toValue = [NSNumber numberWithFloat:0.f];
        opacityAnim.removedOnCompletion = NO;
        opacityAnim.fillMode =kCAFillModeForwards;
        
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim,transformAnim,opacityAnim, nil];
        animGroup.duration = speed;
        animGroup.fillMode =kCAFillModeForwards;
        animGroup.delegate = self;
        [animGroup setValue:layer forKey:@"animationLayer"];
        [layer addAnimation:animGroup forKey:nil];
        
        //take it off screen
        [layer setPosition:CGPointMake(0, -600)];
        
    }];
}

- (void)lp_explode
{
    [self lp_explodeWithCallback:nil];
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    LPParticleLayer *layer = [theAnimation valueForKey:@"animationLayer"];
    
    if (layer)
    {
        //make sure we dont have any more
        if ([[self.layer sublayers] count]==1)
        {
            if (self.completionCallback)
            {
                self.completionCallback();
            }
            [self removeFromSuperview];
            
        }
        else
        {
            [layer removeFromSuperlayer];
        }
    }
}

-(UIBezierPath *)pathForLayer:(CALayer *)layer parentRect:(CGRect)rect
{
    UIBezierPath *particlePath = [UIBezierPath bezierPath];
    [particlePath moveToPoint:layer.position];
    
    float r = ((float)rand()/(float)RAND_MAX) + 0.3f;
    float r2 = ((float)rand()/(float)RAND_MAX)+ 0.4f;
    float r3 = r*r2;
    
    int upOrDown = (r <= 0.5) ? 1 : -1;
    
    CGPoint curvePoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    float maxLeftRightShift = 1.f * randomFloat();
    
    CGFloat layerYPosAndHeight = (self.superview.frame.size.height-((layer.position.y+layer.frame.size.height)))*randomFloat();
    CGFloat layerXPosAndHeight = (self.superview.frame.size.width-((layer.position.x+layer.frame.size.width)))*r3;
    
    float endY = self.superview.frame.size.height-self.frame.origin.y;
    
    if (layer.position.x <= rect.size.width*0.5)
    {
        //going left
        endPoint = CGPointMake(-layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown)*maxLeftRightShift,-layerYPosAndHeight);
    }
    else
    {
        endPoint = CGPointMake(layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown+rect.size.width)*maxLeftRightShift, -layerYPosAndHeight);
    }
    
    [particlePath addQuadCurveToPoint:endPoint
                         controlPoint:curvePoint];
    
    return particlePath;
    
}

@end

