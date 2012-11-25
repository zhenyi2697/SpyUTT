//
//  SPAllDetailsViewController.m
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-05.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SPAllDetailsViewController.h"
#import "SPPhotoMapViewController.h"
#import "SPPhotoAnnotation.h"
#import "SPPhotoViewerController.h"

@interface SPAllDetailsViewController ()
@property (nonatomic,strong) NSDictionary *photoMetaData;
@property (nonatomic,strong) NSArray *allKeysSortedArray;
@property (nonatomic,strong) NSArray *exifAuxKeyArray;
@property (nonatomic,strong) NSDictionary *exifAuxDic;
@property (nonatomic,strong) NSArray *exifKeyArray;
@property (nonatomic,strong) NSDictionary *exifDic;
@property (nonatomic,strong) NSArray *gpsKeyArray;
@property (nonatomic,strong) NSDictionary *gpsDic;
@property (nonatomic,strong) NSArray *tiffKeyArray;
@property (nonatomic,strong) NSDictionary *tiffDic;
@property (nonatomic,strong) NSMutableDictionary *multipleValueDic;// keys : titles and value: number of rows in this titles
@property (nonatomic,strong) UIButton *showImageButton;
@property (nonatomic,strong) NSString *assetType;

@end

@implementation SPAllDetailsViewController

@synthesize photo = _photo;
@synthesize photoMetaData = _photoMetaData;
@synthesize allKeysSortedArray = _allKeysSortedArray;
@synthesize exifAuxDic = _exifAuxDic, exifAuxKeyArray = _exifAuxKeyArray, exifDic = _exifDic, exifKeyArray = _exifKeyArray;
@synthesize gpsDic = _gpsDic, gpsKeyArray = _gpsKeyArray;
@synthesize tiffDic = _tiffDic,tiffKeyArray = _tiffKeyArray;
@synthesize multipleValueDic = _multipleValueDic;
@synthesize showImageButton = _showImageButton;
@synthesize assetType = _assetType;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.multipleValueDic = [[NSMutableDictionary alloc] init];
    
    
    ALAssetRepresentation *representation = [self.photo defaultRepresentation];
    
    self.assetType = [self.photo valueForProperty:ALAssetPropertyType];
    
    if ([self.assetType isEqualToString:ALAssetTypePhoto]){
        //get image metadata
        NSDictionary *metaDictionary = [representation metadata];
        self.photoMetaData = metaDictionary;
        NSArray *allKeys = [self.photoMetaData allKeys];
        self.allKeysSortedArray = [allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        for(NSString *key in self.allKeysSortedArray) {
            //NSLog(@"value for key: %@ is %@",key,[metaDictionary objectForKey:key]);
            id objectForSection = [self.photoMetaData objectForKey:key];
            if ([objectForSection isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)objectForSection;
                NSArray *keys = [(NSDictionary *)objectForSection allKeys];
                [self.multipleValueDic setObject:[NSNumber numberWithInt:[keys count]] forKey:key];
                if([key isEqualToString:@"{ExifAux}"]) {
                    self.exifAuxKeyArray = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                    self.exifAuxDic = dic;
                } else if ([key isEqualToString:@"{Exif}"]) {
                    self.exifKeyArray = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                    self.exifDic = dic;
                } else if ([key isEqualToString:@"{GPS}"]) {
                    self.gpsKeyArray = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                    self.gpsDic = dic;
                } else if ([key isEqualToString:@"{TIFF}"]) {
                    self.tiffKeyArray = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                    self.tiffDic = dic;
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.assetType isEqualToString:ALAssetTypeVideo]) {
        return 1;
    }
    return [self.allKeysSortedArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if ([self.assetType isEqualToString:ALAssetTypeVideo]) {
        return 2;
    } else {
        if ([self.multipleValueDic objectForKey:[self.allKeysSortedArray objectAtIndex:section]]) {
            NSNumber *numberOfSections = (NSNumber *)[self.multipleValueDic objectForKey:[self.allKeysSortedArray objectAtIndex:section]];
            return [numberOfSections intValue];
        } else {
            return 1;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.assetType isEqualToString:ALAssetTypeVideo]) {
        return @"General";
    } else {
        if([self.multipleValueDic objectForKey:[self.allKeysSortedArray objectAtIndex:section]]){
            return [self.allKeysSortedArray objectAtIndex:section];
        }
    }
    return nil;
}

- (NSString *)prepareArrayValueForDispaly:(NSArray *)array
{
    NSString *stringValue = @"";
    for (id value in array) {
        stringValue = [stringValue stringByAppendingFormat:@"%@,",value];
    }
    stringValue = [stringValue substringToIndex:[stringValue length] -1];
    return stringValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *labelText;
    NSString *detailLabelText;
    if ([self.assetType isEqualToString:ALAssetTypeVideo]) {
        if (indexPath.row == 0) {
            labelText = @"Duration";
            float length = [(NSNumber *)[self.photo valueForProperty:ALAssetPropertyDuration] floatValue];
            detailLabelText = [NSString stringWithFormat:@"%.2f s",length];
        } else if(indexPath.row == 1) {
            labelText = @"Size";
            long long size = [[self.photo defaultRepresentation] size];
            float sizeInFloat = (long double)size/(1024 * 1024);
            detailLabelText = [NSString stringWithFormat:@"%.2f MB",sizeInFloat];
        }
    } else {
        NSString *sectionTitle = [self.allKeysSortedArray objectAtIndex:indexPath.section];
        if([sectionTitle isEqualToString:@"{ExifAux}"]) {
            labelText = [self.exifAuxKeyArray objectAtIndex:indexPath.row];
            detailLabelText = [[self.exifAuxDic objectForKey:labelText] description];
        } else if ([sectionTitle isEqualToString:@"{Exif}"]) {
            labelText = [self.exifKeyArray objectAtIndex:indexPath.row];
            id objectValue = [self.exifDic objectForKey:labelText];
            NSString *stringValue = @"";
            if ([objectValue isKindOfClass:[NSArray class]]) {
                stringValue = [self prepareArrayValueForDispaly:(NSArray *)objectValue];
            } else {
                stringValue = [objectValue description];
            }
            if ([labelText isEqualToString:@"ExifVersion"] ||[labelText isEqualToString:@"FlashPixVersion"] ) {
                stringValue = [stringValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
            }
            detailLabelText = stringValue;
        } else if ([sectionTitle isEqualToString:@"{GPS}"]) {
            labelText = [self.gpsKeyArray objectAtIndex:indexPath.row];
            detailLabelText = [[self.gpsDic objectForKey:labelText] description];
        } else if ([sectionTitle isEqualToString:@"{TIFF}"]) {
            labelText = [self.tiffKeyArray objectAtIndex:indexPath.row];
            detailLabelText = [[self.tiffDic objectForKey:labelText] description];
        } else {
            labelText = sectionTitle;
            detailLabelText = [[self.photoMetaData objectForKey:sectionTitle] description];
        }
    }
    
    // Configure the cell...
    cell.textLabel.text = labelText;
    cell.detailTextLabel.text = detailLabelText;
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return 130;
    } else if([self.multipleValueDic objectForKey:[self.allKeysSortedArray objectAtIndex:section]]){
        return 30;
    } else {
        return 1;
    }
}

- (void)showMapForAPhoto
{
    [self performSegueWithIdentifier: @"showMapForAPhoto" sender:self];
}

-(void)showPhotoFromTableView
{
    [self performSegueWithIdentifier: @"showPhotoFromTableView" sender:self];
}

- (UIButton *)createShowImageButtonWithPhoto:(ALAsset *)photo
{
    UIButton *showImageButton;
    
    UIImage *myImage = [UIImage imageWithCGImage: [photo thumbnail]];
    showImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showImageButton.frame = CGRectMake(20,20,80,80);
    
    [showImageButton setBackgroundImage:myImage forState:UIControlStateNormal];
    [showImageButton setBackgroundColor:[UIColor clearColor]];
//    [showImageButton setTitle:@"show on map" forState:UIControlStateNormal];
    
    [showImageButton addTarget:self action:@selector(showPhotoFromTableView) forControlEvents:UIControlEventTouchUpInside];
    self.showImageButton = showImageButton;
    return showImageButton;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(20,0,300,60)];
    
    // configure image title
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.frame = CGRectMake(120,18,200,20);
    headerLabel.textColor = [UIColor grayColor];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.frame = CGRectMake(120,33,230,25);
    
    if(section == 0){
        // configure image thumbnail
        UIImage *myImage = [UIImage imageWithCGImage: [self.photo thumbnail]];
        
        UIButton *showImageButton = [self createShowImageButtonWithPhoto:self.photo];
        
        ALAssetRepresentation *presentation = [self.photo defaultRepresentation];
        headerLabel.text = [presentation filename];
        
        //configure image date
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        NSDate *imageDate = [self.photo valueForProperty:ALAssetPropertyDate];
        NSString *dateString = [formatter stringFromDate:imageDate];
        detailLabel.text = dateString;
        
        // create the imageView with the image in it
        UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
        imageView.frame = CGRectMake(10,10,100,100);
        
        
//        UILabel *gpsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        UIButton *myButton;
        if(self.gpsDic){
            myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            myButton.frame = CGRectMake(120,60,135,35);
            [myButton setTitle:@"show on map" forState:UIControlStateNormal];
            
            [myButton addTarget:self action:@selector(showMapForAPhoto) forControlEvents:UIControlEventTouchUpInside];
        }
        
//        gpsLabel.backgroundColor = [UIColor clearColor];
//        gpsLabel.textColor = [UIColor blueColor];
//        gpsLabel.font = [UIFont systemFontOfSize:12];
//        gpsLabel.frame = CGRectMake(120,60,230,25);
//        gpsLabel.text = @"Show On Map";
        
        //[customView addSubview:imageView];
        [customView addSubview:showImageButton];
        
        [customView addSubview:headerLabel];
        [customView addSubview:detailLabel];
        [customView addSubview:myButton];
    }else if([self.multipleValueDic objectForKey:[self.allKeysSortedArray objectAtIndex:section]]){
        headerLabel.frame = CGRectMake(20,0,230,25);
        headerLabel.text = [self.allKeysSortedArray objectAtIndex:section];
        [customView addSubview:headerLabel];
    }
    
    return customView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMapForAPhoto"]) {
        SPPhotoMapViewController *mapViewController = (SPPhotoMapViewController *)[[segue.destinationViewController viewControllers] objectAtIndex:0];
        SPPhotoAnnotation *annotation = [SPPhotoAnnotation annotationForPhoto:self.photo andMetaData:self.gpsDic];
        NSArray *annotations = [[NSArray alloc] initWithObjects:annotation, nil];
        mapViewController.annotations = annotations;
        mapViewController.currentMap = MAP_SHOWS_ONE_PHOTO;
    } else if([[segue identifier] isEqualToString:@"showPhotoFromTableView"]) {
        SPPhotoViewerController *photoViewController = (SPPhotoViewerController *)segue.destinationViewController;
        photoViewController.photo = self.photo;
    }
}

@end
