//
//  FullImageViewer.m
//  Dinstagram
//
//  Created by deepak mishra on 14/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

#import "FullImageViewer.h"
#import <AFImageRequestOperation.h>

#define ProgressBarWidth 100
#define ProgressBarHeight 15


@interface FullImageViewer ()
{
    UIImageView *imageView;
    UIScrollView *scrollView;
}
@property(nonatomic, assign)id<FullImageViewerDelegate>delegate;
@property(nonatomic, retain)UIProgressView *progressBar;
@end
@implementation FullImageViewer


- (id)initWithFrame:(CGRect)frame withDelegate:(id<FullImageViewerDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.delegate = delegate;
    }
    return self;
}


-(void)closeFullView:(id)sender
{
    [self.delegate backFromFullView];
}


-(void)loadWithImageURL:(NSURL *)url
{
    scrollView = [[[UIScrollView alloc]initWithFrame:[self bounds]] autorelease];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    scrollView.delegate = self;
    scrollView.minimumZoomScale=1.0;
    scrollView.maximumZoomScale=4.0;
    [self addSubview:scrollView];
 
    self.progressBar = [[[UIProgressView alloc] initWithFrame:CGRectMake((self.frame.size.width - ProgressBarWidth) /2,
                                                                        (self.frame.size.height - ProgressBarHeight) /2,
                                                                         ProgressBarWidth,
                                                                         ProgressBarHeight)] autorelease];
    [self.progressBar setProgressViewStyle:UIProgressViewStyleBar];
    [self.progressBar setProgressTintColor:[UIColor blueColor]];
    [self.progressBar setTrackTintColor:[UIColor clearColor]];
    [self.progressBar setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.progressBar];
    
    imageView = [[UIImageView alloc]init];
    [imageView setFrame:CGRectMake(0,
                                   (scrollView.frame.size.height - scrollView.frame.size.width)/2,
                                   scrollView.frame.size.width, scrollView.frame.size.width)];
    [imageView setCenter:[scrollView center]];
    [scrollView addSubview:imageView];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    AFImageRequestOperation *oprtn = [AFImageRequestOperation imageRequestOperationWithRequest:req success:^(UIImage *image) {
        [imageView setImage:image];
        [self.progressBar setHidden:YES];
    }];
    [oprtn setDownloadProgressBlock:^(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        CGFloat received = totalBytesRead;
        CGFloat total = totalBytesExpectedToRead;
        double progress = (received / total);
        self.progressBar.progress = progress;
    }];
    [oprtn start];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(self.frame.size.width - 100, 5, 100, 100)];
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeFullView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}


#pragma mark - ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sView
{
    return imageView;
}


- (void)dealloc
{
    [imageView release];
    [scrollView release];
    [_progressBar release];
    self.delegate = nil;
    [super dealloc];
}
@end
