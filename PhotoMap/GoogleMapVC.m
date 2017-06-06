//
//  SecondViewController.m
//  PhotoMap
//
//  Created by Sinisa Vukovic on 31/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

#import "GoogleMapVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CustomTabController.h"
@import CoreLocation;

@interface GoogleMapVC () <CLLocationManagerDelegate>
@property GMSMapView *mapView;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CustomTabController *tabController;
@end

@implementation GoogleMapVC

- (void)viewDidLoad {
   [super viewDidLoad];
   self.tabController =  (CustomTabController *)self.tabBarController;
   self.locationManager = [[CLLocationManager alloc] init];
   self.locationManager.delegate = self;
   self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
   [self.locationManager requestWhenInUseAuthorization];
   
   [self addAnnotation];
}

- (void)loadView {
   GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.tabController.location.coordinate.latitude
                                                           longitude: self.tabController.location.coordinate.longitude
                                                                zoom:11];
   
   self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
   self.mapView.myLocationEnabled = YES;
   self.view = self.mapView;
}

-(void)addAnnotation {
   if (self.tabController.location != nil) {
      GMSMarker * annotation = [[GMSMarker alloc]init];
      annotation.position = self.tabController.location.coordinate;
      annotation.map = self.mapView;
      [self.mapView animateToLocation:CLLocationCoordinate2DMake(self.tabController.location.coordinate.latitude, self.tabController.location.coordinate.longitude)];
   }else {
      [self.locationManager startUpdatingLocation];
   }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
   CLLocation * location = locations.lastObject;
   GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                           longitude: location.coordinate.longitude
                                                                zoom:12];
   
   [self.mapView animateToCameraPosition:camera];
}
@end
