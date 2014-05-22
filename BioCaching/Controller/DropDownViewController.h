//
//  DropDownViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 28/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownViewDelegate.h"

typedef enum {
    BCViewAnimationStyleFade,
	BCViewAnimationStyleGrow,
	BCViewAnimationStyleBoth
} BCViewAnimationStyle;


@interface DropDownViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, readonly) BOOL isHidden;
@property (nonatomic, readonly, strong) UITableView *uiTableView;
@property (nonatomic, weak) id<DropDownViewDelegate> delegate;

- (id)initWithArrayData:(NSArray*)dataArray refFrame:(CGRect)refFrame tableViewHeight:(CGFloat)tableViewHeight paddingTop:(CGFloat)paddingTop paddingLeft:(CGFloat)paddingLeft paddingRight:(CGFloat)paddingRight tableCellHeight:(CGFloat)tableCellHeight animationStyle:(BCViewAnimationStyle)animationStyle  openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration;

-(void)closeAnimation;
-(void)openAnimation;

@end
