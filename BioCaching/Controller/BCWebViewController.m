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

@implementation BCWebViewController {
    NSDictionary *_currentNavBarTitleTextAttributes;
    NSString *_fixedTitle;
}

- (id)initWithURL:(NSURL *)url fixedTitle:(NSString *)fixedTitle{
    self = [super initWithURL:url];
    if (self) {
        _fixedTitle = fixedTitle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentNavBarTitleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0], UITextAttributeFont, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.titleTextAttributes = _currentNavBarTitleTextAttributes;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    if (_fixedTitle) {
        self.navigationItem.title = _fixedTitle;
    }
}

@end
