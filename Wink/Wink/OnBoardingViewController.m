//
//  OnBoardingViewController.m
//  Wink
//
//  Created by Alex Brashear on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "OnBoardingViewController.h"
#import "PageContentViewController.h"
#import "WWinkViewController.h"
#import "EditViewController.h"
#import "ChatTableViewController.h"

@interface OnBoardingViewController ()

@end

@implementation OnBoardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the data model
    _pageTitles = @[@"edit", @"wink", @"chat"];
    
    _pageViewControllers = @[];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    /*
     if (index == -1)
     [self togglePageControl:YES];
     else
     [self togglePageControl:NO];
     */
    // Create a new view controller and pass suitable data.
    PSPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((PSPageContentViewController*) viewController).pageIndex;
    self.pageControl.currentPage = index;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PSPageContentViewController*) viewController).pageIndex;
    self.pageControl.currentPage = index;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
}
/*
 - (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
 {
 return [self.pageTitles count];
 }
 
 - (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
 {
 return 0;
 }
 */

@end
