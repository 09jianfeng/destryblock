//
//  GameResultData.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/31.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "GameResultData.h"
#import "GameKeyValue.h"

static NSString *GAMERESULTDATAKEY = @"GAMERESULTDATAKEY";

@implementation GameResultData
+(void)gameResultAddBrockenBlocks:(int)blocks{
    int allBlocksPre = [GameResultData getAllBlockenBlocks];
    allBlocksPre += blocks;
    [GameKeyValue setObject:[NSNumber numberWithInt:allBlocksPre] forKey:GAMERESULTDATAKEY];
}


+(int)getAllBlockenBlocks{
    return [[GameKeyValue objectForKey:GAMERESULTDATAKEY] intValue];
}
@end
