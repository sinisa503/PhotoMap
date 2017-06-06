//
//  MainVC.m
//  PhotoMap
//
//  Created by Sinisa Vukovic on 04/06/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

#import "MainVC.h"
#import "CustomCell.h"
#import "PhotoInfo.h"
#import "InfoVc.h"

@interface MainVC ()  <PHPhotoLibraryChangeObserver, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) PHFetchResult<PHAsset *> * allPhotos;
@property (nonnull, strong) PHImageManager * imageManager;
@property PHImageRequestOptions * requestOptions;
@property int selectedImageNumber;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
   self.requestOptions = [[PHImageRequestOptions alloc] init];
   self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
   self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
   
   self.imageManager = [PHImageManager defaultManager];

   self.collectionView.delegate = self;
   PHFetchOptions * allPhotosOptions = [[PHFetchOptions alloc] init];
   NSSortDescriptor *creationDate = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
   allPhotosOptions.sortDescriptors = @[creationDate];
   self.allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
   
   [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
}

-(void)dealloc {
   [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([segue.destinationViewController isKindOfClass:[InfoVc class]]) {
      InfoVc *infoVC = (InfoVc *)segue.destinationViewController;
      PHAsset *asset = [self.allPhotos objectAtIndex:self.selectedImageNumber];
      infoVC.asset = asset;
   }
}

-(void)photoLibraryDidChange:(PHChange *)changeInstance {
   dispatch_sync(dispatch_get_main_queue(), ^{
      PHFetchResultChangeDetails<PHAsset *> * changeDetails = [changeInstance changeDetailsForObject:self.allPhotos];
      self.allPhotos = [changeDetails fetchResultAfterChanges];
   });
}

//MARK: CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   int photoNumber = self.allPhotos.count;
   return photoNumber;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   CustomCell * customCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
   
   [self.imageManager requestImageForAsset:[self.allPhotos objectAtIndex:indexPath.item] targetSize:customCell.bounds.size contentMode:PHImageContentModeAspectFill options:self.requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
      customCell.imageView.image = result;
   }];
   
   return customCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   self.selectedImageNumber = indexPath.item;
   [self performSegueWithIdentifier:@"showInfo" sender:self];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   CGFloat height = collectionView.bounds.size.height / 5;
   CGFloat width = (collectionView.bounds.size.width - 24) / 3;
   return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
   
   return UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   CGFloat spaceing = 4.0;
   return spaceing;
}

@end
