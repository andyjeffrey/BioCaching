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
    return [UIColor colorWithWhite:0.2f alpha:1.0];
}
+(UIColor*) kColorButtonLabel {
    return [UIColor whiteColor];
}


+(UIColor*) kColorINatGreen {
    return [UIColor colorWithRed:116/255.0f green:172/255.0f blue:0/255.0f alpha:1.0f];
}
+(UIColor*) kColorPastelGreen {
    return [UIColor colorWithRed:129/255.0f green:195/255.0f blue:65/255.0f alpha:1.0f];
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

+(UIColor *) kColorINatTaxaBlue {
    return [UIColor colorWithRed:30/255.0f green:144/255.0f blue:255/255.0f alpha:1.0f];
}
+(UIColor *) kColorINatTaxaGreen {
    return [UIColor colorWithRed:116/255.0f green:172/255.0f blue:0/255.0f alpha:1.0f];
}
+(UIColor *) kColorINatTaxaOrange {
    return [UIColor colorWithRed:255/255.0f green:69/255.0f blue:0/255.0f alpha:1.0f];
}
+(UIColor *) kColorINatTaxaBrown {
    return [UIColor colorWithRed:153/255.0f green:51/255.0f blue:0/255.0f alpha:1.0f];
}
+(UIColor *) kColorINatTaxaPinkLight {
    return [UIColor colorWithRed:255/255.0f green:0/255.0f blue:102/255.0f alpha:1.0f];
}
+(UIColor *) kColorINatTaxaPinkDark {
    return [UIColor colorWithRed:170/255.0f green:0/255.0f blue:68/255.0f alpha:1.0f];
}
+(UIColor *) kColorINatTaxaPurpleLight {
    return [UIColor colorWithRed:255/255.0f green:0/255.0f blue:255/255.0f alpha:1.0f];
}
+(UIColor *) kColorINatTaxaPurpleDark {
    return [UIColor colorWithRed:128/255.0f green:0/255.0f blue:12/255.0f alpha:1.0f];
}
+(UIColor *) kColorINatTaxaGrey {
    return [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
}


@end
