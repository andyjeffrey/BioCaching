//
//  DropDownViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 28/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "DropDownViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation DropDownViewController
{
    NSArray *_dataArray;
    CGRect _refFrame;
    CGFloat _tableViewHeight;
    CGFloat _paddingTop;
    CGFloat _paddingLeft;
    CGFloat _paddingRight;
    CGFloat _tableCellHeight;
    BCViewAnimationStyle _animationStyle;
    CGFloat _openDuration;
    CGFloat _closeDuration;
}

- (id)initWithArrayData:(NSArray*)dataArray refFrame:(CGRect)refFrame tableViewHeight:(CGFloat)tableViewHeight paddingTop:(CGFloat)paddingTop paddingLeft:(CGFloat)paddingLeft paddingRight:(CGFloat)paddingRight tableCellHeight:(CGFloat)tableCellHeight animationStyle:(BCViewAnimationStyle)animationStyle  openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration
{
	if ((self = [super init])) {
		
        _dataArray = dataArray;
        _refFrame = refFrame;
        _tableViewHeight = tableViewHeight;
        _paddingTop = paddingTop;
        _paddingLeft = paddingLeft;
        _paddingRight = paddingRight;
        _tableCellHeight = tableCellHeight;
        _animationStyle = animationStyle;
        _openDuration = openDuration;
        _closeDuration = closeDuration;

		self.view.frame = CGRectMake(refFrame.origin.x-paddingLeft,
                                     refFrame.origin.y+refFrame.size.height+paddingTop,
                                     refFrame.size.width+paddingRight,
                                     tableViewHeight);
		
		self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
		self.view.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
		self.view.layer.shadowOpacity =1.0f;
		self.view.layer.shadowRadius = 5.0f;
        self.view.layer.borderWidth = 0.0f;
        self.view.layer.borderColor = [[UIColor blackColor] CGColor];
	}
	
	return self;
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	_uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,_refFrame.size.width+_paddingRight, (_animationStyle ==  BCViewAnimationStyleBoth || _animationStyle == BCViewAnimationStyleFade)?_tableViewHeight:1) style:UITableViewStylePlain];
	
	_uiTableView.dataSource = self;
	_uiTableView.delegate = self;
	
	[self.view addSubview:_uiTableView];
	
	self.view.hidden = YES;
	
	if(_animationStyle == BCViewAnimationStyleBoth || _animationStyle == BCViewAnimationStyleFade) {
		[self.view setAlpha:1];
    }
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return _tableCellHeight;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:10];
    [cell.textLabel sizeToFit];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate dropDownCellSelected:indexPath.row];
	[self closeAnimation];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return @"";
}

#pragma mark -
#pragma mark DropDownViewDelegate

-(void)dropDownCellSelected:(NSInteger)returnIndex{
	
}

#pragma mark -
#pragma mark Class Methods


-(void)openAnimation{
	
	self.view.hidden = NO;
	
	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center];
    
	[UIView beginAnimations:nil context:(__bridge void *)(contextPoint)];
	
	[UIView setAnimationDuration:_openDuration];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
	
	if(_animationStyle == BCViewAnimationStyleBoth || _animationStyle == BCViewAnimationStyleGrow) {
		_uiTableView.frame = CGRectMake(_uiTableView.frame.origin.x,
                                        _uiTableView.frame.origin.y,
                                        _uiTableView.frame.size.width,
                                        _tableViewHeight);
    }
	
	if(_animationStyle == BCViewAnimationStyleBoth || _animationStyle == BCViewAnimationStyleFade)
		self.view.alpha = 1;
	
	[UIView commitAnimations];
}

-(void)closeAnimation{
	
	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center];
	
	[UIView beginAnimations:nil context:(__bridge void *)(contextPoint)];
	
	[UIView setAnimationDuration:_closeDuration];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
	
	if(_animationStyle == BCViewAnimationStyleBoth || _animationStyle == BCViewAnimationStyleGrow) {
		self.uiTableView.frame = CGRectMake(_uiTableView.frame.origin.x,
                                            _uiTableView.frame.origin.y,
                                            _uiTableView.frame.size.width,
                                            1);
    }
	
	if(_animationStyle == BCViewAnimationStyleBoth || _animationStyle == BCViewAnimationStyleFade)
		self.view.alpha = 0;
	
	[UIView commitAnimations];
	
	[self performSelector:@selector(hideView) withObject:nil afterDelay:_closeDuration];
}


-(void)hideView
{
	self.view.hidden = YES;
}

- (BOOL)isHidden
{
    return self.view.hidden;
}

@end
