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
NSString *levelinfoWidthNum = @"levelinfoWidthNum";
NSString *levelinfoColorNum = @"levelinfoColorNum";

@interface LevelAndUserInfo()
@end

@implementation LevelAndUserInfo

static int  levelAllNum=60;

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


#pragma mark - 生成过每一关需要的时间，设置关卡难易度
+(NSArray *)levelInfos{
    NSMutableArray *mutArrayLevels = [GameKeyValue objectForKey:levelinfo];
    if (mutArrayLevels) {
        return mutArrayLevels;
    }
    
    mutArrayLevels = [[NSMutableArray alloc] initWithCapacity:levelAllNum];
    for(int i = 0 ; i < levelAllNum ; i++){
        int time = 60 - i%10;
        int widthNum = 8 + (i/2)%3;
        int colorNum = 3 + i/6;
        int starNum = 0-i;
        int score = 1-i;
        
        NSString *timeString = [NSString stringWithFormat:@"%d",time];
        NSString *widthNumString = [NSString stringWithFormat:@"%d",widthNum];
        NSString *colorNumString = [NSString stringWithFormat:@"%d",colorNum];
        NSString *starNumString = [NSString stringWithFormat:@"%d",starNum];
        NSString *scoreString = [NSString stringWithFormat:@"%d",score];
        
        NSDictionary *leveldic = [NSDictionary dictionaryWithObjectsAndKeys:scoreString,levelinfoScore,starNumString,levelinfoStarNum,timeString,levelinfoTime,widthNumString,levelinfoWidthNum,colorNumString,levelinfoColorNum,nil];
        [mutArrayLevels addObject:leveldic];
    }
    
    [GameKeyValue setObject:mutArrayLevels forKey:levelinfo];
    [GameKeyValue synchronize];
    return mutArrayLevels;
}

#pragma mark - 通过这关
+(void)passLevel:(int)levelIndex points:(int)points startNum:(int)startNum{
    if (levelIndex >= [[[LevelAndUserInfo shareInstance] arrayLevelInfos]count]) {
        return;
    }
    
    NSDictionary *diclevelinfopre =[[[LevelAndUserInfo shareInstance] arrayLevelInfos] objectAtIndex:levelIndex];
    NSString *time = [diclevelinfopre objectForKey:levelinfoTime];
    NSString *width = [diclevelinfopre objectForKey:levelinfoWidthNum];
    NSString *colorNum = [diclevelinfopre objectForKey:levelinfoColorNum];
    
    int starNumPre = [[diclevelinfopre objectForKey:levelinfoStarNum] intValue];
    if (starNumPre > startNum) {
        startNum = starNumPre;
    }
    
    int scorePre = [[diclevelinfopre objectForKey:levelinfoScore] intValue];
    if (scorePre > points) {
        points = scorePre;
    }
    
    NSDictionary *diclevelinfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",points],levelinfoScore,[NSString stringWithFormat:@"%d",startNum],levelinfoStarNum,time,levelinfoTime,width,levelinfoWidthNum,colorNum,levelinfoColorNum,nil];
    [[[LevelAndUserInfo shareInstance] arrayLevelInfos] setObject:diclevelinfo atIndexedSubscript:levelIndex];
    [GameKeyValue setObject:[[LevelAndUserInfo shareInstance] arrayLevelInfos] forKey:levelinfo];
    [GameKeyValue synchronize];
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
