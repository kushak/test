//
//  OSVideo.m
//  VideoVK
//
//  Created by user on 18.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

#import "OSVideo.h"
#import "OSServerManager.h"

@implementation OSVideo

- (id) initWithServerResponse:(NSDictionary*) responseObject {
    self = [super init];
    if (self) {
        self.videoID = [responseObject objectForKey:@"id"];
        self.title = [responseObject objectForKey:@"title"];
        self.duration = [self timeFormatted:[[responseObject objectForKey:@"duration"] integerValue]];
        self.imageURL = [NSURL URLWithString: [responseObject objectForKey:@"photo_130"]];
        self.videoURL = [NSURL URLWithString: [responseObject objectForKey:@"player"]];
    }
    return self;
}

- (NSString *)timeFormatted:(NSInteger)seconds {
    int hour = 0;
    int minute = seconds/60.0f;
    int second = seconds % 60;
    if (minute > 59) {
        hour = minute/60;
        minute = minute%60;
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    }
    else{
        return [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
}

- (void) downloadImage: (void(^)(UIImage* image)) completion {
    [[OSServerManager sharedManager] getImage:self.imageURL onSuccess:^(UIImage *image) {
        if (completion) {
            self.image = image;
            completion(image);
        }
    } onFailure:^{
        NSLog(@"Download image - fail");
    }];
}


@end
