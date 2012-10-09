//
//  PerformanceViewController.m
//  iYooDeePee
//
//  Created by Kieran Graham on 05/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import "PerformanceViewController.h"

@interface NSString (udp)
    - (NSString *)stringValue;
@end

@implementation NSString (udp)
    - (NSString *)stringValue {return self;}
@end

@interface PerformanceViewController () <GCDAsyncUdpSocketDelegate> {
    GCDAsyncUdpSocket *sendSocket;
    GCDAsyncUdpSocket *receiveSocket;
}

@end

@implementation PerformanceViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ipAddresslabel setText:[self getIPAddress]];
	
    receiveSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    sendSocket    = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [receiveSocket bindToPort:12000 error:nil];
    [receiveSocket beginReceiving:nil];
    [receiveSocket enableBroadcast:YES error:nil];
	
    [sendSocket connectToHost:@"10.0.0.60" onPort:12002 error:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendDeviceIPAddress) userInfo:nil repeats:YES];
    
    [self sendDeviceIPAddress];
}

#pragma mark - UDP Socket

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"didSendData");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    NSLog(@"didConnectToAddress");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"didNotSendDataWithTag");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {    
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
//	NSLog(@"******* Address string : %@\n Args: %@***********", [oscMessage addressString], [oscMessage arguments]);
    
//    [self sendDeviceIPAddress];
}

- (void) sendDeviceIPAddress {
    NSLog(@"sendDeviceIPAddress:");
    
    NSString *message = [self getIPAddress];
    NSData   *data    = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    [message retain];
    [data retain];

    [sendSocket sendData:data withTimeout:-1 tag:1];
}

-(NSString *) getIPAddress {
	// On iPhone, WiFi is always "en0"
    NSString *result = nil;
	
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	
	if ((getifaddrs(&addrs) == 0))
	{
		cursor = addrs;
		while (cursor != NULL)
		{
			NSLog(@"cursor->ifa_name = %s", cursor->ifa_name);
			
			if (strcmp(cursor->ifa_name, "en0") == 0)
			{
				if (cursor->ifa_addr->sa_family == AF_INET)
				{
					struct sockaddr_in *addr = (struct sockaddr_in *)cursor->ifa_addr;
					NSLog(@"cursor->ifa_addr = %s", inet_ntoa(addr->sin_addr));
					
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