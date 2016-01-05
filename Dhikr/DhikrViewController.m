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
//  DhikrViewController.m
//

#import "AppDelegate.h"
#import "DhikrViewController.h"
#import <AudioToolbox/AudioServices.h>
@import iAd;

int dhikrCount;
int cycleCount;

@interface DhikrViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dhikrLabel;
@property (retain, nonatomic) IBOutlet UILabel *keyboardLabel;
@property (weak, nonatomic) IBOutlet UIButton *dhikrButton;
@property (retain, nonatomic) IBOutlet UITextField *resetAt;
@property (weak, nonatomic) IBOutlet UILabel *keyboardDetails;
@property (weak, nonatomic) IBOutlet ADBannerView *iAdBanner;
@property (weak, nonatomic) IBOutlet UILabel *cycleLabel;

@end

@implementation DhikrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cycleCount = 0;
    dhikrCount = 0;
    AppDelegate* shared=[UIApplication sharedApplication].delegate;
    shared.blockRotation=YES;
    self.canDisplayBannerAds = YES;
    self.iAdBanner.delegate = self;
    self.navigationItem.title = @"General Dhikr";
    // Do any additional setup after loading the view, typically from a nib.
    self.resetAt.delegate = self;
    self.dhikrButton.hidden = false;
    self.dhikrLabel.hidden = false;
    self.cycleLabel.hidden = false;
    self.keyboardLabel.hidden = true;
    self.keyboardDetails.hidden = true;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [self.resetAt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //NSLog(@"Failed to retrieve ad");
    self.iAdBanner.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    dhikrCount = 0;
    cycleCount = 0;
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
    dhikrCount++;
    int resetValue = [self.resetAt.text intValue];
    if (dhikrCount >= resetValue) {
        dhikrCount = 0;
        cycleCount++;
        self.cycleLabel.text = [NSString stringWithFormat:@"Cycles: %d", cycleCount];
        self.dhikrLabel.text = [NSString stringWithFormat:@"0"];
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }else {
        self.dhikrLabel.text = [NSString stringWithFormat:@"%d", dhikrCount];
    }
}

- (IBAction)resetButton:(id)sender {
    dhikrCount = 0;
    cycleCount = 0;
    self.dhikrLabel.text = @"0";
    self.cycleLabel.text = @"Cycles: 0";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //self.keyboardLabel.text = self.resetAt.text;
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    self.keyboardLabel.text = self.resetAt.text;

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES]; //YES ignores any textfield refusal to resign
}

- (void)keyboardDidShow: (NSNotification *) notif{
    self.dhikrButton.hidden = true;
    self.dhikrLabel.hidden = true;
    self.cycleLabel.hidden = true;
    self.keyboardLabel.hidden = false;
    self.keyboardDetails.hidden = false;
    self.keyboardLabel.text = self.resetAt.text;

}

- (void)keyboardDidHide: (NSNotification *) notif{
    self.keyboardLabel.hidden = true;
    self.keyboardDetails.hidden = true;
    self.dhikrButton.hidden = false;
    self.dhikrLabel.hidden = false;
    self.cycleLabel.hidden = false;
}
@end
