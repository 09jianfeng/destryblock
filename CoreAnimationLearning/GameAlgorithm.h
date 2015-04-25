//
//  GameAlgorithm.h
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/25.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    blockcolornone,
    blockcolor1,
    blockcolor2,
    blockcolor3,
    blockcolor4,
    blockcolor5,
    blockcolor6,
    blockcolor7,
    blockcolor8,
    blockcolor9,
    blockcolor10
}blockcolor;

@interface GameAlgorithm : NSObject
@property(nonatomic, assign) int widthNum;
@property(nonatomic, assign) int heightNum;

//输入位置返回颜色
-(blockcolor)getColorInthisPlace:(int)index;
@end
