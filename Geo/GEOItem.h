//
//  RTGeoItem.h
//  Recruitment Task
//
//  Created by glesiak on 21/07/14.
//

#import <Foundation/Foundation.h>

@class GEOAnnotation;
@class GEOLocation;

@interface GEOItem : NSObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) GEOLocation *location;

+ (RKObjectMapping*) mapping;
- (GEOAnnotation*) annotation;

@end
