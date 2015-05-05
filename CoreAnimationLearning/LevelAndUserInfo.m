//
//  LevelAndUserInfo.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/4.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "LevelAndUserInfo.h"
#import "GameKeyValue.h"

static NSString *levelinfo = @"levelinfoInkeyvalue";
static NSString *levelinfoIsPass = @"levelinfoIsPass";
static NSString *levelinfoScore = @"levelinfoScore";
static NSString *levelinfoTime = @"levelinfotime";
static NSString *levelinfoStarNum = @"levelinfoStarNum";

@interface LevelAndUserInfo()
@end

@implementation LevelAndUserInfo

static int  levelAllNum=90;

+(id)shareInstance{
    static LevelAndUserInfo *level = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        level = [[LevelAndUserInfo alloc] init];
    });
    return level;
}


+(NSArray *)levelInfos{
    NSArray *arraylevelInfo = [GameKeyValue objectForKey:levelinfo];
    if (arraylevelInfo) {
        return arraylevelInfo;
    }
    
    NSMutableArray *mutArrayLevels = [[NSMutableArray alloc] initWithCapacity:levelAllNum];
    for(int i = 0 ; i < levelAllNum ; i++){
        NSDictionary *leveldic = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",levelinfoIsPass,@"0",levelinfoScore,@"0",levelinfoStarNum, nil];
        [mutArrayLevels addObject:leveldic];
    }
    
    [GameKeyValue setObject:mutArrayLevels forKey:levelinfo];
    [GameKeyValue synchronize];
    return mutArrayLevels;
}

+(void)setLevelPass:(int)levelIndex points:(int)points{

}

//0 没有通过，1、2、3分别表示几颗星
+(int)isPassLevel:(int)levelIndex points:(int)points{
    return 0;
}

//返回剩余的体力值
+(int)getRestEnergy{
    return 0;
}

+(void)addEnergy:(int)energy{
    
}

+(void)reduceEnergy:(int)energy{

}
@end
