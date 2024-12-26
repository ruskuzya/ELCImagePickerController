//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ELCConsole.h"
#import <Photos/Photos.h>

@implementation ELCImagePickerController

//Using auto synthesizers

- (id)initImagePicker
{
    ELCAlbumPickerController *albumPicker = [[ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    
    self = [super initWithRootViewController:albumPicker];
    if (self) {
        self.maximumImagesCount = 4;
        self.returnsImage = YES;
        self.returnsOriginalImage = YES;
        [albumPicker setParent:self];
        self.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
//        UIBarButtonItem *backButton = [UIBA];
        [self.navigationItem.backBarButtonItem setTitle:@"Назад"];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{

    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.maximumImagesCount = 4;
        self.returnsImage = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
}

- (ELCAlbumPickerController *)albumPicker
{
    return self.viewControllers[0];
}

- (void)setMediaTypes:(NSArray *)mediaTypes
{
    self.albumPicker.mediaTypes = mediaTypes;
}

- (NSArray *)mediaTypes
{
    return self.albumPicker.mediaTypes;
}

- (void)cancelImagePicker
{
	if ([_imagePickerDelegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[_imagePickerDelegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    BOOL shouldSelect = previousCount < self.maximumImagesCount;
    if (!shouldSelect) {
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Не более %ld фото!", nil), (long)self.maximumImagesCount];
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Вы можете выбрать не более %ld фото.", nil), (long)self.maximumImagesCount];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertActionStyleDefault];
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Хорошо", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:controller animated:YES completion:nil];
    }
    return shouldSelect;
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount;
{
    return YES;
}

- (void)selectedAssets:(NSArray *)assets
{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	
	for(ELCAsset *elcasset in assets) {
        PHAsset *asset = elcasset.asset;
        
		NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
        
        [workingDictionary setObject:@(asset.mediaType) forKey:UIImagePickerControllerMediaType];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        if (@available(iOS 17, *)) {
            options.allowSecondaryDegradedImage = NO;
        } else {
            // Fallback on earlier versions
        }
        
        [PHImageManager.defaultManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *result = [UIImage imageWithData:imageData];
            elcasset.image = result;
            elcasset.imageDownloaded = YES;
            
            if(elcasset.image != nil) {
                [workingDictionary setObject:elcasset.image forKey:UIImagePickerControllerOriginalImage];
                [returnArray addObject:workingDictionary];
            }
            
            BOOL allImages = YES;
            for(ELCAsset *asset in assets) {
                if(!asset.imageDownloaded) {
                    allImages = NO;
                }
            }
            
            if(allImages) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (_imagePickerDelegate != nil && [_imagePickerDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
                        [_imagePickerDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:returnArray];
                    } else {
                        [self popToRootViewControllerAnimated:NO];
                    }
                }];
            }
        }];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

- (BOOL)onOrder
{
    return [[ELCConsole mainConsole] onOrder];
}

- (void)setOnOrder:(BOOL)onOrder
{
    [[ELCConsole mainConsole] setOnOrder:onOrder];
}

@end
