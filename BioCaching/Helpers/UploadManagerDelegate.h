//
//  UploadManagerDelegate.h
//  BioCaching
//
//  Created by Andy Jeffrey on 14/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadManagerDelegate
@required
- (void)uploadingEntity:(NSString *)entity counter:(NSNumber *)counter;
@end
