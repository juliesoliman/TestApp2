//
//  ACHomeCBBCustomCell.m
//  DiscoveriPad
//
//  Created by Brian Anderson on 1/14/14.
//  Copyright (c) 2014 Solstice Mobile. All rights reserved.
//

#import "ACHomeCBBCustomCell.h"

#import "ACHomeConstants.h"

#import "Discover-Commons/DiscoverColors.h"
#import "Discover-Commons/NSString+Utils.h"
#import "Discover-Commons/UILabel+Utils.h"

@interface ACHomeCBBCustomCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cbbImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cbbImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cbbImageWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *cbbDescription;
@property (weak, nonatomic) IBOutlet UILabel *cbbTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cbbDescriptionLeadingAlign;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cbbDescriptionTailingAlign;

@end

@implementation ACHomeCBBCustomCell

- (void)configureCellWithCellObject:(NSDictionary*)cellObject {
    [self setupCellBorder];
    
    NSString *cbbImageName = [cellObject objectForKey:kACHomeCBBCellObjectImageNameKey];
    NSAttributedString *cbbDescriptionText = [cellObject objectForKey:kACHomeCBBCellObjectLabelTextKey];
    NSString *cbbButtonText = [cellObject objectForKey:kACHomeCBBCellObjectButtonTextKey];
    
    // Setup Image (ImageName)
    BOOL isImage = [NSString isValidString:cbbImageName];
    if (isImage) {
        UIImage *image = [UIImage imageNamed:cbbImageName];
        [self.cbbImageHeightConstraint setConstant:image.size.height];
        [self.cbbImageWidthConstraint setConstant:image.size.width];
        [self.cbbImage setImage:image];
    }
    [self showImage:isImage];
    
    // Setup Description (LabelText)
    BOOL isDescriptionText = [NSString isValidString:[cbbDescriptionText string]];
    if (isDescriptionText) {
        [self.cbbDescription setAttributedText:cbbDescriptionText];
    }
    [self showDescriptionText:isDescriptionText];
    
    //This sets the width of the label when autolayout constants (alignment constraints) are applied to it
    self.cbbDescription.preferredMaxLayoutWidth = self.frame.size.width - self.cbbDescriptionLeadingAlign.constant - self.cbbDescriptionTailingAlign.constant;
    
    // Setup Button (ButtonText)
    BOOL isButtonText = [NSString isValidString:cbbButtonText];
    if (isButtonText) {
        [self.cbbTitle setText:cbbButtonText];
        [self.cbbTitle setTextColor:[DiscoverColors link]];
    }
    [self showTitleText:isButtonText];
}

- (void)showImage:(BOOL)show {
    [self.cbbImage setHidden:!show];
}

- (void)showDescriptionText:(BOOL)show {
    [self.cbbDescription setHidden:!show];
}

- (void)showTitleText:(BOOL)show {
    [self.cbbTitle setHidden:!show];
}

- (void)setupCellBorder {
    [self.layer setCornerRadius:5.f];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:[DiscoverColors rulingLine].CGColor];
    [self.layer setBorderWidth:1.0f];
}

@end
