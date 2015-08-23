//
//  MLLKeychain.m
//  FeedBack
//
//  Created by youmi on 14-10-11.
//  Copyright (c) 2014年 chenjianfeng. All rights reserved.
//
//  经测试,有时keychain会保存不成功

#import "GameKeychain.h"

static NSMutableDictionary *GamegetKeychainQuery(NSString *service) {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

void Gamesave(NSString *service, id data) {
    //save in keychain
    //Get search dictionary
    NSMutableDictionary *keychainQuery = GamegetKeychainQuery(service);
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

id Gameload(NSString *service) {
    //keychain
    id ret = nil;
    NSMutableDictionary *keychainQuery = GamegetKeychainQuery(service);
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

void Gamedelete(NSString *service) {
    //keychain
    NSMutableDictionary *keychainQuery = GamegetKeychainQuery(service);
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}
 