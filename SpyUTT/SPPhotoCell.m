//
//  SPPhotoCell.m
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-10-20.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SPPhotoCell.h"

@implementation SPPhotoCell

@synthesize thumbnail = _thumbnail, imageName = _imageName, imageDate = _imageDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
