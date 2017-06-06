//
//  InfoVc.h
//  PhotoMap
//
//  Created by Sinisa Vukovic on 05/06/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"
@import Photos;

@interface InfoVc : UIViewController
@property (nonatomic, strong) PHAsset * asset;
@end
