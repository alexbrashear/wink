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
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retrievePicBetter];
    // [self retrievePic];
}
-(void)savePicToParse:(NSData *)picData{
    PFFile *pic = [PFFile fileWithData:picData];
    PFUser *user = [PFUser currentUser];
    [user setObject:pic forKey:@"profPic"];
    [user saveInBackground];
    [self setupPic:[UIImage imageWithData:picData]];
}
- (void)retrievePicBetter {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:@"fbID"]]];
    NSURLRequest *urlrequest = [[NSURLRequest alloc] initWithURL:profilePictureURL];
    [NSURLConnection sendAsynchronousRequest:urlrequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [self savePicToParse:data];
    }];

}
- (void)retrievePic{
    PFQuery *picQuery = [PFUser query];
    [picQuery whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    [picQuery getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error)
     {
         if (!error){
             PFFile *userImageFile = user[@"profPic"];
             [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                 if (!error)
                     [self setupPic:[UIImage imageWithData:imageData]];
                 
                 else
                     NSLog(@"Error: %@", error.description);
                 
             }];
         }
         
         else
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         
     }];
}

-(void)setupPic:(UIImage *)pic{
    NSLog(@"pic: %@", pic);
    self.profileImageView.image = pic;
    self.profileImageView.layer.borderWidth = 1.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.cornerRadius = 50.0f;
    [self.profileImageView setNeedsLayout];
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
