//
//  AlbumPickerController.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ELCAssetSelectionDelegate.h"
#import "ELCAssetPickerFilterDelegate.h"

@interface ELCAlbumPickerController : UITableViewController <ELCAssetSelectionDelegate, PHPhotoLibraryChangeObserver>

@property (nonatomic, weak) id<ELCAssetSelectionDelegate> parent;
@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, strong) NSArray *mediaTypes;

// optional, can be used to filter the assets displayed
@property (nonatomic, weak) id<ELCAssetPickerFilterDelegate> assetPickerFilterDelegate;

@end

