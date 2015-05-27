//
//  WebViewGifPlayer.m
//  CoreAnimationLearning
//
//  Created by JFChen on 15/5/27.
//  Copyright (c) 2015年 JFChen. All rights reserved.
//

#import "WebViewGifPlayer.h"

@implementation WebViewGifPlayer
-(void)beginPlayGifWithPath:(NSString *)pathResource{
    NSData *gifData = [NSData dataWithContentsOfFile:pathResource];
    self.userInteractionEnabled = NO;
    [self setScalesPageToFit:YES];
    [self stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 0.2"];
    [self loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
}
@end
