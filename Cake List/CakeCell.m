//
//  CakeCell.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "CakeCell.h"

@interface CakeCell()

@property (strong, nonatomic) NSURLSessionDataTask *task;

@end

@implementation CakeCell

- (void)presentCakeImageWithData:(NSData *)data {
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		UIImage *image = [UIImage imageWithData:data];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.cakeImageView setImage:image];
		});
	});
}

- (void)presentCakeImageForURL:(NSURL *)cakeURL {
	[self stopPresentingCakeImage];
	if (cakeURL == nil) {
		return;
	}
	NSURLCache *cache = [NSURLCache sharedURLCache];
	NSURLRequest *request = [NSURLRequest requestWithURL:cakeURL];
	NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
	if (response != nil) {
		[self presentCakeImageWithData:response.data];
		return;
	}
	
	self.task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (error == nil && response != nil && data != nil) {
			NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response
																						   data:data];
			[cache storeCachedResponse:cachedResponse forRequest:request];
			[self presentCakeImageWithData:data];
		}
	}];
	[self.task resume];
}

- (void)stopPresentingCakeImage {
	self.cakeImageView.image = nil;
	[self.task cancel];
	self.task = nil;
}

@end
