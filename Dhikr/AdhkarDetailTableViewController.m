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
//  AdhkarDetailTableViewController.m
//

#import "AppDelegate.h"
#import "AdhkarDetailTableViewController.h"
#import "AdhkarItemStore.h"
#import "AdhkarItem.h"
#import "CustomDhikrViewController.h"
@import iAd;

NSInteger selectedIndex;

@interface AdhkarDetailTableViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *popupWindow;
@property (weak, nonatomic) IBOutlet UITextField *dhikrEditText;
@property (weak, nonatomic) IBOutlet UITextField *timesEditText;
@property (weak, nonatomic) IBOutlet UITextField *titleEditText;

@end

@implementation AdhkarDetailTableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    AppDelegate* shared=[UIApplication sharedApplication].delegate;
    shared.blockRotation=YES;
    self.navigationItem.title = @"Dhikr Details";
    [[NSBundle mainBundle] loadNibNamed:@"HeaderDetailView" owner:self options:nil];
    [[NSBundle mainBundle] loadNibNamed:@"popupView" owner:self options:nil];
    [self.headerView setAutoresizingMask:UIViewAutoresizingNone];
    [self.tableView setTableHeaderView:self.headerView];
    self.canDisplayBannerAds = YES;
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UIDetailTableViewCell"];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //NSLog(@"Failed to retrieve ad");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.dhikr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UIDetailTableViewCell";
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // if (cell == nil)
    //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.textLabel.text = self.item.dhikr[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.item.times[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
    self.titleEditText.text = self.item.name;
    self.dhikrEditText.text = self.item.dhikr[indexPath.row];
    self.timesEditText.text = [NSString stringWithFormat:@"%@", self.item.times[indexPath.row]];
    selectedIndex = indexPath.row;
    [self.navigationController.view  addSubview:self.popupWindow];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.item.dhikr removeObjectAtIndex:indexPath.row];
        [self.item.times removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *tempDhikr = self.item.dhikr[sourceIndexPath.row];
    NSNumber *tempTimes = self.item.times[sourceIndexPath.row];
    [self.item.dhikr removeObjectAtIndex:sourceIndexPath.row];
    [self.item.dhikr insertObject:tempDhikr atIndex:destinationIndexPath.row];
    [self.item.times removeObjectAtIndex:sourceIndexPath.row];
    [self.item.times insertObject:tempTimes atIndex:destinationIndexPath.row];
}

- (IBAction)editButton:(id)sender {
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (IBAction)newButton:(id)sender {
    [self.item.dhikr addObject:@"new"];
    [self.item.times addObject:[NSNumber numberWithInt:1]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.item.dhikr count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)doDhikr:(id)sender {
    CustomDhikrViewController *detailViewController = [[CustomDhikrViewController alloc] init];
    detailViewController.item = self.item;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)saveEdits:(id)sender {
    self.item.name = self.titleEditText.text;
    self.item.dhikr[selectedIndex] = self.dhikrEditText.text;
    int k = [self.timesEditText.text intValue];
    if (k > 0)
        self.item.times[selectedIndex] = [NSNumber numberWithInt:k];
    else
        self.item.times[selectedIndex] = [NSNumber numberWithInt:0];
    [self.popupWindow removeFromSuperview];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (IBAction)cancelEdits:(id)sender {
    self.titleEditText.text = @"";
    self.dhikrEditText.text = @"";
    self.timesEditText.text = @"";
    [self.popupWindow removeFromSuperview];
}

@end
