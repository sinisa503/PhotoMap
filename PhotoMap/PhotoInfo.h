//
//  PhotoInfo.h
//  PhotoMap
//
//  Created by Sinisa Vukovic on 05/06/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoInfo : NSObject

@property (nonatomic, strong) NSDate * creationDate;
@property (nonatomic, strong) NSDate * modificationDate;
@property (nonatomic, strong) NSString * resolution;
@property BOOL isFavourite;

@end
