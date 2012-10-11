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

@interface DashboardViewController ()

@end

@implementation DashboardViewController

#pragma mark - Actions

- (IBAction) connectAction:(UIButton*) button {
    [AppDelegate delegate].instrumentID = instrumentField.text;
    
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
    // Do any additional setup after loading the view from its nib.
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
