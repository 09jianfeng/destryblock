//
//  MLLKeychain.h
//  FeedBack
//
//  Created by youmi on 14-10-11.
//  Copyright (c) 2014年 chenjianfeng. All rights reserved.
//  读写keychain

#import <Foundation/Foundation.h>
#import <Security/Security.h>


void Gamesave(NSString *service, id data);
id Gameload(NSString *service);
void Gamedelete(NSString *service);

