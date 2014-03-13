//
//  GBIFOccurenceResults.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFOccurrenceResults.h"

@implementation GBIFOccurrenceResults

@synthesize Offset;
@synthesize Limit;
@synthesize EndOfRecords;
@synthesize Count;
@synthesize Results;

+ (id) objectWithDictionary:(NSDictionary*)dictionary
{
    id obj = [[GBIFOccurrenceResults alloc] initWithDictionary:dictionary];
    return obj;
}

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if(self)
    {
        Offset = [dictionary objectForKey:@"offset"];
        Limit = [dictionary objectForKey:@"limit"];
        EndOfRecords = [dictionary objectForKey:@"endOfRecords"];
        Count = [dictionary objectForKey:@"count"];
        
        NSArray* temp =  [dictionary objectForKey:@"results"];
        Results = [[NSMutableArray alloc] init];
        for (NSDictionary *d in temp) {
            //NSLog(@"Adding Record: %@", d);
            [Results addObject:[GBIFOccurrence objectWithDictionary:d]];
        }
    }
    
    return self;
}

@end
