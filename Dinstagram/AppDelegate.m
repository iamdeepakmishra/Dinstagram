//
//  AppDelegate.m
//  Dinstagram
//
//  Created by deepak mishra on 13/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "FirstViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
#warning ADD YOUR OWN CLIENT ID
    self.dInstagram = [[Instagram alloc] initWithClientId:APP_ID
                                                 delegate:nil];
    FirstViewController    *viewController1    = [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
    HomeViewController     *homeViewController = [[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil] autorelease];
    UINavigationController *homeNavigation     = [[[UINavigationController alloc]initWithRootViewController:homeViewController] autorelease];
    
    self.tabBarController                   = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers   = @[homeNavigation, viewController1];
    self.window.rootViewController          = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

// YOU NEED TO CAPTURE igAPPID:// schema
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.dInstagram handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.dInstagram handleOpenURL:url];
}

@end
