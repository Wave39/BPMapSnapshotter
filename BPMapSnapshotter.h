//
//  BPMapSnapshotter.h
//
//  Created by Brian Prescott on 5/15/14.
//
//

#import <MapKit/MapKit.h>

@interface BPMapSnapshotter : MKMapSnapshotter
{
}

- (void)startWithCompletionHandler:(MKMapSnapshotCompletionHandler)completionHandler;

@end
