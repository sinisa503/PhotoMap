//
//  CustomTabController.h
//  PhotoMap
//
//  Created by Sinisa Vukovic on 05/06/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@import CoreLocation;

@interface CustomTabController : UITabBarController
@property (nonatomic, strong) CLLocation * location;
@end
