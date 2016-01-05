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
//  UITableViewController+Adhkar.m
//
#import "AppDelegate.h"
#import "AdhkarTableViewController.h"
#import "AdhkarItemStore.h"
#import "AdhkarItem.h"
#import "AdhkarDetailTableViewController.h"
#import "ViewController.h"
@import iAd;

@interface AdhkarTableViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerVIew;

@end

@implementation AdhkarTableViewController


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[AdhkarItemStore sharedStore] allItems] count];
}

- (UIView *) headerVIew {
    if (!_headerVIew) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerVIew;
}

- (void) fakeAdd {
    for (int i = 0; i < 10; i++) {
        [[AdhkarItemStore sharedStore] createItem:@"After Salat" dhikr:[[NSMutableArray alloc] initWithArray:@[@"subhanallah", @"alhamdulillah", @"allahuakbar"]] times:[[NSMutableArray alloc] initWithArray:@[[NSNumber numberWithInt:33], [NSNumber numberWithInt:33], [NSNumber numberWithInt:33]]]];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    AppDelegate* shared=[UIApplication sharedApplication].delegate;
    self.canDisplayBannerAds = YES;
    shared.blockRotation=YES;
    self.navigationItem.title = @"Library";
    UIView *headerView = self.headerVIew;
    [self.tableView setTableHeaderView:headerView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // to reload selected cell
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait);
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSArray *items = [[AdhkarItemStore sharedStore] allItems];
    AdhkarItem *item = items[indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[AdhkarItemStore sharedStore] allItems];
        AdhkarItem *item = items[indexPath.row];
        [[AdhkarItemStore sharedStore] removeItem:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[AdhkarItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

/* Keeping for reference no how to do this
- (IBAction)gotoMain:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:initViewController animated:YES];
    [self.navigationController setNavigationBarHidden:YES];

}
*/

- (IBAction)toggleEditingMode:(id)sender {
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AdhkarDetailTableViewController *detailViewController =[[AdhkarDetailTableViewController alloc] init];
    NSArray *items = [[AdhkarItemStore sharedStore] allItems];
    AdhkarItem *selectedItem = items[indexPath.row];
    detailViewController.item = selectedItem;
    // Push the view onto the stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (IBAction)addNewItem:(id)sender {
    AdhkarItem *newItem = [[AdhkarItemStore sharedStore] createItem:@"new dhikr" dhikr:[[NSMutableArray alloc] initWithArray:@[@"new"]] times:[[NSMutableArray alloc] initWithArray:@[[NSNumber numberWithInt:1]]]];
    // Figure out where that item is in the array
    NSInteger lastRow = [[[AdhkarItemStore sharedStore] allItems] indexOfObject:newItem];
    [[AdhkarItemStore sharedStore] moveItemAtIndex:lastRow toIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

@end
