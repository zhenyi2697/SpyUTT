//
//  SPPhotoCell.h
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-10-20.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *imageName;
@property (weak, nonatomic) IBOutlet UILabel *imageDate;
@property (strong, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@end
