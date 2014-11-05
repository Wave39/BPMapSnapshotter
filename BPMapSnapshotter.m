//
//  BPMapSnapshotter.m
//
//  Created by Brian Prescott on 5/15/14.
//
//

#import "BPMapSnapshotter.h"

@interface BPMapSnapshotter ()

@property (nonatomic, strong) NSString *optionsString;

@end

@implementation BPMapSnapshotter

+ (NSCache *)snapshotCache
{
    static NSCache *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [NSCache new];
    });
    
    return sharedInstance;
}

- (id)initWithOptions:(MKMapSnapshotOptions *)options
{
    self = [super initWithOptions:options];
    if (self)
    {
        _optionsString = [NSString stringWithFormat:@"%f %f %f %f %f | %@ | %f %f %f %f | %d",
                          options.camera.centerCoordinate.latitude, options.camera.centerCoordinate.longitude,
                          options.camera.heading, options.camera.pitch, options.camera.altitude,
                          MKStringFromMapRect(options.mapRect),
                          options.region.center.latitude, options.region.center.longitude,
                          options.region.span.latitudeDelta, options.region.span.longitudeDelta,
                          (int)options.mapType];
    }
    
    return self;
}

- (void)startWithCompletionHandler:(MKMapSnapshotCompletionHandler)completionHandler
{
    MKMapSnapshot *cachedObject = [[BPMapSnapshotter snapshotCache] objectForKey:_optionsString];
    if (cachedObject != nil)
    {
        completionHandler(cachedObject, nil);
        return;
    }
    
    [super startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        if (error)
        {
            completionHandler(nil, error);
        }
        else
        {
            [[BPMapSnapshotter snapshotCache] setObject:snapshot forKey:_optionsString];
            completionHandler(snapshot, nil);
        }
    }];
}

@end
