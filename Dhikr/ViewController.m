/*  The MIT License (MIT)
 *
 *  Copyright (c) 2015 Umayah Abdennabi
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

//
//  ViewController.m
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DhikrViewController.h"
#import "AdhkarTableViewController.h"
@import iAd;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ADBannerView *iAdBanner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* shared=[UIApplication sharedApplication].delegate;
    shared.blockRotation=YES;
    self.canDisplayBannerAds = YES;
    self.iAdBanner.delegate = self;
    self.navigationController.navigationBar.topItem.title = @"Home";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{

}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
   // NSLog(@"Failed to retrieve ad");
    self.iAdBanner.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startDhikr:(id)sender {
   // DhikrViewController *detailViewController =[[DhikrViewController alloc] init];
    DhikrViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DhikrViewController"];
    // Push the view onto the stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (IBAction)gotoAdhkar:(id)sender {
    AdhkarTableViewController *detailViewController =[[AdhkarTableViewController alloc] init];
    // Push the view onto the stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (IBAction)gotoInfo:(id)sender {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait);
}



@end
