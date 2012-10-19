//
//  SessionManager.h
//  iYooDeePee
//
//  Created by Niall Kelly on 16/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject

@property (copy, nonatomic)		NSString        *instrumentID;
@property (copy, nonatomic)		NSString        *remoteIP;

@property (readonly, assign)	NSString        *deviceIP;

+ (SessionManager *)sharedInstance;
- (void)setDefaults;
- (void)saveDefaults;


@end
