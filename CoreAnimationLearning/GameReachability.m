/*
 
 File: GameReachability.m
 Abstract: Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 
 Version: 2.0.4ddg
 */

/*
 Significant additions made by Andrew W. Donoho, August 11, 2009.
 This is a derived work of Apple's GameReachability v2.0 class.
 
 The below license is the new BSD license with the OSI recommended personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>
 
 Extensions Copyright (C) 2009 Donoho Design Group, LLC. All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Andrew W. Donoho nor Donoho Design Group, L.L.C.
 may be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY DONOHO DESIGN GROUP, L.L.C. "AS IS" AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */


/*
 
 Apple's Original License on GameReachability v2.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2009 Apple Inc. All Rights Reserved.
 
 */

/*
 Each GameReachability object now has a copy of the key used to store it in a dictionary.
 This allows each observer to quickly determine if the event is important to them.
 */

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#import "GameReachability.h"

NSString *const GamekInternetConnection  = @"HNInternetConnection";
NSString *const GamekLocalWiFiConnection = @"HNLocalWiFiConnection";
NSString *const GamekReachabilityChangedNotification = @"HNNetworkReachabilityChangedNotification";

#define CLASS_DEBUG 1 // Turn on logReachabilityFlags. Must also have a project wide defined DEBUG.

#if (defined DEBUG && defined CLASS_DEBUG)
#define logReachabilityFlags(flags) (HNlogReachabilityFlags_(__PRETTY_FUNCTION__, __LINE__, flags))

static NSString *GameReachabilityFlags_(SCNetworkReachabilityFlags flags) {
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) // Apple advises you to use the magic number instead of a symbol.
    return [NSString stringWithFormat:@"GameReachability Flags: %c%c %c%c%c%c%c%c%c",
            (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
            (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
            
            (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
            (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
            (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
            (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
            (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
#else
    // Compile out the v3.0 features for v2.2.1 deployment.
    return [NSString stringWithFormat:@"GameReachability Flags: %c%c %c%c%c%c%c%c",
            (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
            (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
            
            (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
            (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
            (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
            // v3 kSCNetworkReachabilityFlagsConnectionOnTraffic == v2 kSCNetworkReachabilityFlagsConnectionAutomatic
            (flags & kSCNetworkReachabilityFlagsConnectionAutomatic)  ? 'C' : '-',
            // (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-', // No v2 equivalent.
            (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
            (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
#endif
    
} // GameReachabilityFlags_()

static void HNlogReachabilityFlags_(const char *name, int line, SCNetworkReachabilityFlags flags) {
    
    HNLOGINFO(@"%s (%d) \n\t%@", name, line, GameReachabilityFlags_(flags));
    
} // HNlogReachabilityFlags_()

#define logNetworkStatus(status) (HNlogNetworkStatus_(__PRETTY_FUNCTION__, __LINE__, status))

static void GamelogNetworkStatus_(const char *name, int line, GameNetworkStatus status) {
    
    NSString *statusString = nil;
    
    switch (status) {
        case GamekNotReachable:
            statusString =  @"Not Reachable";
            break;
        case GamekReachableViaWWAN:
            statusString =  @"Reachable via WWAN";
            break;
        case GamekReachableViaWiFi:
            statusString =  @"Reachable via WiFi";
            break;
    }
    
    HNLOGINFO(@"%s (%d) \n\tNetwork Status: %@", name, line, statusString);
    
} // HNlogNetworkStatus_()

#else
#define logReachabilityFlags(flags)
#define logNetworkStatus(status)
#endif

@interface GameReachability (private)

- (GameNetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags;

@end

@implementation GameReachability

@synthesize key = key_;

// Preclude direct access to ivars.
+ (BOOL) accessInstanceVariablesDirectly {
    
    return NO;
    
} // accessInstanceVariablesDirectly


- (void) dealloc {
    
    [self stopNotifier];
    if(reachabilityRef) {
        
        CFRelease(reachabilityRef); reachabilityRef = NULL;
        
    }
    
    self.key = nil;
    
    [super dealloc];
    
} // dealloc


- (GameReachability *) initWithReachabilityRef: (SCNetworkReachabilityRef) ref
{
    self = [super init];
    if (self != nil)
    {
        reachabilityRef = ref;
    }
    
    return self;
    
} // initWithReachabilityRef:


#if (defined DEBUG && defined CLASS_DEBUG)
- (NSString *) description {
    
    NSAssert(reachabilityRef, @"-description called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags = 0;
    
    SCNetworkReachabilityGetFlags(reachabilityRef, &flags);
    
    return [NSString stringWithFormat: @"%@\n\t%@", self.key, GameReachabilityFlags_(flags)];
    
} // description
#endif


#pragma mark -
#pragma mark Notification Management Methods


//Start listening for GameReachability notifications on the current run loop
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
    
#pragma unused (target, flags)
    NSCAssert(info, @"info was NULL in ReachabilityCallback");
    NSCAssert([(NSObject*) info isKindOfClass: [GameReachability class]], @"info was the wrong class in ReachabilityCallback");
    
    //We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
    // in case someone uses the Reachablity object in a different thread.
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    
    // Post a notification to notify the client that the network GameReachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName: GamekReachabilityChangedNotification
                                                        object: (GameReachability *) info];
    
    [pool release];
    
} // ReachabilityCallback()


- (BOOL) startNotifier {
    
    SCNetworkReachabilityContext	context = {0, self, NULL, NULL, NULL};
    
    if(SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context)) {
        
        if(SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
            
            return YES;
            
        }
        
    }
    
    return NO;
    
} // startNotifier


- (void) stopNotifier {
    
    if(reachabilityRef) {
        
        SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        
    }
    
} // stopNotifier


- (BOOL) isEqual: (GameReachability *) r {
    
    return [r.key isEqualToString: self.key];
    
} // isEqual:


#pragma mark -
#pragma mark GameReachability Allocation Methods


+ (GameReachability *) reachabilityWithHostName: (NSString *) hostName {
    
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    
    if (ref) {
        
        GameReachability *r = [[[self alloc] initWithReachabilityRef: ref] autorelease];
        
        r.key = hostName;
        
        return r;
        
    }
    
    return nil;
    
} // reachabilityWithHostName


+ (NSString *) makeAddressKey: (in_addr_t) addr {
    // addr is assumed to be in network byte order.
    
    static const int       highShift    = 24;
    static const int       highMidShift = 16;
    static const int       lowMidShift  =  8;
    static const in_addr_t mask         = 0x000000ff;
    
    addr = ntohl(addr);
    
    return [NSString stringWithFormat: @"%d.%d.%d.%d",
            (addr >> highShift)    & mask,
            (addr >> highMidShift) & mask,
            (addr >> lowMidShift)  & mask,
            addr                  & mask];
    
} // makeAddressKey:


+ (GameReachability *) reachabilityWithAddress: (const struct sockaddr_in *) hostAddress {
    
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
    
    if (ref) {
        
        GameReachability *r = [[[self alloc] initWithReachabilityRef: ref] autorelease];
        
        r.key = [self makeAddressKey: hostAddress->sin_addr.s_addr];
        
        return r;
        
    }
    
    return nil;
    
} // reachabilityWithAddress


+ (GameReachability *) reachabilityForInternetConnection {
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    GameReachability *r = [self reachabilityWithAddress: &zeroAddress];
    
    r.key = GamekInternetConnection;
    
    return r;
    
} // reachabilityForInternetConnection


+ (GameReachability *) reachabilityForLocalWiFi {
    
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    
    GameReachability *r = [self reachabilityWithAddress: &localWifiAddress];
    
    r.key = GamekLocalWiFiConnection;
    
    return r;
    
} // reachabilityForLocalWiFi


#pragma mark -
#pragma mark Network Flag Handling Methods


#if USE_DDG_EXTENSIONS
//
// iPhone condition codes as reported by a 3GS running iPhone OS v3.0.
// Airplane Mode turned on:  GameReachability Flag Status: -- -------
// WWAN Active:              GameReachability Flag Status: WR -t-----
// WWAN Connection required: GameReachability Flag Status: WR ct-----
//         WiFi turned on:   GameReachability Flag Status: -R ------- Reachable.
// Local   WiFi turned on:   GameReachability Flag Status: -R xxxxxxd Reachable.
//         WiFi turned on:   GameReachability Flag Status: -R ct----- Connection down. (Non-intuitive, empirically determined answer.)
const SCNetworkReachabilityFlags GamekConnectionDown =  kSCNetworkReachabilityFlagsConnectionRequired |
kSCNetworkReachabilityFlagsTransientConnection;
//         WiFi turned on:   GameReachability Flag Status: -R ct-i--- Reachable but it will require user intervention (e.g. enter a WiFi password).
//         WiFi turned on:   GameReachability Flag Status: -R -t----- Reachable via VPN.
//
// In the below method, an 'x' in the flag status means I don't care about its value.
//
// This method differs from Apple's by testing explicitly for empirically observed values.
// This gives me more confidence in it's correct behavior. Apple's code covers more cases
// than mine. My code covers the cases that occur.
//
- (GameNetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags {
    
    if (flags & kSCNetworkReachabilityFlagsReachable) {
        
        // Local WiFi -- Test derived from Apple's code: -localWiFiStatusForFlags:.
        if (self.key == GamekLocalWiFiConnection) {
            
            // GameReachability Flag Status: xR xxxxxxd Reachable.
            return (flags & kSCNetworkReachabilityFlagsIsDirect) ? GamekReachableViaWiFi : GamekNotReachable;
            
        }
        
        // Observed WWAN Values:
        // WWAN Active:              GameReachability Flag Status: WR -t-----
        // WWAN Connection required: GameReachability Flag Status: WR ct-----
        //
        // Test Value: GameReachability Flag Status: WR xxxxxxx
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) { return GamekReachableViaWWAN; }
        
        // Clear moot bits.
        flags &= ~kSCNetworkReachabilityFlagsReachable;
        flags &= ~kSCNetworkReachabilityFlagsIsDirect;
        flags &= ~kSCNetworkReachabilityFlagsIsLocalAddress; // GamekInternetConnection is local.
        
        // GameReachability Flag Status: -R ct---xx Connection down.
        if (flags == GamekConnectionDown) { return GamekNotReachable; }
        
        // GameReachability Flag Status: -R -t---xx Reachable. WiFi + VPN(is up) (Thank you Ling Wang)
        if (flags & kSCNetworkReachabilityFlagsTransientConnection)  { return GamekReachableViaWiFi; }
        
        // GameReachability Flag Status: -R -----xx Reachable.
        if (flags == 0) { return GamekReachableViaWiFi; }
        
        // Apple's code tests for dynamic connection types here. I don't.
        // If a connection is required, regardless of whether it is on demand or not, it is a WiFi connection.
        // If you care whether a connection needs to be brought up,   use -isConnectionRequired.
        // If you care about whether user intervention is necessary,  use -isInterventionRequired.
        // If you care about dynamically establishing the connection, use -isConnectionIsOnDemand.
        
        // GameReachability Flag Status: -R cxxxxxx Reachable.
        if (flags & kSCNetworkReachabilityFlagsConnectionRequired) { return GamekReachableViaWiFi; }
        
        // Required by the compiler. Should never get here. Default to not connected.
#if (defined DEBUG && defined CLASS_DEBUG)
        NSAssert1(NO, @"Uncaught GameReachability test. Flags: %@", GameReachabilityFlags_(flags));
#endif
        return GamekNotReachable;
        
    }
    
    // GameReachability Flag Status: x- xxxxxxx
    return GamekNotReachable;
    
} // networkStatusForFlags:


- (GameNetworkStatus) currentReachabilityStatus {
    
    NSAssert(reachabilityRef, @"currentReachabilityStatus called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags = 0;
    GameNetworkStatus status = GamekNotReachable;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        //		logReachabilityFlags(flags);
        
        status = [self networkStatusForFlags: flags];
        
        return status;
        
    }
    
    return GamekNotReachable;
    
} // currentReachabilityStatus


- (BOOL) isReachable {
    
    NSAssert(reachabilityRef, @"isReachable called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags = 0;
    GameNetworkStatus status = GamekNotReachable;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        //		logReachabilityFlags(flags);
        
        status = [self networkStatusForFlags: flags];
        
        //		logNetworkStatus(status);
        
        return (GamekNotReachable != status);
        
    }
    
    return NO;
    
} // isReachable


- (BOOL) isConnectionRequired {
    
    NSAssert(reachabilityRef, @"isConnectionRequired called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        logReachabilityFlags(flags);
        
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
        
    }
    
    return NO;
    
} // isConnectionRequired


- (BOOL) connectionRequired {
    
    return [self isConnectionRequired];
    
} // connectionRequired
#endif


#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000)
static const SCNetworkReachabilityFlags GamekOnDemandConnection = kSCNetworkReachabilityFlagsConnectionOnTraffic |
kSCNetworkReachabilityFlagsConnectionOnDemand;
#else
static const SCNetworkReachabilityFlags GamekOnDemandConnection = kSCNetworkReachabilityFlagsConnectionAutomatic;
#endif

- (BOOL) isConnectionOnDemand {
    
    NSAssert(reachabilityRef, @"isConnectionIsOnDemand called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        logReachabilityFlags(flags);
        
        return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
                (flags & GamekOnDemandConnection));
        
    }
    
    return NO;
    
} // isConnectionOnDemand


- (BOOL) isInterventionRequired {
    
    NSAssert(reachabilityRef, @"isInterventionRequired called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        logReachabilityFlags(flags);
        
        return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
                (flags & kSCNetworkReachabilityFlagsInterventionRequired));
        
    }
    
    return NO;
    
} // isInterventionRequired


- (BOOL) isReachableViaWWAN {
    
    NSAssert(reachabilityRef, @"isReachableViaWWAN called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags = 0;
    GameNetworkStatus status = GamekNotReachable;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        logReachabilityFlags(flags);
        
        status = [self networkStatusForFlags: flags];
        
        return  (GamekReachableViaWWAN == status);
        
    }
    
    return NO;
    
} // isReachableViaWWAN


- (BOOL) isReachableViaWiFi {
    
    NSAssert(reachabilityRef, @"isReachableViaWiFi called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags = 0;
    GameNetworkStatus status = GamekNotReachable;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        logReachabilityFlags(flags);
        
        status = [self networkStatusForFlags: flags];
        
        return  (GamekReachableViaWiFi == status);
        
    }
    
    return NO;
    
} // isReachableViaWiFi


- (SCNetworkReachabilityFlags) reachabilityFlags {
    
    NSAssert(reachabilityRef, @"reachabilityFlags called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags = 0;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        logReachabilityFlags(flags);
        
        return flags;
        
    }
    
    return 0;
    
} // reachabilityFlags


#pragma mark -
#pragma mark Apple's Network Flag Handling Methods


#if !USE_DDG_EXTENSIONS
/*
 *
 *  Apple's Network Status testing code.
 *  The only changes that have been made are to use the new logReachabilityFlags macro and
 *  test for local WiFi via the key instead of Apple's boolean. Also, Apple's code was for v3.0 only
 *  iPhone OS. v2.2.1 and earlier conditional compiling is turned on. Hence, to mirror Apple's behavior,
 *  set your Base SDK to v3.0 or higher.
 *
 */

- (GameNetworkStatus) localWiFiStatusForFlags: (SCNetworkReachabilityFlags) flags
{
    logReachabilityFlags(flags);
    
    BOOL retVal = HNNotReachable;
    if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
    {
        retVal = HNReachableViaWiFi;
    }
    return retVal;
}


- (GameNetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{
    logReachabilityFlags(flags);
    if (!(flags & kSCNetworkReachabilityFlagsReachable))
    {
        // if target host is not reachable
        return HNNotReachable;
    }
    
    BOOL retVal = HNNotReachable;
    
    if (!(flags & kSCNetworkReachabilityFlagsConnectionRequired))
    {
        // if target host is reachable and no connection is required
        //  then we'll assume (for now) that your on Wi-Fi
        retVal = HNReachableViaWiFi;
    }
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 30000) // Apple advises you to use the magic number instead of a symbol.
    if ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic))
#else
        if (flags & kSCNetworkReachabilityFlagsConnectionAutomatic)
#endif
        {
            // ... and the connection is on-demand (or on-traffic) if the
            //     calling application is using the CFSocketStream or higher APIs
            
            if (!(flags & kSCNetworkReachabilityFlagsInterventionRequired))
            {
                // ... and no [user] intervention is needed
                retVal = HNReachableViaWiFi;
            }
        }
    
    if (flags & kSCNetworkReachabilityFlagsIsWWAN)
    {
        // ... but WWAN connections are OK if the calling application
        //     is using the CFNetwork (CFSocketStream?) APIs.
        retVal = HNReachableViaWWAN;
    }
    return retVal;
}


- (GameNetworkStatus) currentReachabilityStatus
{
    NSAssert(reachabilityRef, @"currentReachabilityStatus called with NULL reachabilityRef");
    
    GameNetworkStatus retVal = HNNotReachable;
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
        if(self.key == GamekLocalWiFiConnection)
        {
            retVal = [self localWiFiStatusForFlags: flags];
        }
        else
        {
            retVal = [self networkStatusForFlags: flags];
        }
    }
    return retVal;
}


- (BOOL) isReachable {
    
    NSAssert(reachabilityRef, @"isReachable called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags = 0;
    GameNetworkStatus status = GamekNotReachable;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        logReachabilityFlags(flags);
        
        if(self.key == GamekLocalWiFiConnection) {
            
            status = [self localWiFiStatusForFlags: flags];
            
        } else {
            
            status = [self networkStatusForFlags: flags];
            
        }
        
        return (GamekNotReachable != status);
        
    }
    
    return NO;
    
} // isReachable


- (BOOL) isConnectionRequired {
    
    return [self connectionRequired];
    
} // isConnectionRequired


- (BOOL) connectionRequired {
    
    NSAssert(reachabilityRef, @"connectionRequired called with NULL reachabilityRef");
    
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        
        logReachabilityFlags(flags);
        
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
        
    }
    
    return NO;
    
} // connectionRequired
#endif

@end
