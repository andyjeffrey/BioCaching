//
//  ImageManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 11/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageManagerDelegate <NSObject>
- (void)assetFilenameRetrieved:(NSString *)filename;
@end

@interface ImageManager : NSObject

@property (nonatomic, weak) id <ImageManagerDelegate> delegate;

@end
