//
//  PerformanceViewController.m
//  iYooDeePee
//
//  Created by Kieran Graham on 05/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "PerformanceViewController.h"
#import "DashboardViewController.h"

@interface PerformanceViewController () <GCDAsyncUdpSocketDelegate, OSCConnectionDelegate> {
    GCDAsyncUdpSocket *receiveSocket;
    OSCConnection     *oscConnection;
    
    NSInteger duration;
    NSInteger section;
    NSInteger count;
}
@end

@implementation PerformanceViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    duration = 0;
    section  = 0;
    count    = 0;
    
    ipAddressLabel.text = [[AppDelegate delegate] deviceIP];
    instrumentIDLabel.text = [[AppDelegate delegate] instrumentID];
	
    receiveSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [receiveSocket bindToPort:12000 error:nil];
    [receiveSocket beginReceiving:nil];
    [receiveSocket enableBroadcast:YES error:nil];
    
    // Setup OSC Connection
    oscConnection = [[OSCConnection alloc] init];
    oscConnection.delegate = self;
    oscConnection.continuouslyReceivePackets = YES;
    [oscConnection bindToAddress:nil port:0 error:nil];
    [oscConnection receivePacket];
    
//    while ([[AppDelegate delegate] remoteIP] == nil) {
//        [self sendDeviceInfo];
//    }
    [self sendDeviceInfo];
}

#pragma mark - Actions

- (IBAction) reconnectAction:(UIButton*) button {
    [AppDelegate delegate].viewController = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
    [AppDelegate delegate].window.rootViewController = [AppDelegate delegate].viewController;
}

- (void) updateProgress {
    float percent = [@(count) floatValue] / [@(duration) floatValue];
    [progressIndicator setProgress:percent];
}

#pragma mark - UDP Receive Socket

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {    
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	WSOSCPacket *oscPacket   = [[WSOSCPacket alloc] initWithDataFrom:message];
	WSOSCMessage *oscMessage = [oscPacket content];
	
	NSArray *args = [oscMessage arguments];
	if ([args count] < 1)
		return;
	
	NSString *command = [oscMessage addressString];
	
	if ([command isEqualToString:@"/section"]) {
        section = [args[0] intValue];
        sectionNumberLabel.text = [NSString stringWithFormat:@"%i", section];
	}
	else if ([command isEqualToString:@"/count"]) {
        count = [args[0] intValue];
		countNumberLabel.text = [NSString stringWithFormat:@"%i", count];
        
        [self updateProgress];
	}
	else if ([command isEqualToString:@"/total"]) {
        duration = [args[0] intValue];
		totalCountNumberLabel.text = [NSString stringWithFormat:@"%i", duration];
	}

    NSString *remoteIP = [[NSString alloc] initWithData:address encoding:NSUTF8StringEncoding];
    [AppDelegate delegate].remoteIP = remoteIP;
}

#pragma mark - OSC Socket

- (void) sendDeviceInfo {    
    NSString *remoteAddress = [[AppDelegate delegate] remoteIP];
    NSString *deviceAddress = [[AppDelegate delegate] deviceIP];
    NSString *instrumentID  = [[AppDelegate delegate] instrumentID];
    
    OSCMutableMessage *willConnectPacket = [[OSCMutableMessage alloc] init];
    willConnectPacket.address = @"/client_will_connect";
//    [willConnectPacket addString:@"vvvv"];
    
    OSCMutableMessage *didConnectPacket = [[OSCMutableMessage alloc] init];
    didConnectPacket.address = @"/client_did_connect";
//    [didConnectPacket addString:@"^^^^"];
    
    OSCMutableBundle  *bundle              = [[OSCMutableBundle alloc] init];
    
    OSCMutableMessage *deviceAddressPacket = [[OSCMutableMessage alloc] init];
    deviceAddressPacket.address = @"/device_ip";
    [deviceAddressPacket addString:deviceAddress];
    
    OSCMutableMessage *instrumentIdPacket  = [[OSCMutableMessage alloc] init];
    instrumentIdPacket.address = @"/instrument_id";
    [instrumentIdPacket addString:instrumentID];
    
    [bundle addChildPacket:willConnectPacket];
    [bundle addChildPacket:deviceAddressPacket];
    [bundle addChildPacket:instrumentIdPacket];
    [bundle addChildPacket:didConnectPacket];
    
    [oscConnection sendPacket:bundle toHost:remoteAddress port:12002];
}

- (void)viewDidUnload {
    progressIndicator = nil;
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end