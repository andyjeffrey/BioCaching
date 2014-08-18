//
//  BCWebViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 13/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <NIWebController.h>

@interface BCWebViewController : NIWebController

- (id)initWithURL:(NSURL *)url fixedTitle:(NSString *)fixedTitle;

@end
