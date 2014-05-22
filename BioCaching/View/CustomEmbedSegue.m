//
//  CustomEmbedSegue.m
//  BioCaching
//
//  Created by Andy Jeffrey on 06/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "CustomEmbedSegue.h"

@implementation CustomEmbedSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
	
	self = [super initWithIdentifier:identifier source:source destination:destination];
    NSLog(@"%s\n source:%@\n destination:%@", __PRETTY_FUNCTION__, source.class, destination.class);
    
    //	if (self) {
    //
    //		if (![self.sourceViewController isKindOfClass:[SBSegmentedViewController class]]) {
    //			NSLog(@"The source view controller for a %@ has to be a %@", NSStringFromClass([self class]), NSStringFromClass([SBSegmentedViewController class]));
    //			return nil;
    //		}
    //
    //		SBSegmentedViewController *source = self.sourceViewController;
    //		[source addViewController:self.destinationViewController];
    //	}
	
	return self;
}

- (void)perform
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Nothing. The ContainerViewController class handles all of the view
    // controller action.
}

@end
