//
//  RTGeoItemAnnotation.h
//  Recruitment Task
//
//  Created by glesiak on 22/07/14.
//

#import <MapKit/MapKit.h>

@class GEOItem;

@interface GEOAnnotation : MKPointAnnotation

@property (nonatomic,readonly,strong) GEOItem * geoItem;

- (id) initWithGeoItem: (GEOItem*) geoItem;

@end
