//
//  RTViewController.m
//  Recruitment Task
//
//  Created by glesiak on 21/07/14.
//

#import "GEORootViewController.h"
#import "GEOAppDelegate.h"
#import <HTProgressHUD/HTProgressHUD.h>
#import "GEOItem.h"
#import "GEOLocation.h"
#import "GEOAnnotation.h"
#import <WYPopoverController/WYPopoverController.h>
#import "GEOItemViewController.h"

#define RESOURCE_URL @"https://dl.dropboxusercontent.com/u/6556265/test.json"
#define RTGeoItemLoadFailureAlert 100
#define RTAlertButtonCancel 0
#define RTAlertButtonAction 1

@interface GEORootViewController ()

@property (nonatomic,strong) HTProgressHUD * progressHud;
@property (nonatomic,strong) WYPopoverController * annotationPopover;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void) displayGeoItem: (GEOItem*) geoItem;

@end

@implementation GEORootViewController

#pragma mark View Lifecycle Methods

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];

    GEOAnnotation * geoItemAnnotation = [self geoItemAnnotation];
    if ( !geoItemAnnotation )
    {
        [self loadRemoteData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAppearance];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:)
                                                 name: @"ReachabilityUpdate" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

#pragma mark View Controller Helper Methods

- (void) setupAppearance
{
    [WYPopoverController setDefaultTheme: [WYPopoverTheme themeForIOS6]];
}

- (WYPopoverController*) annotationPopover
{
    if ( !_annotationPopover )
    {
        GEOItemViewController * geoItemViewController = [[GEOItemViewController alloc] initWithNibName:nil bundle:nil];
        _annotationPopover = [[WYPopoverController alloc] initWithContentViewController: geoItemViewController];
        _annotationPopover.delegate = self;
    }
    return  _annotationPopover;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController
{
    [self.mapView deselectAnnotation: [self.mapView.selectedAnnotations firstObject]  animated: YES];
}

#pragma mark Geo Item Management

- (void) loadRemoteData
{
    NSURLRequest * dataRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: RESOURCE_URL]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping: [GEOItem mapping]
                                                                                            method: RKRequestMethodAny
                                                                                       pathPattern:nil keyPath:nil statusCodes:nil];
    RKObjectRequestOperation * requestOperation = [[RKObjectRequestOperation alloc] initWithRequest: dataRequest
                                                                                responseDescriptors: @[responseDescriptor]];
    [requestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         DLog( @"geoItem load success" );
         [self displayGeoItem: [mappingResult firstObject]];
     }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         DLog( @"geoItem load failure: %@", error.description );
         UIAlertView * failureAlert = [[UIAlertView alloc] initWithTitle: @"Failure"
                                                                 message: @"Failure retrieving data."
                                                                delegate: self
                                                       cancelButtonTitle: @"Close" otherButtonTitles: @"Retry", nil];
         failureAlert.tag = RTGeoItemLoadFailureAlert;
         [failureAlert show];
     }];
    [requestOperation start];
}

- (void) displayGeoItem: (GEOItem*) geoItem
{
    if ( geoItem )
    {
        [self.mapView addAnnotation: [geoItem annotation]];
        
        CLLocation * geoItemLocation = [geoItem.location coreLocation];
        [self.mapView setRegion: MKCoordinateRegionMake([geoItemLocation coordinate], MKCoordinateSpanMake(7.0, 7.0) )
                       animated: YES];
        
        CLLocation * userLocation = self.mapView.userLocation.location;
        if ( userLocation )
        {
            CLLocationDistance distanceInMeters = [userLocation distanceFromLocation: geoItemLocation];
            NSString * distanceString = [NSString stringWithFormat: @"%.01f km away", (distanceInMeters * 0.001) ];
            self.mapView.userLocation.title = distanceString;
        }
    }
}

- (GEOAnnotation*) geoItemAnnotation
{
    for ( id<MKAnnotation> annotation in self.mapView.annotations )
    {
        if ( [annotation isMemberOfClass: [GEOAnnotation class] ] )
        {
            return annotation;
        }
    }
    return nil;
}

#pragma mark Notification Handlers

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    DLog( @"applicationWillEnterForeground");
    GEOAnnotation * geoItemAnnotation = [self geoItemAnnotation];
    if ( !geoItemAnnotation )
    {
        [self loadRemoteData];
    }
}

- (void) reachabilityChanged: (NSNotification*) notification
{
    BOOL reachabilityStatus = [[notification.userInfo objectForKey: @"status"] integerValue];
    if ( reachabilityStatus==ReachabilityAvailable )
    {
        DLog( @"Reachability changed to online");
        GEOAnnotation * geoItemAnnotation = [self geoItemAnnotation];
        if ( !geoItemAnnotation )
        {
            [self loadRemoteData];
        }
    }
    else if( reachabilityStatus==ReachabilityUnavailable )
    {
        DLog( @"Reachability changed to offline");
    }
}

#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ( alertView.tag )
    {
        case RTGeoItemLoadFailureAlert:
        {
            if ( buttonIndex==RTAlertButtonAction )
            {
                [self performSelector: @selector(loadRemoteData) withObject: nil afterDelay: 1.0];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark MapView Delegate

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ( [view.annotation isMemberOfClass: [GEOAnnotation class]] )
    {
        GEOAnnotation * geoItemAnnotation = (GEOAnnotation*) view.annotation;
        GEOItem * geoItem = geoItemAnnotation.geoItem;
        
        UIViewController * contentViewController = (UIViewController*) self.annotationPopover.contentViewController;
        if ( [contentViewController isMemberOfClass: [GEOItemViewController class]])
        {
            GEOItemViewController * imageViewController = (GEOItemViewController*)contentViewController;
            
            self.annotationPopover.popoverContentSize = CGSizeMake(150, 150);
            [self.annotationPopover presentPopoverFromRect: view.bounds inView: view
                                  permittedArrowDirections: WYPopoverArrowDirectionAny animated: YES];
            
            [imageViewController performSelector: @selector(loadGeoItem:) withObject: geoItem afterDelay: 0];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    GEOAnnotation * geoItemAnnotation = [self geoItemAnnotation];
    if ( geoItemAnnotation )
    {
        GEOItem * geoItem = geoItemAnnotation.geoItem;
        CLLocation * userLocation = self.mapView.userLocation.location;
        if ( userLocation )
        {
            CLLocation * geoItemLocation = [geoItem.location coreLocation];
            CLLocationDistance distanceInMeters = [userLocation distanceFromLocation: geoItemLocation];
            NSString * distanceString = [NSString stringWithFormat: @"%.01f km away", (distanceInMeters * 0.001) ];
            self.mapView.userLocation.title = distanceString;
        }
    }
}

@end
