//
//  PerformanceViewController.m
//  iYooDeePee
//
//  Created by Kieran Graham on 05/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import "PerformanceViewController.h"

static	NSInteger	const		INCOMING_PORT	=	12000;

@interface NSString (udp)
    - (NSString *)stringValue;
@end

@implementation NSString (udp)
    - (NSString *)stringValue {return self;}
@end

@interface PerformanceViewController () {
    GCDAsyncUdpSocket *socket;
}

@end

@implementation PerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ipAddresslabel setText:[self getIPAddress]];
	
    socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [socket bindToPort:12000 error:nil];
    [socket beginReceiving:nil];
    [socket enableBroadcast:YES error:nil];
	
}

#pragma mark -
#pragma mark GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSLog(@"udpSocket:didReceiveData:fromAddress:withFilterContext");
    
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	WSOSCPacket *oscPacket   = [[WSOSCPacket alloc] initWithDataFrom:message];
	WSOSCMessage *oscMessage = [oscPacket content];
	
	NSArray *args = [oscMessage arguments];
	if ([args count] < 1)
		return;
	
	NSString *command = [oscMessage addressString];
	
	if ([command isEqualToString:@"/section"]) {
		[sectionNumberLabel setText:[@([args[0] intValue]) stringValue]];
	}
	else if ([command isEqualToString:@"/count"]) {
		[countNumberLabel setText:[@([args[0] intValue]) stringValue]];
	}
	else if ([command isEqualToString:@"/total"]) {
		[totalCountNumberLabel setText:[@([args[0] intValue]) stringValue]];
	}
	
	NSLog(@"******* Address string : %@\n Args: %@***********", [oscMessage addressString], [oscMessage arguments]);
}

#pragma mark - Get IP Address

- (NSString *)getIPAddress
{
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}

@end