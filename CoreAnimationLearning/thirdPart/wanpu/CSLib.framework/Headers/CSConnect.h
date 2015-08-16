#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

#define LIB_VERSION_NUMBER         @"3.0"

static  NSString *appID_;
@interface CSConnect : NSObject{
    NSString *userID_;
    NSString *plugin_;
    NSMutableData *data_;
    int connectAttempts_;
    BOOL isInitialConnect_;
    NSInteger responseCode_;
    NSURLConnection *connectConnection_;
    NSURLConnection *userIDConnection_;
    NSURLConnection *SDKLessConnection_;
    NSString *appChannel_;
    NSString *appleID_;
}
@property(nonatomic, copy) NSString *appChannel;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *plugin;
@property(nonatomic, copy) NSMutableDictionary *configItems;
@property(nonatomic, copy) NSString *appleID;
@property(assign) BOOL isInitialConnect;
@property(assign) BOOL isAutoGetPoints;

+ (CSConnect *)getConnect:(NSString *)id;

+ (CSConnect *)getConnect:(NSString *)id pid:(NSString *)channel;

+ (CSConnect *)getConnect:(NSString *)id pid:(NSString *)channel userID:(NSString *)theUserID;

+ (CSConnect *)sharedCSConnect;

+ (NSString *)getUserID;

+ (NSMutableDictionary *)getConfigItems;

+ (NSString *)getAPPID;

@end

@interface CSConnect (CSHFViewHandler)

+ (void)showHF:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

+ (void)showHF:(UIViewController *)vController adSize:(NSString *)aSize;

+ (void)showHF:(UIViewController *)vController;

+ (void)showHF:(UIViewController *)vController showX:(CGFloat)x showY:(CGFloat)y;

+ (void)closeHF;

@end

@interface CSConnect (CSCPViewController)

+ (void)initCP;

+ (void)showCP:(UIViewController *)controller;

+ (void)closeCP;

@end

@interface CSCallsWrapper : UIViewController {
    UIInterfaceOrientation currentInterfaceOrientation;
}

@property(assign) UIInterfaceOrientation currentInterfaceOrientation;

+ (CSCallsWrapper *)sharedCSCallsWrapper;

- (void)updateViewsWithOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end






