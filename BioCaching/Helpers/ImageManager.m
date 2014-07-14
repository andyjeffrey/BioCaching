//
//  ImageManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 11/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation ImageManager

- (void)getFilenameForLocalAsset:(NSString *)localAssetUrlString
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSURL *assetUrl = [NSURL URLWithString:localAssetUrlString];
    
    [assetsLibrary assetForURL:assetUrl resultBlock: ^(ALAsset *asset){
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        [self.delegate assetFilenameRetrieved:representation.filename];
    } failureBlock: ^(NSError *error){
        // Error Loading Asset From Asset Library
        NSLog(@"Error Loading Asset: %@ %@", assetUrl, error);
        [self.delegate assetFilenameRetrieved:nil];
    }];
}


@end
