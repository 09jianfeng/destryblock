//
//  SystemInfo.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/4/27.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "SystemInfo.h"
#import <UIKit/UIKit.h>

@implementation SystemInfo
BOOL IsPadUIBlockGame(){
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}
@end
