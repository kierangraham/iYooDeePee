//
//  SessionManager.m
//  iYooDeePee
//
//  Created by Niall Kelly on 16/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import "SessionManager.h"

//#import "OSCConnectionDelegate.h"
//#import "OSCConnection.h"
//#import "OSCDispatcher.h"
//#import "OSCPacket.h"

#import "SynthesizeSingleton.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

static	NSString	*const		kUserDefaultsInstrumentKey	= @"kUserDefaultsInstrumentKey";
static	NSString	*const		kUserDefaultsRemoteIP		= @"kUserDefaultsRemoteIP";

@implementation SessionManager

SYNTHESIZE_INSTANCE_SINGLETON_FOR_CLASS_GCD(SessionManager)

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark -
#pragma mark - Actions / Properties

- (void)setDefaults {
	
	NSString *instrID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsInstrumentKey];
	if (instrID == nil || [instrID length] < 1)
		instrID = @"";
	
	NSString *rIP = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsRemoteIP];
	if (rIP == nil || [rIP length] < 1)
		rIP = @"10.0.1.2";
	
	[self setInstrumentID:instrID];
	[self setRemoteIP:rIP];
}

- (void)saveDefaults {
	[[NSUserDefaults standardUserDefaults] setObject:_instrumentID forKey:kUserDefaultsInstrumentKey];
	[[NSUserDefaults standardUserDefaults] setObject:_remoteIP forKey:kUserDefaultsRemoteIP];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


-(NSString *)deviceIP {
	// On iPhone, WiFi is always "en0"
    NSString *result = nil;
	
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	
	if ((getifaddrs(&addrs) == 0))
	{
		cursor = addrs;
		while (cursor != NULL)
		{
			if (strcmp(cursor->ifa_name, "en0") == 0)
			{
				if (cursor->ifa_addr->sa_family == AF_INET)
				{
					struct sockaddr_in *addr = (struct sockaddr_in *)cursor->ifa_addr;
					
                    result = [[NSString alloc] initWithFormat:@"%s",inet_ntoa(addr->sin_addr)];
                    
					cursor = NULL;
				}
				else
				{
					cursor = cursor->ifa_next;
				}
			}
			else
			{
				cursor = cursor->ifa_next;
			}
		}
		freeifaddrs(addrs);
	}
	return result;
}

@end
