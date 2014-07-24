//
//  RTGeoLocation.h
//  Recruitment Task
//
//  Created by glesiak on 21/07/14.
//

#import <Foundation/Foundation.h>

@class GEOItem;

@interface GEOLocation : NSObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) GEOItem *geoItem;

- (CLLocation *) coreLocation;

@end
