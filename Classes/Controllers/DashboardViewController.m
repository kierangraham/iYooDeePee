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

@interface DashboardViewController ()

@end

@implementation DashboardViewController

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
	
    [AppDelegate delegate].instrumentID = instID;
	[AppDelegate delegate].remoteIP = ip;
    
    [AppDelegate delegate].viewController = [[PerformanceViewController alloc] initWithNibName:@"PerformanceViewController" bundle:nil];
    [AppDelegate window].rootViewController = [AppDelegate delegate].viewController;
}

#pragma mark - OSC

- (void) oscSendClientConnectionInfo {
    
}

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[ipField setText:[[AppDelegate delegate] remoteIP]];
	[connectButton useGreenConfirmStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
