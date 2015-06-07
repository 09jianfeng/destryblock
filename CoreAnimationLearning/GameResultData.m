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

+(UIColor *)getMainScreenBackgroundColor{
    return [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0];
}

+(UIColor *)getLockColor{
   return [UIColor colorWithRed:145.0/255.0 green:115.0/255.0 blue:145.0/255.0 alpha:1.0];
}

+(UIColor *)getUnLockColor{
    return [UIColor colorWithRed:10/255.0 green:83/255.0 blue:84/255.0 alpha:1.0];
}

+(UIColor *)getColorInColorType:(int)blockcolorType{
    switch (blockcolorType) {
        case 0:
            return nil;
            break;
        case 1:
            return [UIColor colorWithRed:10/255.0 green:83/255.0 blue:84/255.0 alpha:1.0];;
            break;
        case 2:
            return [UIColor colorWithRed:200/255.0 green:73/255.0 blue:84/255.0 alpha:1.0];
            break;
        case 3:
            return [UIColor colorWithRed:150/255.0 green:83/255.0 blue:74/255.0 alpha:1.0];
            break;
        case 4:
            return [UIColor colorWithRed:80/255.0 green:83/255.0 blue:84/255.0 alpha:1.0];
            break;
            
        case 5:
            return [UIColor colorWithRed:40/255.0 green:103/255.0 blue:34/255.0 alpha:1.0];
            break;
        case 6:
            return [UIColor colorWithRed:150/255.0 green:63/255.0 blue:204/255.0 alpha:1.0];
            break;
        case 7:
            return [UIColor colorWithRed:200/255.0 green:103/255.0 blue:64/255.0 alpha:1.0];
            break;
        case 8:
            return [UIColor colorWithRed:80/255.0 green:83/255.0 blue:84/255.0 alpha:1.0];
            break;
        case 9:
            return [UIColor colorWithRed:110/255.0 green:83/255.0 blue:84/255.0 alpha:1.0];
            break;
        case 10:
            return [UIColor colorWithRed:10/255.0 green:43/255.0 blue:84/255.0 alpha:1.0];
            break;
        case 11:
            return [UIColor colorWithRed:220/255.0 green:83/255.0 blue:44/255.0 alpha:1.0];
            break;
        case 12:
            return [UIColor colorWithRed:50/255.0 green:30/255.0 blue:84/255.0 alpha:1.0];
            break;
            
        default:
            return nil;
            break;
    }
    return nil;
}
@end
