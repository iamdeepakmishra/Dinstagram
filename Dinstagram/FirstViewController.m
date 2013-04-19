//
//  FirstViewController.m
//  Dinstagram
//
//  Created by deepak mishra on 13/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

#import "FirstViewController.h"
#import <AFImageRequestOperation.h>

@interface FirstViewController ()
{
}
@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Profile", @"Profile");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self", @"method", nil];
    [self.dInstagram requestWithParams:params
                              delegate:self];
}

-(void)loadData
{
    [self.lblName setText:[NSString stringWithFormat:@"%@",[self.dataDict objectForKey:@"full_name"]]];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.dataDict objectForKey:@"profile_picture"]]];
    AFImageRequestOperation *oprtn = [AFImageRequestOperation imageRequestOperationWithRequest:req success:^(UIImage *image) {
        [self.profileImage setImage:image];
        [self.progressBar setHidden:YES];
    }];
    [oprtn setDownloadProgressBlock:^(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        CGFloat received = totalBytesRead;
        CGFloat total = totalBytesExpectedToRead;
        double progress = (received / total);
        self.progressBar.progress = progress;
    }];
    [oprtn start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblName:nil];
    [self setProfileImage:nil];
    [self setProgressBar:nil];
    [super viewDidUnload];
}
@end
