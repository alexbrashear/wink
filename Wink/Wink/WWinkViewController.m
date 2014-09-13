//
//  WWinkViewController.m
//  Wink
//
//  Created by Connor on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "WWinkViewController.h"
#import <Parse/Parse.h>
#import <SVProgressHUD.h>
@implementation WWinkViewController

-(void)viewDidLoad{
    
}

- (IBAction)wink:(id)sender {
    [SVProgressHUD showWithStatus:@"Winking!"];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            PFUser *user = [PFUser currentUser];
            user[@"location"] = geoPoint;
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                //Find anyone else near their location using the app
                [self findNearbyPeople:geoPoint];
            }];
        }
        else{
            [SVProgressHUD dismiss];
            NSLog(@"Error: %@", error.description);
        }
    }];
}

-(void)findNearbyPeople:(PFGeoPoint *)geoPoint{
    // User's location
    PFGeoPoint *userGeoPoint = geoPoint;
    // Create a query for places
    PFQuery *locationQuery = [PFUser query];
    // Interested in people near user.
    [locationQuery whereKey:@"location" nearGeoPoint:userGeoPoint];
    // Limit what could be a lot of points.
    locationQuery.limit = 5;
    [locationQuery findObjectsInBackgroundWithBlock:^(NSArray *userArray, NSError *error)
     {
         if (!error){
             NSMutableArray *potentialMatches = [[NSMutableArray alloc] init];
             for (PFObject *user in userArray)
                 [potentialMatches addObject:user.objectId];
             PFUser *user = [PFUser currentUser];
             user[@"potentialMatches"] = potentialMatches;
         }
    
         else
             NSLog(@"Error: %@", error.description);
         
     }];
    
}
@end
