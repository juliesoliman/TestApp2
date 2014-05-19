//
//  ACHomeCustomCell.h
//  DiscoveriPad
//
//  Created by Brian Anderson on 1/14/14.
//  Copyright (c) 2014 Solstice Mobile. All rights reserved.
//

@interface ACHomeCustomCell : UICollectionViewCell

- (void)configureCellWithCellObject:(NSDictionary*)cellObject withBottomBorder:(BOOL)bottomBorder;

- (BOOL)isBottomBorderHidden;
- (void)showBottomBorder;

@end
