//
//  ABDContentCell.m
//  ABDemo
//
//  Created by Zhang on 06/10/12.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "ABDContentCell.h"

@implementation ABDContentCell

@synthesize name=_name, phone=_phone, email=_email,
            company = _company, title = _title, birthday = _birthday, address = _address;
@synthesize subview = _subview;

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
