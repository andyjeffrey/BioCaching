//
//  TaxonListCell.h
//  BioCaching
//
//  Created by Andy Jeffrey on 08/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxonListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageIconicTaxon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSubTitle;

@end
