//
//  TaxonListCell.h
//  BioCaching
//
//  Created by Andy Jeffrey on 08/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaxonListCell;
@protocol TaxonListCellDelegate
- (void)actionButtonSelected:(TaxonListCell *)cell;
@end

@interface TaxonListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageIconicTaxon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSubTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonAction;

@property (weak, nonatomic) id<TaxonListCellDelegate> delegate;

- (IBAction)performAction:(id)sender;

@end
