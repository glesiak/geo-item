//
//  RTGeoLocation.m
//  Recruitment Task
//
//  Created by glesiak on 21/07/14.
//

#import "GEOLocation.h"
#import "GEOItem.h"


@implementation GEOLocation

@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize geoItem = _geoItem;

- (CLLocation *) coreLocation
{
    return [[CLLocation alloc] initWithLatitude: [self.latitude doubleValue]  longitude: [self.longitude doubleValue]];
}

@end
