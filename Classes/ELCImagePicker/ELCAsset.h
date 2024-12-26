//
//  Asset.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class ELCAsset;

@protocol ELCAssetDelegate <NSObject>

@optional
- (void)assetSelected:(ELCAsset *)asset;
- (BOOL)shouldSelectAsset:(ELCAsset *)asset;
- (void)assetDeselected:(ELCAsset *)asset;
- (BOOL)shouldDeselectAsset:(ELCAsset *)asset;
@end


@interface ELCAsset : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<ELCAssetDelegate> parent;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic,assign) int index;
@property (nonatomic) BOOL imageDownloaded;

- (id)initWithAsset:(PHAsset *)asset;
- (NSComparisonResult)compareWithIndex:(ELCAsset *)_ass;

@end
