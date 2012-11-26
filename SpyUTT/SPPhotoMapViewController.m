//
//  SPPhotoMapViewController.m
//  SpyPhoto
//
//  Created by Zhenyi ZHANG on 2012-11-05.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SPPhotoMapViewController.h"
#import "SPPhotoViewerController.h"
#import "SPAllDetailsViewController.h"

@interface SPPhotoMapViewController () <MKMapViewDelegate>
@property (nonatomic,strong) ALAsset *currentPhoto;
@property (nonatomic,strong) SPPhotoAnnotation *currentAnnotation;
@end

@implementation SPPhotoMapViewController 

@synthesize annotations = _annotations, mapView = _mapView;
@synthesize currentPhoto = _currentPhoto;
@synthesize changePhotoToolBar = _changePhotoToolBar;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.currentMap isEqualToString:MAP_SHOWS_ALL_PHOTOS]) {
        [self.changePhotoToolBar setHidden:NO];
    } else {
        [self.changePhotoToolBar setHidden:YES];
    }
}

- (void)centerToAnnotation:(SPPhotoAnnotation *)annotation
{
    NSDictionary *gpsInfo = annotation.gpsInfo;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([(NSNumber *)[gpsInfo objectForKey:@"Latitude"] doubleValue], [(NSNumber *)[gpsInfo objectForKey:@"Longitude"] doubleValue]);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05f, 0.05f);
    MKCoordinateRegion region = {centerCoordinate, span};
    region.center = centerCoordinate;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView setCenterCoordinate:centerCoordinate animated:YES];
    //[self updateMapView];
    
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SPPhotoAnnotation *annotation;
    if ([self.currentMap isEqualToString:MAP_SHOWS_ONE_PHOTO]) {
        annotation = [self.annotations lastObject];
    } else if([self.currentMap isEqualToString:MAP_SHOWS_ALL_PHOTOS]){
        annotation = [self.annotations objectAtIndex:0];
    }
    [self centerToAnnotation:annotation];
}

//以下几个方法一般都要写
-(void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    _mapView.delegate = self;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

-(void)showPhotoFromMapView
{
    [self performSegueWithIdentifier: @"showPhotoFromMapView" sender:self];
}

-(void)showPhotoDetailFromMapView
{
    [self performSegueWithIdentifier: @"showPhotoDetailFromMapView" sender:self];
}

- (UIButton *)createShowImageButtonWithPhoto:(ALAsset *)photo
{
    UIButton *showImageButton;
    
    UIImage *myImage = [UIImage imageWithCGImage: [photo thumbnail]];
    showImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showImageButton.frame = CGRectMake(0,0,30,30);
    
    [showImageButton setBackgroundImage:myImage forState:UIControlStateNormal];
    [showImageButton setBackgroundColor:[UIColor clearColor]];
    
    [showImageButton addTarget:self action:@selector(showPhotoFromMapView) forControlEvents:UIControlEventTouchUpInside];
    return showImageButton;
}

//MKMapViewDelegate 方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;// DON'T FORGET THIS LINE OF CODE !!
        aView.leftCalloutAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aView.rightCalloutAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30,30)];
    }
    SPPhotoAnnotation *anno = (SPPhotoAnnotation *)annotation;
    //[(UIImageView *)aView.leftCalloutAccessoryView setImage:[UIImage imageWithCGImage:[anno.photo thumbnail]]];
    
    UIButton *showImageButton = [self createShowImageButtonWithPhoto:anno.photo];
    [aView.leftCalloutAccessoryView addSubview:showImageButton];
    
    if ([self.currentMap isEqualToString:MAP_SHOWS_ALL_PHOTOS]) {
        UIButton *showDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [aView.rightCalloutAccessoryView addSubview:showDetailButton];
        [showDetailButton addTarget:self action:@selector(showPhotoDetailFromMapView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    aView.annotation = annotation;
    return aView;
}

- (IBAction)closeMap:(UIBarButtonItem *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showPreviousPhoto:(UIButton *)sender {
    int currentIndex = [self.annotations indexOfObject:self.currentAnnotation];
    int nextIndex = 0;
    if ((currentIndex - 1) >= 0) {
        nextIndex = currentIndex - 1;
    } else {
        nextIndex = [self.annotations count] - 1;
    }
    
    SPPhotoAnnotation *annotation = [self.annotations objectAtIndex:nextIndex];
    [self centerToAnnotation:annotation];
}

- (IBAction)showNextPhoto:(UIButton *)sender {
    int currentIndex = [self.annotations indexOfObject:self.currentAnnotation];
    int nextIndex = 0;
    if ((currentIndex + 1) < ([self.annotations count])) {
        nextIndex = currentIndex + 1;
    }
    
    SPPhotoAnnotation *annotation = [self.annotations objectAtIndex:nextIndex];
    [self centerToAnnotation:annotation];
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    SPPhotoAnnotation *annotation = (view.annotation);
    self.currentPhoto = annotation.photo;
    self.currentAnnotation = annotation;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showPhotoFromMapView"]) {
        SPPhotoViewerController *photoViewController = (SPPhotoViewerController *)segue.destinationViewController;
        photoViewController.photo = self.currentPhoto;
    } else if ([segue.identifier isEqualToString:@"showPhotoDetailFromMapView"]) {
        SPAllDetailsViewController *detailViewController = (SPAllDetailsViewController *)[segue destinationViewController];
        detailViewController.photo = self.currentPhoto;
    }
}

@end
