//
//  FirstViewController.m
//  PhotoMap
//
//  Created by Sinisa Vukovic on 31/05/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

#import "AppleMapVc.h"
#import "CustomTabController.h"


@interface AppleMapVc ()
@property (nonatomic, strong) MKMapView * map;
@property (nonatomic, strong) CustomTabController *tabController;
@end

@implementation AppleMapVc

- (void)viewDidLoad {
   [super viewDidLoad];
   self.tabController =  (CustomTabController *)self.tabBarController;
   [self makeMapView];
   [self addAnnotation];
}


-(void)makeMapView {
   self.map = [[MKMapView alloc] initWithFrame:[self.view bounds]];
   self.map.delegate = self;
   
   [self.view addSubview:self.map];
   [self.view bringSubviewToFront:self.map];
   
   self.map.translatesAutoresizingMaskIntoConstraints = false;
   NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.map attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
   NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.map attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
   NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.map attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
   NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.map attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
   
   [self.view addConstraints:@[topConstraint, bottomConstraint, trailingConstraint, leadingConstraint]];
   
   [self.map setShowsUserLocation:YES];
}

-(void)addAnnotation {
   if (self.tabController.location != nil) {
      CustomTabController * tabController =  (CustomTabController *)self.tabBarController;
      MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
      annotation.coordinate = tabController.location.coordinate;
      [self.map addAnnotation:annotation];
      
      [self.map setRegion: MKCoordinateRegionMake(self.tabController.location.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
   }
}


@end
