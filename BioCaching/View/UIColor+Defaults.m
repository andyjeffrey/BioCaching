//
//  UIColor+Defaults.m
//  BioCaching
//
//  Created by Andy Jeffrey on 29/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "UIColor+Defaults.h"

@implementation UIColor (Defaults)

+(UIColor*) kColorBackground {
    return [UIColor blackColor];
}

+(UIColor*) kColorLabelText {
    return [UIColor lightGrayColor];
}


+(UIColor*) kColorHeaderBackground {
    return [UIColor darkGrayColor];
    
}

+(UIColor*) kColorHeaderText {
    return [UIColor whiteColor];
}


+(UIColor*) kColorTableBackgroundColor {
    return [UIColor colorWithWhite:0.2f alpha:1.0f];
}

+(UIColor*) kColorTableCellText {
    return [UIColor kColorLabelText];
}

+(UIColor*) kColorTableCellSeparator {
    return [UIColor darkGrayColor];
}

+(UIColor*) kColorTableBorders {
    return [UIColor lightGrayColor];
}


+(UIColor*) kColorButtonBackground {
    return [UIColor darkGrayColor];
}
+(UIColor*) kColorButtonBackgroundHighlight {
    return [UIColor colorWithWhite:0.3f alpha:1.0];
}

+(UIColor*) kColorButtonLabel {
    return [UIColor whiteColor];
}
+(UIColor*) kColorButtonLabelHighlight {
    return [UIColor kColorINatGreen];
}

+(UIColor*) kColorBCButtonBackground {
    return [UIColor colorWithWhite:0.3f alpha:1.0];
}
+(UIColor*) kColorBCButtonBackgroundHighlight {
    return [UIColor colorWithWhite:0.2f alpha:1.0];
}
+(UIColor*) kColorBCButtonLabel {
    return [UIColor lightGrayColor];
}


+(UIColor*) kColorINatGreen {
    return [UIColor colorWithRed:116/255.0f green:172/255.0f blue:0/255.0f alpha:1.0f];
}
+(UIColor*) kColorDarkGreen {
    return [UIColor colorWithRed:0/255.0f green:160/255.0f blue:0/255.0f alpha:1.0f];
}
+(UIColor*) kColorDarkRed {
    return [UIColor colorWithRed:160/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
}
+(UIColor*) kColorDarkRedHighlighted {
    return [UIColor colorWithRed:135/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
}

@end
