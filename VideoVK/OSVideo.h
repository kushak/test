//
//  OSVideo.h
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OSVideo : NSObject

@property (strong, nonatomic) NSString* videoID;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* duration;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* videoURL;
@property (strong, nonatomic) UIImage* image;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

- (void) downloadImage: (void(^)(UIImage* image)) completion;

@end
