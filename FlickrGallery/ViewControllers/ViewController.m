//
//  ViewController.m
//  FlickrGallery
//
//  Created by Aman Agarwal on 02/06/19.
//  Copyright © 2019 Practice. All rights reserved.
//

#import "ViewController.h"
#import "GalleryViewManager.h"
#import "GalleryPhotoCell.h"

#define NoOfColoumns 3
#define DefaultCellHeight 200

@interface ViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GalleryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) SearchObjectModel *model;
@property (strong, nonatomic) GalleryViewManager *manager;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIView *overlayView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self customSetup];
}

- (void)customSetup {
    self.textField.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.manager = [[GalleryViewManager alloc] init];
    self.manager.delegate = self;
}

 // If user clicks outside search bar
// dismiss keybpard and perform search
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)startSpinner {
    if(!self.spinner) {
        self.collectionView.scrollEnabled = NO;
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.spinner.frame = CGRectMake(0, 0, 24, 24);
        self.spinner.hidesWhenStopped = true;
        self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.overlayView setAlpha:0.4];
        [self.overlayView setBackgroundColor:[UIColor grayColor]];
        [self.overlayView addSubview:self.spinner];
        [self.view addSubview:self.overlayView];
        CGRect frame = self.spinner.frame;
        frame.origin.x = (self.view.frame.size.width / 2) - 12;//subtracting half the size of spinner width
        frame.origin.y = (self.view.frame.size.height / 2) - 12;//subtracting half the size of spinner height
        self.spinner.frame = frame;
        [self.spinner startAnimating];
    }
}

- (void)stopSpinner {
    self.collectionView.scrollEnabled = YES;
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = DefaultCellHeight;
    CGFloat width = (collectionView.frame.size.width-40)/NoOfColoumns;//40 for padding
    
    return CGSizeMake(width, height);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.photosList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    [self.manager updateImageForModel:[self.model.photosList objectAtIndex:indexPath.row] onImageView:cell.imageView];
    
     //If user is at second last row
    //Add spiner on view and fetch new data
    if(indexPath.row + NoOfColoumns >= self.model.photosList.count) {
        [self startSpinner];
        [self.manager fetchDataForScroll:self.model];
    }
    return cell;
}

#pragma mark - UITextFeildDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(![textField.text isEqualToString:self.model.keyword]) {
        [self.collectionView setContentOffset:CGPointZero animated:NO];
        [self startSpinner];
        [self.manager fetchDataForKeyword:textField.text withSearchModel:self.model];
    }
}

#pragma mark - GalleryManagerDelegate

- (void)didUpdateDataModel:(SearchObjectModel *)model withError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopSpinner];
        if(error) {
            NSLog(@"Error Domain : %@ with code : %ld",error.domain,(long)error.code);
        } else {
            self.model = model;
            [self.collectionView reloadData];
        }
    });
}

@end
