//
//  InfoVc.m
//  PhotoMap
//
//  Created by Sinisa Vukovic on 05/06/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

#import "InfoVc.h"
#import "AppleMapVc.h"
#import "GoogleMapVC.h"
#import "CustomTabController.h"

@interface InfoVc ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *resolutionLabel;
@property (weak, nonatomic) IBOutlet UILabel *modificationDateLabel;

@property (nonnull, strong) PHImageManager * imageManager;
@property (nonatomic, strong) CLLocation * location;
@end

@implementation InfoVc

-(void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   
   self.imageManager = [PHImageManager defaultManager];
   [self setUpView];
}


-(void)setUpView {
   PHImageRequestOptions * requestOptions = [[PHImageRequestOptions alloc] init];
   requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
   requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
   if (self.asset != nil) {
      [self.imageManager requestImageForAsset:self.asset targetSize:self.imageView.bounds.size contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
         self.imageView.image = result;
      }];
   }
   PhotoInfo * info = [self getInfoFor:self.asset];
   self.resolutionLabel.text = info.resolution;
   
   
   self.modificationDateLabel.text =  [self format:info.modificationDate];
   self.dateCreatedLabel.text = [self format:info.creationDate];
}

- (IBAction)goToMaps:(UIBarButtonItem *)sender {
   CustomTabController * tabController = [[CustomTabController alloc]init];
   if (self.location != nil) {
      tabController.location = self.location;
   }
   AppleMapVc * appleMapVC = [[AppleMapVc alloc]init];
   GoogleMapVC * googleMapVc = [[GoogleMapVC alloc]init];
   
   appleMapVC.title = NSLocalizedString(@"Apple Map", @"Apple Map");
   googleMapVc.title = NSLocalizedString(@"Google Map", @"Google Map");
   
   
   tabController.viewControllers = [NSArray arrayWithObjects:appleMapVC, googleMapVc, nil];
   
   appleMapVC.tabBarItem.image = [UIImage imageNamed:@"first"];
   googleMapVc.tabBarItem.image = [UIImage imageNamed:@"second"];
   
   [self.navigationController showViewController:tabController sender:self];
}


-(PhotoInfo *)getInfoFor: (PHAsset *) obj{
   PHImageRequestOptions * requestOptions = [[PHImageRequestOptions alloc] init];
   requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
   requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
   
   PhotoInfo *photoInfo = [[PhotoInfo alloc] init];
   
   if (obj.creationDate != nil) {
      photoInfo.creationDate = obj.creationDate;
   }
   if (obj.modificationDate != nil) {
      photoInfo.modificationDate = obj.modificationDate;
   }
   if (obj.pixelWidth != nil && obj.pixelHeight != nil) {
      photoInfo.resolution = [NSString stringWithFormat:@"%lux%lu",(unsigned long)obj.pixelWidth, obj.pixelHeight];
   }
   if (obj.favorite != nil) {
      photoInfo.isFavourite = obj.isFavorite;
   }
   if (obj.location != nil) {
      [self reverseGeocode:obj.location];
      self.location = obj.location;
   }
   return photoInfo;
}

-(void)reverseGeocode:(CLLocation *)location {
   CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
   [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
      if (placemarks && placemarks.count > 0) {
         CLPlacemark *placemark = placemarks.firstObject;
         NSDictionary *addressDictionary = placemark.addressDictionary;
         NSString *country = [addressDictionary objectForKey:@"CountryCode"];
         NSString *address = [addressDictionary objectForKey:@"Street"];
         NSLog([NSString stringWithFormat:@"%@, %@", country, address]);
         if (address && country) {
            self.addressLabel.text = [NSString stringWithFormat:@"%@, %@", country, address];
         }
      }
   }];
}

-(NSString *)format:(NSDate *)date {
   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   formatter.dateFormat = @"MM/dd/yyyy  HH:mm";
   NSString *newDate = [formatter stringFromDate:date];
   NSLog(@"Date Current :- %@",newDate);
   return newDate;
}
@end
