//
//  SGMapViewController.m
//  SpyGeo
//
//  Created by Zhenyi ZHANG on 2012-11-01.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "SGMapViewController.h"
#import "SGLocationAnnotation.h"

@interface SGMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation SGMapViewController

@synthesize annotations = _annotations, mapView = _mapView;

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

#pragma mark - UIView delegate methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    SGLocationAnnotation *annotation = [self.annotations lastObject];
    Location *centerLocation = annotation.location;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([centerLocation.latitude doubleValue], [centerLocation.longitude doubleValue]);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05f, 0.05f);
    MKCoordinateRegion region = {centerCoordinate, span};
    region.center = centerCoordinate;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    [self updateMapView];
    //[self.mapView setCenterCoordinate:centerCoordinate animated:YES];
    //[self.mapView regionThatFits:region];
    
}

- (void)dealloc
{
    [self.mapView removeFromSuperview]; // release crashes app
    self.mapView = nil;
}


//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//MKMapViewDelegate 方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;// DON'T FORGET THIS LINE OF CODE !!
        //aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    //[(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    aView.annotation = annotation;
    return aView;
}

//MKMapViewDelegate 方法
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    /*dispatch_queue_t downloadImageQueue = dispatch_queue_create("download image queue", NULL);
    dispatch_async(downloadImageQueue, ^{
        UIImage *image = [self.delegate mapViewController:self imageForAnnotation:view.annotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIImageView *)view.leftCalloutAccessoryView setImage:image];
        });
    });*/
}

@end
