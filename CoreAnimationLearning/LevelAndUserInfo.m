//
//  LevelAndUserInfo.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/4.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "LevelAndUserInfo.h"
#import "GameKeyValue.h"

NSString *levelinfo = @"levelinfoInkeyvalue";
NSString *levelinfoScore = @"levelinfoScore";
NSString *levelinfoTime = @"levelinfotime";
NSString *levelinfoStarNum = @"levelinfoStarNum";

@interface LevelAndUserInfo()
@property(nonatomic,retain) NSMutableArray *arrayLevelInfos;
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

-(id)init{
    self = [super init];
    if (self) {
        self.arrayLevelInfos = [[NSMutableArray alloc] initWithArray:[LevelAndUserInfo levelInfos] copyItems:YES];
    }
    return self;
}

//生成过每一关需要的时间
+(NSArray *)levelInfos{
    NSMutableArray *mutArrayLevels = [GameKeyValue objectForKey:levelinfo];
    if (mutArrayLevels) {
        return mutArrayLevels;
    }
    
    mutArrayLevels = [[NSMutableArray alloc] initWithCapacity:levelAllNum];
    for(int i = 0 ; i < levelAllNum ; i++){
        int time = 60 - levelAllNum%10;
        NSString *timeString = [NSString stringWithFormat:@"%d",time];
        NSDictionary *leveldic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",levelinfoScore,@"0",levelinfoStarNum,timeString,levelinfoTime, nil];
        [mutArrayLevels addObject:leveldic];
    }
    
    [GameKeyValue setObject:mutArrayLevels forKey:levelinfo];
    return mutArrayLevels;
}

//通过这关
+(void)passLevel:(int)levelIndex points:(int)points startNum:(int)startNum{
    NSDictionary *diclevelinfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",points],levelinfoScore,[NSString stringWithFormat:@"%d",startNum],levelinfoStarNum,@"60",levelinfoTime, nil];
    [[[LevelAndUserInfo shareInstance] arrayLevelInfos] setObject:diclevelinfo atIndexedSubscript:levelIndex];
    [GameKeyValue setObject:[[LevelAndUserInfo shareInstance] arrayLevelInfos] forKey:levelinfo];
}

//0 没有通过，1、2、3分别表示几颗星
+(int)isPassLevel:(int)levelIndex{
    NSArray *arraylevelInfo = [GameKeyValue objectForKey:levelinfo];
    if (!arraylevelInfo) {
        return 0;
    }
    
    NSDictionary *levelInfoa = [arraylevelInfo objectAtIndex:levelIndex];
    int starNum = [[levelInfoa objectForKey:levelinfoStarNum] intValue];
    
    return starNum;
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
