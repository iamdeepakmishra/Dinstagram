//
//  BaseViewController.m
//  Dinstagram
//
//  Created by deepak mishra on 13/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define LOADINGMORE_VIEW_HEIGHT 52.0f

@interface BaseViewController ()<UIScrollViewDelegate>
{
    BOOL isLoading;
    BOOL isLoadMoreViewAdded;
}
@property(nonatomic, retain) NSString *nextPageID;
@property(nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@end

@implementation BaseViewController

-(NSMutableArray *)data
{
    if(_data == nil) _data = [[NSMutableArray alloc]init];
    return _data;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dInstagramSessionIsValid
{
    //overwrite this method
}

-(void)loadData
{
    //overwrite this method
}

-(void)failWithError
{
    //overwrite this method
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.dInstagram = appDelegate.dInstagram;
    
    // here i am setting accessToken received on previous login
    self.dInstagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    self.dInstagram.sessionDelegate = self;
    if ([self.dInstagram isSessionValid])
    {
        [self dInstagramSessionIsValid]; //override by child classes
    }
    else
    {
        //here set various permissions
        [self.dInstagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", @"basic", @"relationships",nil]];
    }
}



/*********************************************************************************************************/
/*********************************************************************************************************/
#pragma mark -
#pragma mark IGSessionDelegate Methods
-(void)igDidLogin
{
    DebugLog(@"Instagram did login");
    // here i am storing accessToken in USER DEFAULTS
    [[NSUserDefaults standardUserDefaults] setObject:self.dInstagram.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dInstagramSessionIsValid]; //override by child classes
}

-(void)igDidNotLogin:(BOOL)cancelled
{
    DebugLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled)
    {
        message = @"Access cancelled!";
    }
    else
    {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout
{
    DebugLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated
{
    DebugLog(@"Instagram session was invalidated");
}



/*********************************************************************************************************/
/*********************************************************************************************************/
#pragma mark - IGRequestDelegate
- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    DebugLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    [self failWithError];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    DebugLog(@"Instagram did load: %@", result);
    if(isLoading) [self stopLoading];
    
    self.nextPageID = [NSString stringWithFormat:@"%@",[[result objectForKey:@"pagination"] objectForKey:@"next_max_id"]];
    
    if([[result objectForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        [self.data addObjectsFromArray:(NSArray*)[result objectForKey:@"data"]];
    }
    
    if([[result objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
    {
        self.dataDict = (NSDictionary *)[result objectForKey:@"data"];
    }
    if([self.data count] || [self.dataDict count])
        [self loadData];
}



/*********************************************************************************************************/
/*********************************************************************************************************/
#pragma mark -
#pragma mark Load More Methods
-(void)addLoadMoreView
{
    isLoadMoreViewAdded = !isLoadMoreViewAdded;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.refreshSpinner = indicator;
    [indicator release];
    [self.refreshSpinner setFrame:CGRectMake(self.tableView.frame.size.width /2 - self.refreshSpinner.frame.size.width /2,
                                              self.tableView.contentSize.height + (LOADINGMORE_VIEW_HEIGHT /2 - self.refreshSpinner.frame.size.height /2),
                                              self.refreshSpinner.frame.size.width,
                                              self.refreshSpinner.frame.size.height)];
    [self.refreshSpinner startAnimating];
    [self.refreshSpinner hidesWhenStopped];
    [self.tableView addSubview:self.refreshSpinner];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - self.tableView.frame.size.height))
    {
        if(!isLoadMoreViewAdded)
        {
            [self addLoadMoreView];
            [self refresh];
            
            // adding indicator of loading next batch of data
            [UIView animateWithDuration:0.1 animations:^{
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, LOADINGMORE_VIEW_HEIGHT, 0);
            }];
            isLoading = YES;
        }
    }
}

- (void)refresh {
    // Don't forget to call stopLoading at the end.
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.nextPageID, @"max_id", @"users/self/feed", @"method",nil];
    [self.dInstagram requestWithParams:params
                              delegate:self];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        //self.tableView.contentInset = UIEdgeInsetsZero;
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the UI
    [self.refreshSpinner stopAnimating];
    [self.refreshSpinner removeFromSuperview];
    self.refreshSpinner = nil;
    isLoadMoreViewAdded = !isLoadMoreViewAdded;
}
#pragma mark -
/*********************************************************************************************************/
/*********************************************************************************************************/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_data release];
    [_tableView release];
    [_nextPageID release];
    [_dataDict release];
    [super dealloc];
}
@end
