//
//  ChlipVideo.h
//  ChlipVideo
//
//  Created by joying on 15/11/26.
//  Copyright (c) 2015年 Joying. All rights reserved.
//  视频sdk版本号：3.0.1
//
#import <UIKit/UIKit.h>

/*
 * 视频下载失败通知。userinfo有下载失败的视频的名字
 */
extern NSString *ChlipVideoDownloadFailNotification;
/*
 * 全屏按钮按下后的通知，一般用于状态栏的隐藏与显示
 */
extern NSString *ChlipVideoNotificationFullButtonPress;


@class ChlipBannerView;
@interface ChlipMobiVideoAd : UIWebView

#pragma mark - 公共接口

/**
 * 初始化appid和secretId
 * 您需要先在掌盈官网注册并创建一个应用，在项目初始化的时候调用本方法传入对应的值
 */
+(void)ChlipInitAppID:(NSString *)appId ChlipAppKey:(NSString *)appKey;

/*
 * 是否还有视频可以播放  ［可选］
 * isHaveVideoStatue的值目前有两个
 * 0：有视频可以播放
 * 1：暂时没有可播放视频
 * 2：网络状态不好
 */
+(void)ChlipVideoHasCanPlayVideo:(void(^)(int isHaveVideoStatue))backCallBlock;

/*
 * 关闭视频  ［可选］
 */
+(void)ChlipVideoCloseVideoPlayer;

/*
 * 设置是否关闭点击关闭按钮时弹出的『中途退出没有奖励』弹出框  ［可选］
 */
+(void)ChlipVideoCloseAlertViewWhenWantExit:(BOOL)isClose;

/*
 * 是否应用内AppStore打开下载页面，默认不支持
 */
+(void)ChlipVideoIsOpenInAppStore;

#pragma mark - 全屏播放视频的相关接口

/*
 *
 * 开始播放视频 ［全屏］ ［必须］
 *
 * 传入当前的viewController。视频将会以viewController presentMoviePlayerViewControllerAnimated:VideoController的方式呈现
 * Unity3D或者其他游戏引擎最好传入[[[UIApplication sharedApplication] keyWindow] rootViewController]
 *
 * ChlipVideoPlayFinishCallBackBlock是视频播放完成后马上回调,isFinishPlay为true则是用户完全播放，为false则是用户中途退出
 *
 * ChlipVideoPlayConfigCallBackBlock会在sdk的服务器最终确认这次播放是否有效后回掉（播放完成后有网络请求，网络不好可能有延时）。
 *
 * 注意：  isLegal在（app有联网，并且注册的appkey后台审核通过）的情况下才返回yes, 否则都是返回no.
 */
+(void)ChlipVideoPlay:(UIViewController *)viewController ChlipVideoPlayFinishCallBackBlock:(void(^)(BOOL isFinishPlay))block ChlipVideoPlayConfigCallBackBlock:(void(^)(BOOL isLegal))configBlock;

/**
 * 设置是否强制横屏，默认是强制横屏 [全屏] ［可选］
 */
+(void)ChlipVideoIsForceLandscape:(BOOL)isForce;


#pragma mark - 非全屏，嵌入式视频

/*
 * 开始播放视频［非全屏］［必须］
 *
 * 传入当前的viewController。Unity3D或者其他游戏引擎最好传入[[[UIApplication shareApplication] keyWindow] rootViewController]
 * ChlipVideoPlayerFrame是视频的frame,superView是用于 ［addSubView：视频view］的，一般情况下可以传入viewController.view
 *
 * 注意：  isLegal在（app有联网，并且注册的appkey后台审核通过）的情况下才返回yes, 否则都是返回no.
 */
+(void)ChlipVideoPlay:(UIViewController *)viewController ChlipVideoSuperView:(UIView *)superView ChlipVideoPlayerFrame:(CGRect)ChlipVideoPlayerFrame ChlipVideoPlayFinishCallBackBlock:(void(^)(BOOL isFinish))block ChlipVideoPlayConfigCallBackBlock:(void(^)(BOOL isLegal))configBlock;


/**
 *
 *开始展示banner条［可选］
 *
 * ChlipVideoPlayerFrame是视频的frame,
 * closeBlock是关闭回调
 */
+(ChlipBannerView *)ChlipVideoBannerPlayerFrame:(CGRect)ChlipVideoPlayerFrame ChlipVideoBannerPlayCloseCallBackBlock:(void(^)(BOOL isLegal))closeBlock;



/*
 * 设置左旋转全屏还是右旋转全屏［非全屏］［可选］
 * 0:复原
 * 1:左旋转全屏
 * 2:右旋转全屏
 */
+(void)ChlipVideoIslandscapeLeftOrRight:(int)vidoeShowStuts;

/*
 * 开发者需要自定义界面的时候用到，隐藏右下角的<全屏>按钮
 */
+(void)ChlipVideoHiddenFullScreenButtonView;

/**
 *
 * 按钮事件      ［可选］
 *
 * 开发者需要自定义界面的时候用到，默认的广告界面的按钮跟“剩余多少秒”的view会隐藏.
 * 开发者需要自定义button与“剩余多少秒”的view
 */
+(void)ChlipVideoHiddenDefaultButtonView;

/*
 * 剩余时间，还没开始播放时返回－1。开发者需要设置一个定时器。每秒获取一次
 */
+(int)ChlipVideoGetRestPlayerTime;

/**
 * 关闭
 */
+(void)ChlipVideoButtonClosePressed;

/**
 * 静音或者开启
 */
+(void)ChlipVideoButtonVoicePressed;

/**
 * 下载
 */
+(void)ChlipVideoDownloadPressed;

/**
 * 全屏
 */
+(void)ChlipVideoButtonFullScreenPressed;

/*
 *暂停视频播放
 */
+(void)ChlipPauseVideoPlay;

/*
 *继续视频播放
 */
+(void)ChlipContinueVideoPlay;

/** 设置关闭弹出框的内容
 *  注：默认内容为（确认退出观看视频？）， 但是有些开发者需要做点不一样的提示，如：中途退出无法获得奖励哟～
 */
+(void)ChlipVideosetCloseAlertContent:(NSString *)content;

/**
 * wifi模式下缓存视频文件（可选）
 */
+(void)ChlipVideoCacheVideoFile;

/**
 * 隐藏前贴片详情页的重放按钮 (可选)
 */
+(void)ZyinVideoDetailReplayHide:(BOOL)ynHide;

/**
 * 是否有可播放的缓存视频
 */
+(BOOL)ChlipVideoIsCacheVideoFile;
@end
