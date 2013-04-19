//
//  FullImageViewer.h
//  Dinstagram
//
//  Created by deepak mishra on 14/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FullImageViewerDelegate <NSObject>
-(void)backFromFullView;
@end

@interface FullImageViewer : UIView <UIGestureRecognizerDelegate,UIScrollViewDelegate>
- (id)initWithFrame:(CGRect)frame withDelegate:(id<FullImageViewerDelegate>)delegate;
-(void)loadWithImageURL:(NSURL *)url;
@end