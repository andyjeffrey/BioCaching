//
//  BCWebViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 13/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCWebViewController.h"

@interface BCWebViewController ()

@end

@implementation BCWebViewController

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        //NSLog "Do Something With URL";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
}

@end
