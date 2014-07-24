//
//  RTGeoItemAnnotation.m
//  Recruitment Task
//
//  Created by glesiak on 22/07/14.
//

#import "GEOAnnotation.h"
#import "GEOLocation.h"
#import "GEOItem.h"

@interface GEOAnnotation ()

@property (nonatomic,strong) GEOItem * geoItem;

@end

@implementation GEOAnnotation

- (id) initWithGeoItem:(GEOItem *)geoItem
{
    self = [super init];
    if ( self )
    {
        self.geoItem = geoItem;
    }
    return  self;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake( [self.geoItem.location.latitude doubleValue], [self.geoItem.location.longitude doubleValue] );
}

@end
