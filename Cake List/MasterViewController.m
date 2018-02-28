//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
#import "CakeCell.h"

@interface MasterViewController()

@property (strong, nonatomic) NSArray *objects;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.estimatedRowHeight = 60;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	// Uncomment for debugging or if caching behaviour will need to change.
	// [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self getData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Assuming the cell identifier == class name
	NSString *cellIdentifier = NSStringFromClass([CakeCell class]);
    CakeCell *cell = (CakeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier
																 forIndexPath:indexPath];
    
    NSDictionary *object = self.objects[indexPath.row];
    cell.titleLabel.text = object[@"title"];
    cell.descriptionLabel.text = object[@"desc"];
	[cell presentCakeImageForURL:[NSURL URLWithString:object[@"image"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	if ([cell isKindOfClass:[CakeCell class]]) {
		[(CakeCell *)cell stopPresentingCakeImage];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getData {
    NSURL *url = [NSURL URLWithString:@"https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json"];

	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSData *data = [NSData dataWithContentsOfURL:url];
		NSError *jsonError;
		id responseData = [NSJSONSerialization JSONObjectWithData:data
														  options:kNilOptions
															error:&jsonError];
		if (!jsonError && responseData != nil){
			dispatch_async(dispatch_get_main_queue(), ^{
				self.objects = responseData;
				[self.tableView reloadData];
			});
		}
	});
}

@end
