//
//  ACHomeCustomCell.m
//  DiscoveriPad
//
//  Created by Brian Anderson on 1/14/14.
//  Copyright (c) 2014 Solstice Mobile. All rights reserved.
//

#import "ACHomeCustomCell.h"

#import "ACHomeConstants.h"

#import "Discover-Commons/DiscoverColors.h"
#import "Discover-Commons/NSString+Utils.h"
#import "Discover-Commons/UILabel+Utils.h"

@interface ACHomeCustomCell ()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionLabelButton;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureImage;
@property (weak, nonatomic) IBOutlet UILabel *rewardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardsValueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subheaderLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBorderImageView;

@end

@implementation ACHomeCustomCell

- (void)configureCellWithCellObject:(NSDictionary *)cellObject withBottomBorder:(BOOL)bottomBorder {
    
    [self.headerLabel setText:[cellObject objectForKey:kACHomeCustomCellHeaderKey]];
    [self.subheaderLabel setText:[cellObject objectForKey:kACHomeCustomCellSubheaderKey]];
    [self.subheaderLabel resizeLabelHeight];
    [self.subheaderLabelHeightConstraint setConstant:self.subheaderLabel.frame.size.height];

    NSString *valueLabelString = [cellObject objectForKey:kACHomeCustomCellAmountKey];
    NSString *actionLabelString = [cellObject objectForKey:kACHomeCustomCellActionLabelKey];
    NSString *rewardValueString = [cellObject objectForKey:kACHomeCustomCellRewardValueKey];

    // Set value label or hide value label
    BOOL hasValueLabel = [NSString isValidString:valueLabelString];
    if (hasValueLabel) {
        [self.valueLabel setText:valueLabelString];
    }
    [self showValueLabel:hasValueLabel];
    
    // Set the action label or hide disclosure image if there is no actionlabel
    BOOL hasActionLabel = [NSString isValidString:actionLabelString];
    if (hasActionLabel) {
        [self.actionLabelButton setTitle:actionLabelString forState:UIControlStateNormal];
    }
    [self showActionLabel:hasActionLabel];
    
    // Set the rewards value or hide if not a rewards cell
    BOOL isRewardsCell = [NSString isValidString:rewardValueString];
    if (isRewardsCell) {
        [self.rewardsLabel setText:[self localizedStringForACHomeWithKey:kACHomeRewardsNewlyEarnedKey]];
        [self.rewardsValueLabel setText:rewardValueString];
    }
    [self showRewardsLabels:isRewardsCell];
    if (bottomBorder) {
        [self showBottomBorder];
    } else {
        [self.bottomBorderImageView setHidden:YES];
    }
}

- (BOOL)isBottomBorderHidden {
    return [self.bottomBorderImageView isHidden];
}

- (void)showBottomBorder {
    static NSString *DashedImageIdentifier = @"DashedCellDivider";
    UIImage *dashedBorderImage = [[UIImage imageNamed:DashedImageIdentifier] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    [self.bottomBorderImageView setImage:dashedBorderImage];
    [self.bottomBorderImageView setHidden:NO];
}

- (void)showValueLabel:(BOOL)show {
    [self.valueLabel setHidden:!show];
}

- (void)showActionLabel:(BOOL)show {
    [self.actionLabelButton setHidden:!show];
    [self.disclosureImage setHidden:!show];
}

- (void)showRewardsLabels:(BOOL)show {
    [self.rewardsLabel setHidden:!show];
    [self.rewardsValueLabel setHidden:!show];
}

- (NSString *)localizedStringForACHomeWithKey:(NSString *)key {
    return [NSString retrieveLocalizedStringForKey:key inStringsList:kACHomeStringFile];
}

@end
