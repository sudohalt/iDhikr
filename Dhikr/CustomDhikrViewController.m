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
//  CustomDhikrViewController.m
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioServices.h>
#import "CustomDhikrViewController.h"
#import "AdhkarItem.h"
@import iAd;

int currentDhikrCount;
int curDhikr;
int totalCycles;

@interface CustomDhikrViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cycleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dhikrLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentDhikr;
@property (weak, nonatomic) IBOutlet ADBannerView *iAdBanner;

@end

@implementation CustomDhikrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* shared=[UIApplication sharedApplication].delegate;
    self.canDisplayBannerAds = YES;
    self.iAdBanner.delegate = self;
    shared.blockRotation=YES;
    self.navigationItem.title =  @"Do Dhikr";
    curDhikr = 0;
    totalCycles = 0;
    currentDhikrCount = 0;
    if (self.item.dhikr.count > 0)
        self.currentDhikr.text = [NSString stringWithFormat:@"%@ %@", self.item.times[curDhikr], self.item.dhikr[curDhikr]];
    // Do any additional setup after loading the view from its nib.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // NSLog(@"Failed to retrieve ad");
    self.iAdBanner.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    currentDhikrCount = 0;
    curDhikr = 0;
    totalCycles = 0;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dhikrButton:(id)sender {
    currentDhikrCount++;
    if (curDhikr >= self.item.dhikr.count) {
        currentDhikrCount = 0;
        self.currentDhikr.text = @"Complete";
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    } else if (((NSNumber *)self.item.times[curDhikr]).intValue <= currentDhikrCount) {
        currentDhikrCount = 0;
        curDhikr++;
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        if (curDhikr >= self.item.dhikr.count) {
            self.currentDhikr.text = @"Complete";
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        } else {
            self.currentDhikr.text = [NSString stringWithFormat:@"%@ %@", self.item.times[curDhikr], self.item.dhikr[curDhikr]];
        }
    }
    self.dhikrLabel.text = [NSString stringWithFormat:@"%d", currentDhikrCount];
}

- (IBAction)repeatAll:(id)sender {
    curDhikr = 0;
    currentDhikrCount = 0;
    totalCycles++;
    if (self.item.dhikr.count > 0) {
        self.currentDhikr.text = [NSString stringWithFormat:@"%@ %@", self.item.times[curDhikr], self.item.dhikr[curDhikr]];
        self.dhikrLabel.text = [NSString stringWithFormat:@"%d", currentDhikrCount];
        self.cycleLabel.text = [NSString stringWithFormat:@"Cycles: %d", totalCycles
                                ];
    }
}

- (IBAction)repeatRecent:(id)sender {
    if (curDhikr <= 0) {
        curDhikr = 0;
    } else {
        curDhikr--;
    }
    currentDhikrCount = 0;
    if (self.item.dhikr.count > 0) {
        self.currentDhikr.text = [NSString stringWithFormat:@"%@ %@", self.item.times[curDhikr], self.item.dhikr[curDhikr]];
        self.dhikrLabel.text = [NSString stringWithFormat:@"%d", currentDhikrCount];
    }
}

@end
