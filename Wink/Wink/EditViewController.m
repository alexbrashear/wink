//
//  EditViewController.m
//  Wink
//
//  Created by Alex Brashear on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "EditViewController.h"
#import <Parse/Parse.h>
@interface EditViewController ()
@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retrievePic];
}

-(void)retrievePic{
    PFQuery *picQuery = [PFUser query];
    [picQuery whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    [picQuery getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error)
     {
         if (!error){
             NSLog(@"no error 1");
             PFFile *userImageFile = user[@"profPic"];
             [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                 if (!error){
                     NSLog(@"no error 2");
                     [self setupPic:[UIImage imageWithData:imageData]];
                 }
                 else
                     NSLog(@"Error: %@", error.description);
                 
             }];
         }
         
         else
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         
     }];
}

-(void)setupPic:(UIImage *)pic{
    self.profileImageView.image = pic;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.cornerRadius = 10.0f;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
