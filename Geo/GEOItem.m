//
//  RTGeoItem.m
//  Recruitment Task
//
//  Created by glesiak on 21/07/14.
//

#import "GEOItem.h"
#import "GEOLocation.h"
#import "GEOAnnotation.h"

@implementation GEOItem

@synthesize text = _text;
@synthesize image = _image;
@synthesize location = _location;

+ (RKObjectMapping *)mapping
{
    RKObjectMapping * geoItemMapping = [RKObjectMapping mappingForClass: [GEOItem class]];
    [geoItemMapping addAttributeMappingsFromArray: @[ @"text", @"image" ]];
    
    RKObjectMapping * geoLocationMapping = [RKObjectMapping mappingForClass: [GEOLocation class]];
    [geoLocationMapping addAttributeMappingsFromArray: @[ @"latitude", @"longitude" ]];
    
    [geoItemMapping addRelationshipMappingWithSourceKeyPath: @"location" mapping: geoLocationMapping];
    
    return geoItemMapping;
}


- (GEOAnnotation *)annotation
{
    return [[GEOAnnotation alloc] initWithGeoItem: self];
}

@end
