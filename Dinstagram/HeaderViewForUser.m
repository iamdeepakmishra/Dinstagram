//
//  HeaderViewForUser.m
//  Dinstagram
//
//  Created by deepak mishra on 13/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

#import "HeaderViewForUser.h"
#import <UIImageView+AFNetworking.h>

@interface HeaderViewForUser ()
@property(nonatomic, retain)NSDictionary *dataDictionary;
@end

@implementation HeaderViewForUser

- (id)initWithFrame:(CGRect)frame withDataDictionary:(NSDictionary *)dict
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataDictionary = dict;
        self.backgroundColor = [UIColor whiteColor];
        if([self.dataDictionary objectForKey:@"caption"]!=[NSNull null])
            [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    CGRect imageRect = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    CGRect usernameRect = CGRectMake(5+26+5, 2, 100, 26);
    
    //************Profile Picture Loading****************
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageRect];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setImageWithURL:[NSURL URLWithString:[[[self.dataDictionary objectForKey:@"caption"] objectForKey:@"from"]objectForKey:@"profile_picture"]]];
    [self addSubview:imageView];
    [imageView release];
    
    
    //***********Username Loading***********************
    UILabel *username = [[UILabel alloc]initWithFrame:usernameRect];
    [username setBackgroundColor:[UIColor clearColor]];
    [username setTextColor:[UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1.0f]];
    [username setFont:[UIFont systemFontOfSize:12]];
    [username setText:[[[self.dataDictionary objectForKey:@"caption"] objectForKey:@"from"] objectForKey:@"username"]];
    [self addSubview:username];
}

@end
