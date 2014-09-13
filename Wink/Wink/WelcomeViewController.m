//
//  ViewController.m
//  Wink
//
//  Created by Connor on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "WelcomeViewController.h"
#import <SVProgressHUD.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)connect:(id)sender {
    [SVProgressHUD showWithStatus:@"Retrieving FB Info"];
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"email"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self getUserInfo];
        } else {
            NSLog(@"User with facebook logged in!");
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:@"toMain" sender:self];
        }
    }];

}

-(void)getUserInfo{
    NSString *requestPath = @"me/?fields=name,location,gender,birthday,relationship_status,picture,email,id";
    
    FBRequest *request = [[FBRequest alloc] initWithSession:[PFFacebookUtils session] graphPath:requestPath];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
            
            NSString *name = [userData objectForKey:@"name"];
            NSString *email = [userData objectForKey:@"email"];
            NSString *sID = [userData objectForKey:@"id"];
            // get the FB user's profile image
            NSDictionary *dicFacebookPicture = [userData objectForKey:@"picture"];
            NSDictionary *dicFacebookData = [dicFacebookPicture objectForKey:@"data"];
            
            NSString *sUrlPic= [dicFacebookData objectForKey:@"url"];
            /*
            UIImage* imgProfile = [UIImage imageWithData:
                                   [NSData dataWithContentsOfURL:
                                    [NSURL URLWithString: sUrlPic]]];
            */
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            NSURLRequest *urlrequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:sUrlPic]];
            [NSURLConnection sendAsynchronousRequest:urlrequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                /*
                UIImage * imgProfile = [UIImage imageWithData:
                                       [NSData dataWithContentsOfURL:
                                        [NSURL URLWithString: sUrlPic]]];
                 */
                [self savePicToParse:data];
                
            }];
            
            PFUser *user = [PFUser currentUser];
            user.email = email;
            [user setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"UUID"];
            [user setObject:name forKey:@"name"];
            [user setObject:sID forKey:@"fbID"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [SVProgressHUD dismiss];
                    [self performSegueWithIdentifier:@"toMain" sender:self];
                } else {
                    [SVProgressHUD dismiss];
                    NSLog(@"fml: %@", error);
                }
            }];
            
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation setObject:[PFUser currentUser].objectId forKey:@"userId"];
            [currentInstallation saveInBackground];
            
            // now request FB friend list
            FBRequest *request = [[FBRequest alloc] initWithSession:[PFFacebookUtils session] graphPath:@"me/friends"];
            
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSArray *data = [result objectForKey:@"data"];
                    
                    if (data) {
                        //we now have an array of NSDictionary entries containing friend data
                        for (NSMutableDictionary *friendData in data) {
                            // do something interesting with the friend data...
                            NSLog(@"friendData: %@", friendData);
                        }
                    }
                    
                }
            }];
        }
        else{
            NSLog(@"what the fuck is the problem... %@", error.description);
        }
    }];
    
}

-(void)savePicToParse:(NSData *)picData{
    PFFile *pic = [PFFile fileWithData:picData];
    PFUser *user = [PFUser currentUser];
    [user setObject:pic forKey:@"profPic"];
    [user saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
