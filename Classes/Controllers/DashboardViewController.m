//
//  DashboardViewController.m
//  iYooDeePee
//
//  Created by Kieran Graham on 08/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "PerformanceViewController.h"
#import "DashboardViewController.h"
#import "GradientButton.h"

@interface DashboardViewController () <OSCConnectionDelegate>

@end

@implementation DashboardViewController {
	NSArray *_instrumentIDs;
	OSCConnection *_oscConnection;
	GCDAsyncUdpSocket *_receiveSocket;
}

- (void)dealloc
{
    [_oscConnection disconnect];
	[_receiveSocket close];
    
}

#pragma mark - Actions

- (IBAction) connectAction:(UIButton*) button {
	
	NSString *instID = instrumentField.text;
	if (instID == nil || [instID length] < 1) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"Please enter an instrument number"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	NSString *ip = ipField.text;
	if (ip == nil || [ip length] < 1) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"Please enter an I.P. address"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	[[SessionManager sharedInstance] setRemoteIP:ip];
	[[SessionManager sharedInstance] setInstrumentID:instID];
	[[SessionManager sharedInstance] saveDefaults];
	
	[instrumentField resignFirstResponder];
	[ipField resignFirstResponder];
	[spinner startAnimating];
	
	[self oscSendClientConnectionInfo];
	
	[button setTitle:@"Resend" forState:UIControlStateNormal];
	
}

#pragma mark - OSC

- (void) oscSendClientConnectionInfo {
    
	if (_receiveSocket) 
		[_receiveSocket close];
		
	
	_receiveSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	[_receiveSocket bindToPort:1201 error:nil];
    [_receiveSocket beginReceiving:nil];
    [_receiveSocket enableBroadcast:YES error:nil];
    
    // Setup OSC Connection

	if (_oscConnection)
		[_oscConnection disconnect];
	
	_oscConnection = [[OSCConnection alloc] init];
    _oscConnection.delegate = self;
    _oscConnection.continuouslyReceivePackets = YES;
    [_oscConnection bindToAddress:nil port:0 error:nil];
    [_oscConnection receivePacket];
	
	OSCMutableMessage *instrumentIdPacket  = [[OSCMutableMessage alloc] init];
    instrumentIdPacket.address = [@"/" stringByAppendingString:[[SessionManager sharedInstance] instrumentID]];
    [instrumentIdPacket addString:[[SessionManager sharedInstance] deviceIP]];
	
	[_oscConnection sendPacket:instrumentIdPacket toHost:[[SessionManager sharedInstance] remoteIP] port:1200];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	WSOSCPacket *oscPacket   = [[WSOSCPacket alloc] initWithDataFrom:message];
	WSOSCMessage *oscMessage = [oscPacket content];
	
	NSArray *args = [oscMessage arguments];
	if ([args count] < 1)
		return;
	
	NSString *command = [oscMessage addressString];
	BOOL ready = NO;
	
	if ([command isEqualToString:@"/ready"])
        ready = [args[0] boolValue];
	
    if (ready) {
		[[self navigationController] pushViewController:[[PerformanceViewController alloc] initWithNibName:@"PerformanceViewController" bundle:nil] animated:YES];
		[spinner stopAnimating];
	}
}

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *collector = [NSMutableArray new];
		for (NSInteger i=1; i<35;i++)
			[collector addObject:[NSString stringWithFormat:@"Trumpet%i", i]];
		for (NSInteger i=1; i<17;i++)
			[collector addObject:[NSString stringWithFormat:@"Trombone%i", i]];
		_instrumentIDs = [collector copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[instrumentField setInputView:pickerHolderView];
	[instrumentField setText:[[SessionManager sharedInstance] instrumentID]];
	[ipField setText:[[SessionManager sharedInstance] remoteIP]];
	[connectButton useGreenConfirmStyle];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark -
#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[instrumentField setText:_instrumentIDs[row]];
}


#pragma mark -
#pragma mark - UIPickerViewDatasource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return _instrumentIDs[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [_instrumentIDs count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

@end
