//
//  HomeViewCell.h
//  Dinstagram
//
//  Created by deepak mishra on 13/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullImageViewer.h"
#import "GSProgressView.h"

@interface HomeViewCell : UITableViewCell<UIGestureRecognizerDelegate, FullImageViewerDelegate>

// properties related to image feed
@property (retain, nonatomic) IBOutlet UILabel *reloadLabel;
@property (retain, nonatomic) IBOutlet UIImageView *imagePost;
@property (retain, nonatomic) IBOutlet GSProgressView *progressView;

// properties related to user comments and likes
@property (retain, nonatomic) IBOutlet UIButton *numberOfLikes;

-(void)loadImage:(NSDictionary *)dict;
-(void)loadLikesComments:(NSDictionary *)dict;
-(void)layoutData:(NSDictionary *)data;
-(void)likeBtnClicked:(id)sender;
-(void)usersWhoLiked:(id)sender;
- (void)tapGestureReceived:(UITapGestureRecognizer *)sender;
@end
