//
//  LevelAndUserInfo.h
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/4.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelAndUserInfo : NSObject
+(NSArray *)levelInfos;
//0 没有通过，1、2、3分别表示几颗星.如果通过则写入文件
+(int)isPassLevel:(int)levelIndex points:(int)points;

//返回剩余的体力值
+(int)getRestEnergy;
+(void)addEnergy:(int)energy;
+(void)reduceEnergy:(int)energy;
@end
