//
//  AppDelegate.m
//  iYooDeePee
//
//  Created by Kieran Graham on 05/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import "AppDelegate.h"

#import "DashboardViewController.h"
#import "PerformanceViewController.h"

#import "TestFlight.h"

@implementation AppDelegate

@synthesize window, viewController, instrumentID;

+ (AppDelegate *) delegate {
    return [[UIApplication sharedApplication] delegate];
}

+ (UIWindow *) window {
    return [self delegate].window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	
    
    self.viewController = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    [UIApplication sharedApplication].idleTimerDisabled = YES;
	
	[self launchTestFlightWithTeamToken:@"e58d4ffff85f3c08b9e69347f0d92a49_MTM5ODcwMjAxMi0xMC0wNyAxNzo1ODoxMS4yMDQzMTc"];

    return YES;
}

static void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

static void HandleExceptions(NSException *exception) {
    NSLog(@"This is where we save the application data during a exception");
    // Save application data on crash
	
}
/*
 My Apps Custom signal catcher, we do special stuff here, and TestFlight takes care of the rest
 **/
static void SignalHandler(int sig) {
    NSLog(@"This is where we save the application data during a signal");
    // Save application data on crash
}

- (void)launchTestFlightWithTeamToken:(NSString *)teamToken {
	
	//#ifdef AD_HOC
	//	if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
	//		[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
	//#endif
	
	//	NSLog(@"Launching TestFlight with token:\n%@", teamToken);
	
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	
    // create the signal action structure
    struct sigaction newSignalAction;
    // initialize the signal action structure
    memset(&newSignalAction, 0, sizeof(newSignalAction));
    // set SignalHandler as the handler in the signal action structure
    newSignalAction.sa_handler = &SignalHandler;
    // set SignalHandler as the handlers for SIGABRT, SIGILL and SIGBUS
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
	sigaction(SIGTRAP, &newSignalAction, NULL);
    
	//	[TestFlight setOptions:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"reinstallCrashHandlers", nil]];
	[TestFlight takeOff:teamToken];
	
	
	//	[TestFlight passCheckpoint:@"CHECKPOINT_NAME"];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSString *) ipAddress {
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
