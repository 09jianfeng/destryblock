//
//  GameAlgorithm.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/25.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "GameAlgorithm.h"

#define allblockNumpercent 0.65
#define blockTypeNumpercent 0.03

@interface GameAlgorithm(){
    //表格盘总数
    int a[30][30];
    //随机的时候用
    int b[900];
}

//所有彩色砖头的数量
@property(nonatomic,assign) int allValueblockNum;
//所有砖头的种类
@property(nonatomic,assign) int blockTypeNum;

//横向有多少个表格
@property(nonatomic,assign) int widthNum;
//竖向有多少个表格
@property(nonatomic,assign) int heightNum;
@end


@implementation GameAlgorithm
-(id)initWithWidthNum:(int)widthNum heightNum:(int)heightNum{
    self = [super init];
    if (self) {
        [self initTable:widthNum heightNum:heightNum];
    }
    return self;
}

-(void)initTable:(int)widthNum heightNum:(int)heightNum{
    for (int i = 0; i < widthNum; i++) {
        for (int j = 0; j < heightNum; j++) {
            a[i][j] = 0;
            b[heightNum*i + j] = heightNum*i + j;
        }
    }
    
    self.widthNum = widthNum;
    self.heightNum = heightNum;
    self.allValueblockNum = widthNum * heightNum * allblockNumpercent;
    self.blockTypeNum = widthNum * heightNum * blockTypeNumpercent;
    
    int allblockNum = widthNum*heightNum;
    for (int i = 0; i < _allValueblockNum; i+=2) {
        int blockColorrandom = arc4random()%(_blockTypeNum+1)+1;
        for (int j = 0; j < 2; j++) {
            
            int endIndex = allblockNum - i - j;
            int blockLocationrandom = arc4random()%(endIndex);
            //从b数组中取出值
            int aGetValueIndex = b[blockLocationrandom];
            //给a数组的某个位置赋颜色值
            int widthindex = aGetValueIndex%_widthNum;
            int heightIndex = aGetValueIndex/_widthNum;
            a[widthindex][heightIndex] = blockColorrandom;
            
            //把赋值了的位置移到b数组的最后面
            b[blockLocationrandom] = b[endIndex];
            b[endIndex] = -1;
        }
    }
}

//输入位置返回颜色
-(blockcolor)getColorInthisPlace:(int)index{
    int widthindex = index%_widthNum;
    int heightIndex = index/_widthNum;
    return a[widthindex][heightIndex];
}

-(NSArray *)getplacethatShoulddrop:(int)index{
    return nil;
}
@end
