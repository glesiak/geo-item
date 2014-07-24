//
//  RTImageViewController.m
//  Recruitment Task
//
//  Created by glesiak on 22/07/14.
//

#import "GEOItemViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <HTProgressHUD/HTProgressHUD.h>
#import <HTProgressHUD/HTProgressHUDIndicatorView.h>

@interface GEOItemViewController ()

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * textLabel;
@property (nonatomic,strong) HTProgressHUD * progressHud;

@end

@implementation GEOItemViewController

#pragma mark View Controller Lifecycle

- (void) loadView
{
    UIView * rootView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    rootView.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 100, 80)];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.backgroundColor = [UIColor whiteColor];
    [rootView addSubview: self.imageView];
    
    self.textLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 80, 100, 20)];
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.textLabel.font = [UIFont systemFontOfSize: 14.0];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor darkTextColor];
    self.textLabel.backgroundColor = [UIColor colorWithRed: 0.95 green:0.95 blue:0.95 alpha: 1.0];
    [rootView addSubview: self.textLabel];
    
    self.view = rootView;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [self cleanInterface];
}

#pragma mark Geo Item Management

- (void)loadGeoItem: (GEOItem*) geoItem;
{
    self.textLabel.text = geoItem.text;
    [self.progressHud showInView: self.view];
    
    __weak GEOItemViewController * weakSelf = self;
    [self.imageView setImageWithURLRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: geoItem.image]]
                          placeholderImage: [self placeholderImage]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       [weakSelf.progressHud hide];
                                       weakSelf.imageView.image = image;
                                       [weakSelf.imageView setNeedsDisplay];
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       DLog( @"failed to load image with error: %@", error );
                                       weakSelf.progressHud.indicatorView.hidden = YES;
                                       weakSelf.progressHud.text = @"Error loading image";
                                   }];
}

#pragma mark Helper Methods

- (void) cleanInterface
{
    self.imageView.image = [self placeholderImage];
    self.textLabel.text = @"";
    self.progressHud.text = @"";
    self.progressHud.indicatorView.hidden = NO;
}

- (UIImage*) placeholderImage
{
    CGRect rect = self.imageView.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark Custom getters and setters

- (HTProgressHUD *)progressHud
{
    if ( !_progressHud )
    {
        _progressHud = [[HTProgressHUD alloc] init];
    }
    return  _progressHud;
}


@end
