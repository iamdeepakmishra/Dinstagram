//
//  HomeViewController.m
//  Dinstagram
//
//  Created by deepak mishra on 13/3/13.
//  Copyright (c) 2013 deepak mishra. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewCell.h"
#import "HeaderViewForUser.h"
#import "IGRequest.h"

@interface HomeViewController ()
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;
@property (retain, nonatomic) IGRequest *igRequest;
@end

@implementation HomeViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    self.title = @"Home";
    [self.reloadButton setHidden:YES];
    [self.tableView setHidden:YES];
}

-(void)dInstagramSessionIsValid
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/feed", @"method", nil];
    self.igRequest = [self.dInstagram requestWithParams:params
                              delegate:self];
}

//this method will be called at every response received , So do not initialize any object here
-(void)loadData
{
    [self.reloadButton setHidden:YES];
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
}

-(void)failWithError
{
    [self.reloadButton setHidden:NO];
}

- (IBAction)reloadButtonTapped:(id)sender
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark UITable View Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, 308, 30);
    HeaderViewForUser *headerViewForUser = [[[HeaderViewForUser alloc]initWithFrame:rect withDataDictionary:[self.data objectAtIndex:section]] autorelease];
    return headerViewForUser;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 383.0f ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.data objectAtIndex:indexPath.section];
    
    NSString *cellIdentifier = @"CellIdentifier";
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewCell" owner:self options:nil] lastObject];
        [cell layoutData:dict];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //[_tableView release];
    [_reloadButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setReloadButton:nil];
    [super viewDidUnload];
}
@end
