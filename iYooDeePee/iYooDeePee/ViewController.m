//
//  ViewController.m
//  iYooDeePee
//
//  Created by Kieran Graham on 05/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import "ViewController.h"
#import "AsyncUdpSocket.h"
#import "WSOSCPacket.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

static	NSInteger	const		INCOMING_PORT	=	12000;

@interface NSString (udp)
- (NSString *)stringValue;
@end

@implementation NSString (udp)
- (NSString *)stringValue {return self;}
@end

@interface ViewController () {

    GCDAsyncUdpSocket *socket;
    AsyncUdpSocket *udpSocket;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ipAddresslabel setText:[self getIPAddress]];
	
	
    
//    socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//
//    [socket bindToPort:12000 error:nil];
//    [socket beginReceiving:nil];
//    [socket enableBroadcast:YES error:nil];
	
	[self startListenerUDP]	;
}


-(void)startListenerUDP {
	
	udpSocket = [[AsyncUdpSocket alloc]initIPv4];
	[udpSocket setDelegate:self];
	
	if ([udpSocket bindToPort:INCOMING_PORT error:nil]){
		
		//if(debug)
		NSLog(@"UDP listening on port %d", INCOMING_PORT);
		[udpSocket receiveWithTimeout:9999 tag:0];
		
	}
	
	else {
		
		NSLog(@"UDP socket couldn't bind to port %d", INCOMING_PORT);
		
	}
	
	
	
}


#pragma mark -
#pragma mark AsyncUdpSocketDelegate

/**
 * Called when the socket has received the requested datagram.
 *
 * Due to the nature of UDP, you may occasionally receive undesired packets.
 * These may be rogue UDP packets from unknown hosts,
 * or they may be delayed packets arriving after retransmissions have already occurred.
 * It's important these packets are properly ignored, while not interfering with the flow of your implementation.
 * As an aid, this delegate method has a boolean return value.
 * If you ever need to ignore a received packet, simply return NO,
 * and AsyncUdpSocket will continue as if the packet never arrived.
 * That is, the original receive request will still be queued, and will still timeout as usual if a timeout was set.
 * For example, say you requested to receive data, and you set a timeout of 500 milliseconds, using a tag of 15.
 * If rogue data arrives after 250 milliseconds, this delegate method would be invoked, and you could simply return NO.
 * If the expected data then arrives within the next 250 milliseconds,
 * this delegate method will be invoked, with a tag of 15, just as if the rogue data never appeared.
 *
 * Under normal circumstances, you simply return YES from this method.
 **/
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port {
	[udpSocket receiveWithTimeout:9999 tag:0];
	
	NSString * message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	WSOSCPacket * oscPacket = [[WSOSCPacket alloc] initWithDataFrom:message];
	
	WSOSCMessage * oscMessage = [oscPacket content];
	
	NSArray *args = [oscMessage arguments];
	if ([args count] < 1)
		return NO;
	
	NSString *address = [oscMessage addressString];
	
	if ([address isEqualToString:@"/section"]) {
		[sectionNumberLabel setText:[@([args[0] intValue]) stringValue]];
	}
	else if ([address isEqualToString:@"/count"]) {
		[countNumberLabel setText:[@([args[0] intValue]) stringValue]];
	}
	else if ([address isEqualToString:@"/total"]) {
		[totalCountNumberLabel setText:[@([args[0] intValue]) stringValue]];
	}
	
	
	NSLog(@"******* Address string : %@\n Args: %@***********", [oscMessage addressString], [oscMessage arguments]);
	
	return YES;
}





/**
 * Called if an error occurs while trying to receive a requested datagram.
 * This is generally due to a timeout, but could potentially be something else if some kind of OS error occurred.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error {
	NSLog(@"Data read error");
}

/**
 * Called when the socket is closed.
 * A socket is only closed if you explicitly call one of the close methods.
 **/
- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock {
	NSLog(@"Close");
	//[sock release];
}



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



//
//- (BOOL)onUdpSocket:(GCDAsyncUdpSocket *)sock
//     didReceiveData:(NSData *)data
//            withTag:(long)tag
//           fromHost:(NSString *)host
//               port:(UInt16)port
//{
//	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	if (msg)
//	{
//		NSLog(@"%@", msg);
//	}
//    
////	[socket sendData:data toHost:host port:port withTimeout:-1 tag:0];
//    
//	return YES;
//}

@end
