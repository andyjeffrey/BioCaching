    //
//  DropDownView.m
//  CustomTableView
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DropDownView.h"

#import <QuartzCore/QuartzCore.h>


@implementation DropDownView

@synthesize refView;

@synthesize open,close;

@synthesize delegate;



- (id)initWithArrayData:(NSArray*)data cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView paddingTop:(CGFloat)tPaddingTop paddingLeft:(CGFloat)tPaddingLeft paddingRight:(CGFloat)tPaddingRight refView:(UIView*)rView animation:(AnimationType)tAnimation openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration{

	if ((self = [super init])) {
		
		self.arrayData = data;
		
		self.heightOfCell = cHeight;
		
		self.refView = rView;
		
		self.paddingTop = tPaddingTop;
		
		self.paddingLeft = tPaddingLeft;
		
		self.paddingRight = tPaddingRight;
		
		self.heightTableView = tHeightTableView;
		
		self.open = openDuration;
		
		self.close = closeDuration;
		
		CGRect refFrame = refView.frame;
		
		self.view.frame = CGRectMake(refFrame.origin.x-tPaddingLeft,refFrame.origin.y+refFrame.size.height+tPaddingTop,refFrame.size.width+tPaddingRight, tHeightTableView);
		
		self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
		
		self.view.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
		
		self.view.layer.shadowOpacity =1.0f;
		
		self.view.layer.shadowRadius = 5.0f;
        
        self.view.layer.borderWidth = 0.0f;
        self.view.layer.borderColor = [[UIColor blackColor] CGColor];
		
		animationType = tAnimation;
		
	}
	
	return self;
	
}	

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	CGRect refFrame = refView.frame;
		
	self.uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,refFrame.size.width+self.paddingRight, (animationType == BOTH || animationType == BLENDIN)?self.heightTableView:1) style:UITableViewStylePlain];
	
	self.uiTableView.dataSource = self;
	
	self.uiTableView.delegate = self;
	
	[self.view addSubview:self.uiTableView];
	
	self.view.hidden = YES;
	
	if(animationType == BOTH || animationType == BLENDIN)
		[self.view setAlpha:1];
	
	
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return self.heightOfCell;
	
	
}	

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	
	return [self.arrayData count];
	
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
    }
    
	cell.textLabel.text = [self.arrayData objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"System" size:10];
    [cell.textLabel sizeToFit];
		
	return cell;
	
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[delegate dropDownCellSelected:indexPath.row];
	
	[self closeAnimation];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

	return 0;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

	return 0;
	
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

	return @"";
}	

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{

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
	
	[UIView setAnimationDuration:open];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
	
	if(animationType == BOTH || animationType == GROW)
		self.uiTableView.frame = CGRectMake(self.uiTableView.frame.origin.x,self.uiTableView.frame.origin.y,self.uiTableView.frame.size.width, self.heightTableView);
	
	if(animationType == BOTH || animationType == BLENDIN)
		self.view.alpha = 1;
	
	[UIView commitAnimations];
	
	
	
	
	
}

-(void)closeAnimation{
	
	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center];
	
	[UIView beginAnimations:nil context:(__bridge void *)(contextPoint)];
	
	[UIView setAnimationDuration:close];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
	
	if(animationType == BOTH || animationType == GROW)
		self.uiTableView.frame = CGRectMake(self.uiTableView.frame.origin.x,self.uiTableView.frame.origin.y,self.uiTableView.frame.size.width, 1);
	
	if(animationType == BOTH || animationType == BLENDIN)
		self.view.alpha = 0;
	
	[UIView commitAnimations];
	
	[self performSelector:@selector(hideView) withObject:nil afterDelay:close];
	
	
		
}

	 
-(void)hideView{
	
	self.view.hidden = YES;

}

- (BOOL)isHidden {
    return self.view.hidden;
}


@end
