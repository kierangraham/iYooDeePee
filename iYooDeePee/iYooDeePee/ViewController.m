//
//  ViewController.m
//  iYooDeePee
//
//  Created by Kieran Graham on 05/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {

    GCDAsyncUdpSocket *socket;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    label.text = @"iYooDeePee";
    
    socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    [socket bindToPort:3000 error:nil];
    [socket beginReceiving:nil];
    [socket enableBroadcast:YES error:nil];
}

- (BOOL)onUdpSocket:(GCDAsyncUdpSocket *)sock
     didReceiveData:(NSData *)data
            withTag:(long)tag
           fromHost:(NSString *)host
               port:(UInt16)port
{
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (msg)
	{
		NSLog(@"%@", msg);
	}
    
	[socket sendData:data toHost:host port:port withTimeout:-1 tag:0];
    
	return YES;
}

@end
