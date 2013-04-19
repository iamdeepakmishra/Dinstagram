//
//  HomeViewCell.m
//  Dinstagram
//
//  Created by deepak mishra on 13/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

#import "HomeViewCell.h"
#import "AppDelegate.h"
#import <AFImageRequestOperation.h>

#define SPACE_BETWEEN_LIKES 5

@interface HomeViewCell ()
{
    BOOL hasImage;
}
@property(nonatomic, retain)NSDictionary *dataDictionary;
@property(nonatomic, retain)FullImageViewer *fullImageViewer;
@end

@implementation HomeViewCell
@synthesize fullImageViewer = _fullImageViewer;

-(void)setFullImageViewer:(FullImageViewer *)fullImageViewer
{
    if(_fullImageViewer != fullImageViewer)
    {
        [_fullImageViewer release];
        _fullImageViewer = [fullImageViewer retain];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)tapGestureReceived:(UITapGestureRecognizer *)sender
{
    if(sender.numberOfTouches == 2 && sender.numberOfTapsRequired == 2)
    {
        if([self.dataDictionary objectForKey:@"images"]!=[NSNull null])
        {
            NSURL *url = [NSURL URLWithString:[[[self.dataDictionary objectForKey:@"images"]objectForKey:@"standard_resolution"] objectForKey:@"url"]];
            FullImageViewer *fullImage = [[FullImageViewer alloc]initWithFrame:[APP_DELEGATE.window bounds] withDelegate:self];
            [self setFullImageViewer:fullImage];
            [fullImage release];
            [APP_DELEGATE.window addSubview:self.fullImageViewer];
            [self.fullImageViewer loadWithImageURL:url];
        }
    }
    
    else if(sender.numberOfTouches == 1 && sender.numberOfTapsRequired == 2)
    {
        
    }
    
    else
    {
        [self.reloadLabel setHidden:YES];
        if(sender.numberOfTouches == 1 && sender.numberOfTapsRequired == 1)
        {
            [self loadImage:self.dataDictionary];
        }
    }
}

-(void)layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *singleTapGesture = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureReceived:)] autorelease];
    singleTapGesture.delegate = self;
    [singleTapGesture setNumberOfTapsRequired:2];
    [self.imagePost addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureReceived:)] autorelease];
    doubleTapGesture.delegate = self;
    [doubleTapGesture setNumberOfTouchesRequired:2];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self.imagePost addGestureRecognizer:doubleTapGesture];
}

-(void)layoutData:(NSDictionary *)dict
{
    self.dataDictionary = dict;
    [self.reloadLabel setHidden:YES];
    
    [self loadImage:dict];
    [self loadLikesComments:dict];
}


/*********************************************************************************************************/
/*********************************************************************************************************/
#pragma mark -
#pragma mark loading image asynchronously

-(void)loadImage:(NSDictionary *)dict
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[dict objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"]]];
    AFImageRequestOperation *oprtn = [AFImageRequestOperation imageRequestOperationWithRequest:req success:^(UIImage *image) {
        [self.imagePost setImage:image];
        [self.progressView setHidden:YES];
    }];
    [oprtn setDownloadProgressBlock:^(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        CGFloat received = totalBytesRead;
        CGFloat total = totalBytesExpectedToRead;
        double progress = (received / total);
        self.progressView.progress = progress;
        [self.progressView.label setText:[NSString stringWithFormat:@"%.0lf %@",self.progressView.progress*100, @"%"]];
    }];
    [oprtn start];
}
#pragma mark -
/*********************************************************************************************************/
/*********************************************************************************************************/


#pragma mark -
#pragma mark loading image asynchronously
-(void)loadLikesComments:(NSDictionary *)dict
{
    NSInteger likeCounts = [[[dict objectForKey:@"likes"] objectForKey:@"count"] integerValue];
    NSArray *dataOfLikes = [[dict objectForKey:@"likes"] objectForKey:@"data"];
    if(likeCounts < 10 && likeCounts > 0)
    {
        NSString *comma = @"";
        if(likeCounts > 1)
        {
            comma = @",";
        }
        
        [self.numberOfLikes setTitle:[NSString stringWithFormat:@"%@",[[dataOfLikes objectAtIndex:0] objectForKey:@"username"]] forState:UIControlStateNormal];
        CGFloat w =  [self.numberOfLikes.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:10]].width;
        [self.numberOfLikes setFrame:CGRectMake(self.numberOfLikes.frame.origin.x,
                                                self.numberOfLikes.frame.origin.y,
                                                w,
                                                self.numberOfLikes.frame.size.height)];
        [self.numberOfLikes addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect rect     = [self.numberOfLikes frame];
        float xStarting = rect.origin.x;
        float yStarting = rect.origin.y;
        float width     = rect.size.width;
        float height    = rect.size.height;
        CGRect position;
        float xPosition = xStarting + width + SPACE_BETWEEN_LIKES;
        float yPosition = yStarting;
        
        for (int a = 1; a < likeCounts; a++)
        {
            if(a >= likeCounts - 1)
                comma = @"";
            UIButton *likeBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            [likeBtn setTitle:[NSString stringWithFormat:@"%@%@",[[dataOfLikes objectAtIndex:a] objectForKey:@"username"],comma] forState:UIControlStateNormal];
            CGFloat breadth =  [likeBtn.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:10 ]].width;
            [likeBtn setTitleColor:[UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1.0f] forState:UIControlStateNormal];
            [likeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
            [likeBtn setTag:[[[dataOfLikes objectAtIndex:a] objectForKey:@"id"] integerValue]];
            [likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if((xPosition + breadth) < self.frame.size.width)
            {
                position     = CGRectMake(xPosition, yPosition, breadth, height);
                xPosition    = xPosition + breadth + SPACE_BETWEEN_LIKES;
            }
            else if((xPosition + breadth) > self.frame.size.width)
            {
                yPosition   = yPosition + height + SPACE_BETWEEN_LIKES;
                position    = CGRectMake(xStarting, yPosition, breadth, height);
                xPosition   = xStarting + breadth + SPACE_BETWEEN_LIKES;
            }
            //width = breadth;
            
            [likeBtn setFrame:position];
            [self addSubview:likeBtn];
        }
    }
    else
    {
        [self.numberOfLikes setTitle:[NSString stringWithFormat:@"%d likes",likeCounts] forState:UIControlStateNormal];
        CGFloat width =  [self.numberOfLikes.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:10]].width;
        [self.numberOfLikes setFrame:CGRectMake(self.numberOfLikes.frame.origin.x,
                                                self.numberOfLikes.frame.origin.y,
                                                width,
                                                self.numberOfLikes.frame.size.height)];
        [self.numberOfLikes addTarget:self action:@selector(usersWhoLiked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)likeBtnClicked:(id)sender
{
    
}

-(void)usersWhoLiked:(id)sender
{
    
}
#pragma mark -
/*********************************************************************************************************/
/*********************************************************************************************************/


-(void)backFromFullView
{
    [self.fullImageViewer removeFromSuperview];
    //[_fullImageViewer release];
    //self.fullImageViewer = nil;
}

- (void)dealloc {
    [_imagePost release];
    [_dataDictionary release];
    [_numberOfLikes release];
    [_reloadLabel release];
    [_progressView release];
    [super dealloc];
}
@end
