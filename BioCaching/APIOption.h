//
//  APIOption.h
//  BioCaching
//
//  Created by Andy Jeffrey on 05/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIOption : NSObject

@property (nonatomic, strong) NSString *displayString;
@property (nonatomic, strong) NSString *queryStringValueGBIF;

- (id) initWithValues:(NSString *)displayString queryStringValueGBIF:(NSString *)queryStringValueGBIF;

@end
